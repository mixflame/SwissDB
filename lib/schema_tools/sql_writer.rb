module SchemaTools
  module SQLWriter
    class << self
      def create_schema_sql(schema, app)
        sql = ''
        schema.each do |table_name, fields|
          fields_string = fields.map { |k, v| "  #{k}   #{v}" }.join(",\n")
          sql += %Q(CREATE TABLE #{table_name}(\n#{fields_string}\n);\n\n)
        end
        filename = File.join(app.resources_dirs.first, 'raw/schema.sql')
        # create raw directory if it doesn't exist
        FileUtils.mkdir_p(File.dirname(filename))
        File.write(filename, sql)
      end
    end
  end
end
