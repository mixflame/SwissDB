# SwissDB Cursor
# Helps move around a result set
# Convenience methods over the standard cursor
# Used by Swiss DataStore

class CursorModel

  def initialize(h)
    h.each do |k,v|
      instance_variable_set("@#{k}", v)
    end
  end

  def method_missing(methId, *args)
    str = methId.id2name
    instance_variable_get("@#{str}")
  end

end

class Cursor # < Array

  FIELD_TYPE_BLOB    = 4
  FIELD_TYPE_FLOAT   = 2
  FIELD_TYPE_INTEGER = 1
  FIELD_TYPE_NULL    = 0
  FIELD_TYPE_STRING  = 3

  attr_accessor :cursor, :model

  def initialize(cursor, model)
    @cursor = cursor
    @model = model
    @values = {}
  end

  def first
    cursor.moveToFirst ? self : nil
  end

  def last
    cursor.moveToLast ? self : nil
  end

  def [](pos)
    cursor.moveToPosition(pos) ? self : nil
  end

  def to_a
    arr = []
    (0...count).each do |i|
      # puts i
      hash_obj = {}
      cursor.moveToPosition(i)
      $current_schema[model.table_name].each do |k, v|
        hash_obj[k.to_sym] = self.send(k.to_sym)
      end
      arr << CursorModel.new(hash_obj)
    end
    arr
  end

  def method_missing(methId, *args)
    method_name = methId.id2name

    if valid_setter_getter?(method_name)
      handle_get_or_set(method_name, args)
    else
      super
    end
  end

  def valid_setter_getter?(method_name)
    method_name.chop! if is_setter? method_name
    column_names.include? method_name
  end

  def handle_get_or_set(method_name, args)
    if is_setter? method_name
      set_method(args)
    else
      get_method(method_name)
    end
  end

  def is_setter?(method_name)
    method_name[-1] == '='
  end

  def get_method(method_name)
    index = cursor.getColumnIndex(method_name)
    type = cursor.getType(index)
    # puts "getting field #{method_name} at index #{index} of type #{type}"

    if type == FIELD_TYPE_STRING
      cursor.getString(index)
    elsif type == FIELD_TYPE_INTEGER
      cursor.getInt(index)
    elsif type == FIELD_TYPE_NULL
      nil #??
    elsif type == FIELD_TYPE_FLOAT
      cursor.getFloat(index)
    elsif type == FIELD_TYPE_BLOB
      cursor.getBlob(index)
    end
  end

  def set_method(method_name, args)
    @values[method_name.chop] = args[0]
  end

  def save
    primary_key = model.primary_key
    pk_value = self.send(primary_key.to_sym)
    model.store.update(model.table_name, @values, {primary_key => pk_value})
  end

  # we are updating an existing row.. makes more sense on cursor...
  def update_attribute(key, value)
    primary_key = model.primary_key
    pk_value = self.send(primary_key.to_sym)
    model.store.update(model.table_name, {key => value}, {primary_key => pk_value})
  end

  def count
    cursor.getCount
  end

  def column_names
    cursor.getColumnNames
  end

end
