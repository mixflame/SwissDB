module SwissDB
  class << self

    attr_accessor :store, :context, :resources

    DB_NAME = 'swissdb'

    def setup(context)
      @context = context
      @resources = context.getResources
      version = get_version_from_raw
      @store = DataStore.new(context, DB_NAME, nil, version)
    end

    def get_version_from_raw
      # Since we don't have access to R::Raw here we'll need to find it the hard way
      resource_id = find_resource('version', 'raw')
      # raw resources return input streams which means we need readers
      stream = resources.openRawResource(resource_id)
      is_reader = Java::IO::InputStreamReader.new(stream)
      reader = Java::IO::BufferedReader.new(is_reader)
      begin
        version = reader.readLine
      rescue
        raise 'Error reading schema version'
      ensure
        [stream, is_reader, reader].each(&:close)
      end
      version.to_i
    end

    def create_tables_from_schema(db)
      # Since we don't have access to R::Raw here we'll need to find it the hard way
      resource_id = find_resource('schema', 'raw')
      # raw resources return input streams which means we need readers
      stream = resources.openRawResource(resource_id)
      is_reader = Java::IO::InputStreamReader.new(stream)
      reader = Java::IO::BufferedReader.new(is_reader)
      begin
        execute_sql_script(db, reader)
      rescue
        raise 'Error reading schema SQL'
      ensure
        [stream, is_reader, reader].each(&:close)
      end
    end

    private

    def find_resource(name, type)
      package_name = PMApplication.current_application.package_name
      resources.getIdentifier(name, type, package_name)
    end

    def execute_sql_script(db, reader)
      # is there a better way?
      sql = ''
      line = ''
      while line = reader.readLine
        sql << line
        if line[-1] == ';'
          db.execSQL(sql)
          sql = ''
        end
      end
    end

  end
end
