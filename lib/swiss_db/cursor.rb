# SwissDB Cursor
# Helps move around a result set
# Convenience methods over the standard cursor
# Used by Swiss DataStore

# class CursorModel # won't use model properties (custom methods)

#   def initialize(h)
#     h.each do |k,v|
#       instance_variable_set("@#{k}", v)
#     end
#   end

#   def method_missing(methId, *args)
#     str = methId.id2name
#     instance_variable_get("@#{str}")
#   end

# end

class Cursor

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

  def model
    @model
  end

  def first
    return nil if count == 0
    cursor.moveToFirst ? self : nil
    model.new(to_hash, cursor)
  end

  def last
    return nil if count == 0
    cursor.moveToLast ? self : nil
    model.new(to_hash, cursor)
  end

  def [](pos)
    return nil if count == 0
    cursor.moveToPosition(pos) ? self : nil
    model.new(to_hash, cursor)
  end

  def to_hash
      hash_obj = {}
      $current_schema[model.table_name].each do |k, v|
        hash_obj[k.to_sym] = self.send(k.to_sym)
      end
      hash_obj
  end

  def to_a
    return nil if count == 0
    arr = []
    (0...count).each do |i|
      # puts i
      cursor.moveToPosition(i)
      arr << model.new(to_hash, cursor)
    end
    arr
  end

  # todo: take out setter code. it's not used anymore. leave the getter code. it is used. (see #to_hash)

  def method_missing(methId, *args)
    method_name = methId.id2name
    # puts "cursor method missing #{method_name}"
    if valid_setter_getter?(method_name)
      handle_get_or_set(method_name, args)
    elsif model.respond_to?(method_name) # so model methods work
      # puts "model responds to method. calling."
      called = model.send(method_name.to_s)
      # puts called
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
