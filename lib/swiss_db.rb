# -*- coding: utf-8 -*-
# SwissDB by jsilverMDX

def setup_schema(app)
  require 'schema_tools/schema_builder'
  require 'schema_tools/sql_writer'
  schema = SchemaTools::SchemaBuilder.build_schema(app)
  SchemaTools::SQLWriter.create_schema_sql(schema, app)
  # TODO
  # migrations = SwissDB::MigrationsBuilder.build_migrations
  # SwissDB::SQLWriter.create_migration_sql(migrations)
end

def building_app?(args)
  # Don't write the schema to sql unless we're building the app
  intersection = (args & %w(device archive build release emulator newclear)) # newclear is technically a build
  !intersection.empty? || args == ""
end

def add_app_files(app)
  lib_dir_path = File.dirname(__FILE__)
  insert_point = app.files.find_index { |file| file =~ /^(?:\.\/)?app\// } || 0

  # Specify which folders to put into the app
  swiss_db_files = Dir.glob(File.join(lib_dir_path, "/swiss_db/**/**.rb"))
  motion_files = Dir.glob(File.join(lib_dir_path, "/motion-support/**/*.rb"))

  (swiss_db_files + motion_files).each do |file|
    app.files.insert(insert_point, file)
  end
end

if defined?(Motion) && defined?(Motion::Project::Config)
  Motion::Project::App.setup do |app|
    setup_schema(app) if building_app?(ARGV)
    add_app_files(app)
  end
else
  puts 'SwissDB must be included in a BluePotion App' if ARGV[0] != "gem:install"
end
