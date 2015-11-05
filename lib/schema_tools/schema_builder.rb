# load code for `tableize` here since this file is called outside of RubyMotion
require 'motion-support/inflector/methods'
require 'motion-support/inflector/inflections'
require 'motion-support/array'
require 'motion-support/string'
require 'motion-support/default_inflections'

module SchemaTools
  class SchemaBuilder

    def self.build_schema(app)
      schema_filename = File.join(app.project_dir, 'schemas/schema.rb')
      dsl = new
      dsl.instance_eval(File.read(schema_filename))
      dsl.schema_hash
    end

    attr_accessor :schema_hash

    def schema(opts, &block)
      raise 'schema must specify version with a hash' unless opts[:version]
      @schema_hash = opts
      block.call
    end

    def entity(class_name, opts={}, &block)
      # set default opts and merge passed in opts
      @opts = { id: true }.merge opts
      init_table(class_name)
      block.call
      ensure_primary_key
    end

    def init_table(class_name)
      @current_table = class_name.tableize
      @schema_hash[@current_table] = {}
    end

    def ensure_primary_key
      # Check that the schema has one and only one primary key somewhere
      table_schema = @schema_hash[@current_table]
      valid_table = false
      if @opts[:id]
        table_schema['id'] = 'INTEGER PRIMARY KEY AUTOINCREMENT' unless table_schema.has_key? 'id'
      else
        primary_keys = table_schema.values.select{ |val| val.include? 'PRIMARY KEY' }
        raise_primary_keys_error(table_schema.keys) unless primary_keys.length == 1
      end
    end

    def add_column(name, type)
      if @opts[:id] && name == 'id'
        raise_id_error unless type == 'INTEGER'
        type << ' PRIMARY KEY AUTOINCREMENT'
      end
      @schema_hash[@current_table][name] = type
    end

    %w(boolean float double integer datetime).each do |type|
      define_method(type) do |*args|
        column_name = args.first
        column_opts =  args[1].is_a?(Hash) ? args[1] : {}
        type = type.upcase
        type = add_primary(type, column_name) if column_opts[:primary_key]
        add_column column_name.to_s, type
      end
    end

    def string(column_name, column_opts={})
      type = 'VARCHAR'
      type = add_primary(type, column_name) if column_opts[:primary_key]
      add_column column_name.to_s, type
    end

    def integer32(column_name, column_opts={})
      type = 'INTEGER'
      type = add_primary(type, column_name) if column_opts[:primary_key]
      add_column column_name.to_s, type
    end

    def raise_id_error
      error_message = %Q(
  Your schema defines a non integer `id` column for #{@current_table}.
  If you do not wish to use the default id column, then you should
  specify the `id: false` option.
  )
      raise error_message
    end

    def raise_primary_keys_error(primary_keys)
      error_message = %Q(

  Your schema specified `id: false` for #{@current_table} and therefore must
  specify one primary key for this table. Instead you specified #{primary_keys.length}.

  )
      error_message += "These are the keys you gave: #{primary_keys}\n" if primary_keys.length > 1
      raise error_message
    end

    def add_primary(type, name)
      if @opts[:id]
        puts "SWISS DB WARNING: ignoring primary_key: #{name} because `id` is the default primary key"
      else
        type << ' PRIMARY KEY'
        type << ' AUTOINCREMENT' if type == 'INTEGER PRIMARY KEY'
      end
      type
    end
  end
end
