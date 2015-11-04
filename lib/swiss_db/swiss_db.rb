module SwissDB
  class << self

    attr_accessor :store, :context, :resources

    def setup(context)
      @context = context
      @resources = context.getResources
      @store = DataStore.new(context)
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
