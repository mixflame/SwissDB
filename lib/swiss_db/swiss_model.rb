# Swiss Model
# An ActiveRecord like Model for RubyMotion Android
module SwissDB
  class SwissModel

    # meh? .. won't work for now in java... created classes become java packages
    # name will become the namespace of the package...
    # def self.inherited(subclass)
    #    puts "New subclass: #{subclass.class.name.split('.').last}"
    # end

    attr_accessor :values

    def initialize(h={})
      h.each do |k,v|
        instance_variable_set("@#{k}", v)
      end
      @new_record = (h == {}) # any loaded record should have atleast SOME data
      @values = {}
    end

    def self.method_missing(methId, *args)
      str = methId.id2name
      if str.include?("find_by")
        where(str.split("find_by_")[1] => args[0]).first
      end
    end

    def method_missing(methId, *args)
      str = methId.id2name
      if instance_variable_get("@#{str}")
        return instance_variable_get("@#{str}")
      elsif str[-1] == '=' # setter
        instance_variable_set("@#{str.chop}", args[0])
        @values[str.chop] = args[0]
      end
    end

    def new_record?
      @new_record
    end

    def save
      unless new_record?
        store.update(table_name,
                     @values,
                     {primary_key => primary_key_value})
      else
        store.insert(table_name,
                     @values)
      end
    end

    def update_attribute(key, value)
      store.update(table_name,
                   {key => value},
                   {primary_key => primary_key_value})
    end

    def update_attributes(hash)
      hash.each { |k, v| update_attribute(k, v) }
    end

    def primary_key
      self.class.primary_key
    end

    def primary_key_value
      self.send(primary_key.to_sym)
    end

    def table_name
      self.class.table_name
    end

    def store
      self.class.store
    end

    # def destroy
    #   # destroy this row
    # end

    # -------------
    # CLASS METHODS
    # -------------
    class << self
      def store
        SwissDB.store
      end

      def class_name
        @class_name
      end

      def set_class_name(class_name) # hack, class.name not functioning in RM Android...
        @class_name = class_name
        set_table_name(class_name.tableize)
      end

      def set_table_name(table_name)
        @table_name = table_name
      end

      def table_name
        @table_name
      end

      def set_primary_key(primary_key)
        @primary_key = primary_key
      end

      def primary_key
        @primary_key.nil? ? "id" : @primary_key
      end

      def all
        # select_all
        cursor = store.select_all(@table_name, self)
        cursor
      end

      def where(values)
        # select <table> where <field> = <value>
        cursor = store.select(@table_name, values, self)
        cursor
      end

      def first
        # select all and get first
        model = all.first
        model
      end

      def last
        # select all and get last
        model = all.last
        model
      end

      def create(obj)
        # create a row
        result = store.insert(@table_name, obj)
        if result == -1
          puts "An error occured inserting values into #{@table_name}"
        else
          return self.where(primary_key => result.intValue).first
        end
      end

      def destroy_all!
        # destroy all of this kind (empty table)
        store.destroy_all(@table_name)
      end
    end

  end
end
