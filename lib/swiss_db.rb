# -*- coding: utf-8 -*-
# SwissDB by jsilverMDX

def setup_schema(app)
  require 'schema_tools/schema_builder'
  require 'schema_tools/sql_writer'
  schema = SwissDB::SchemaBuilder.build_schema(app)
  SwissDB::SQLWriter.create_schema_sql(schema, app)
  # TODO
  # migrations = SwissDB::MigrationsBuilder.build_migrations
  # SwissDB::SQLWriter.create_migration_sql(migrations)
end

if defined?(Motion) && defined?(Motion::Project::Config)

  lib_dir_path = File.dirname(__FILE__)

  Motion::Project::App.setup do |app|
    setup_schema(app) # need this app variable to get proper directory names

    # unless platform_name == "android"
    #   raise "Sorry, the platform #{platform_name} is not supported by SwissDB"
    # end

    # scans app.files until it finds app/ (the default)
    # if found, it inserts just before those files, otherwise it will insert to
    # the end of the list
    insert_point = app.files.find_index { |file| file =~ /^(?:\.\/)?app\// } || 0

    # Specify which folders to put into the app
    swiss_db_files = Dir.glob(File.join(lib_dir_path, "/swiss_db/**/*.rb"))
    motion_files = Dir.glob(File.join(lib_dir_path, "/motion-support/**/*.rb"))

    (swiss_db_files + motion_files).each do |file|
      app.files.insert(insert_point, file)
    end

    # puts "APP FILES: #{app.files.inspect}"
  end
end
