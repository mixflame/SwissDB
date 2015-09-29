# "Swiss", RubyMotion Android SQLite by VirtualQ


# schema loader stuff
# i know it's rough but it works

class Object

  attr_accessor :current_schema

  # convenience methods

  def log(tag, str)
    Android::Util::Log.d(tag, str)
  end

  def puts(str)
    log "general", str
  end

  def current_schema
    @current_schema
  end

  def schema(schema_name, &block)
    puts "running schema for #{schema_name}"
    @current_schema = {}
    @database_name = schema_name
    block.call
    puts @current_schema.inspect
  end

  def entity(table_name, &block)
    puts "adding entity #{table_name} to schema"
    @table_name = table_name
    @current_schema[@table_name] = {}
    block.call
    $current_schema = @current_schema # there was no other way. I couldn't get context to create the model here.
  end

  def add_column(name, type)
    @current_schema[@table_name][name] = type
  end

  def boolean(column_name)
    add_column column_name.to_s, "BOOLEAN"
  end

  def string(column_name)
    add_column column_name.to_s, "VARCHAR"
  end

  def integer32(column_name)
    add_column column_name.to_s, "INTEGER"
  end

  def double(column_name)
    add_column column_name.to_s, "DOUBLE"
  end

end
