module SchemaTools
  module Writer
    class << self
      attr_accessor :schema, :app

      def create_schema_sql(schema, app)
        @schema = schema
        @app = app
        write_schema_file
      end

      def write_version_file(version, app)
        # TODO: Version checking, android expects monotonically increasing version ints
        filename = File.join(app.resources_dirs.first, 'raw', 'version')
        write_raw_resource_file(filename, version)
      end

      def write_schema_file
        sql = ''

        schema.each do |table_name, fields|
          fields_string = fields.map { |k, v| "  #{k}   #{v}" }.join(",\n")
          sql += "CREATE TABLE #{table_name}(\n#{fields_string}\n);\n\n"
        end

        filename = File.join(app.resources_dirs.first, 'raw', 'schema.sql')
        write_raw_resource_file(filename, sql)
      end

      def write_raw_resource_file(filename, content)
        # create raw directory if it doesn't exist
        FileUtils.mkdir_p(File.dirname(filename))
        File.write(filename, content)
      end
    end
  end
end
