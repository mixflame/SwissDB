# Swiss Model
# An ActiveRecord like Model for RubyMotion Android

class SwissModel

  # meh? .. won't work for now in java... created classes become java packages
  # name will become the namespace of the package...
  # def self.inherited(subclass)
  #    puts "New subclass: #{subclass.class.name.split('.').last}"
  # end

  # attr_accessor :table_name, :class_name

  def self.store
    context = DataStore.context
    @store ||= DataStore.new(context)
    @store
  end

  def self.class_name
    @class_name
  end

  def self.set_class_name(class_name) # hack, class.name not functioning in RM Android...
    @class_name = class_name
    set_table_name(class_name.tableize)
  end

  def self.set_table_name(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name
  end

  def self.set_primary_key(primary_key)
    @primary_key = primary_key
  end

  def self.primary_key
    @primary_key.nil? ? "id" : @primary_key
  end

  def self.all
    # select_all
    cursor = store.select_all(@table_name, self)
    cursor
  end

  def self.where(values)
    # select <table> where <field> = <value>
    cursor = store.select(@table_name, values, self)
    cursor
  end

  def self.first
    # select all and get first
    cursor = all.first
    cursor
  end

  def self.last
    # select all and get last
    cursor = all.last
    cursor
  end

  def self.create(obj)
    # create a row
    result = store.insert(@table_name, obj)
      if result == -1
        puts "An error occured inserting values into #{@table_name}"
      else
        return result
      end
  end

  # def destroy
  #   # destroy this row
  # end

  def self.destroy_all!
    # destroy all of this kind (empty table)
    store.destroy_all(@table_name)
  end

end