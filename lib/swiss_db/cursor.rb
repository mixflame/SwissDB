# SwissDB Cursor
# Helps move around a result set
# Convenience methods over the standard cursor
# Used by Swiss DataStore

class Cursor

  FIELD_TYPE_BLOB = 4
  FIELD_TYPE_FLOAT = 2
  FIELD_TYPE_INTEGER = 1
  FIELD_TYPE_NULL = 0
  FIELD_TYPE_STRING = 3

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

  def count
    cursor.getCount
  end

  def method_missing(methId, *args)
    str = methId.id2name
    if args.count == 0
      index = cursor.getColumnIndex(str)
      type = cursor.getType(index)
      puts "getting field #{str} at index #{index} of type #{type}"
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
    elsif args.count == 1
      # assignment... add to values to save
      @values[str.gsub!("=", "")] = args[0]
    end
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


end