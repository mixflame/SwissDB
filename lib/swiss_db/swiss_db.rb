module SwissDB
  class << self

    attr_accessor :store, :context, :resources, :version

    DB_NAME = 'swissdb'

    def setup(context)
      @context = context
      @resources = context.getResources
      get_version_from_raw
      @store = DataStore.new(context, DB_NAME, nil, version)
    end

    def get_version_from_raw
      message = 'Error reading schema version'
      read_from_raw_resource('version', message) do |reader|
        @version = reader.readLine.to_i
      end
    end

    def create_tables_from_schema(db)
      message = 'Error reading schema SQL'
      read_from_raw_resource('schema', message) do |reader|
        execute_sql_script(db, reader)
      end
    end

    def read_from_raw_resource(resource_name, error_message, &block)
      resource_id = find_resource(resource_name, 'raw')
      stream = resources.openRawResource(resource_id)
      is_reader = Java::IO::InputStreamReader.new(stream)
      reader = Java::IO::BufferedReader.new(is_reader)
      begin
        block.call(reader)
      rescue
        raise error_message
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
