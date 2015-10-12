  # main connection point
  # creates and upgrades our database for us
  # and provides low level SQL features

  class DataStore < Android::Database::SQLite::SQLiteOpenHelper

    DATABASE_NAME = "swissdb"
    DATABASE_VERSION = 1
    ContentValues = Android::Content::ContentValues

    def self.current_schema=(schema)
      @@current_schema = schema
    end

    def self.context=(context)
      @@context = context
    end

    def self.context
      @@context
    end

    def writable_db
      getWritableDatabase
    end

    def self.drop_db
      @@context.deleteDatabase(DATABASE_NAME)
    end

    def onUpgrade(db, oldVersion, newVersion)
      # maybe drop if needed...
      db.execSQL("DROP *")
      onCreate(db)
    end

    #create
    def onCreate(db)
      # puts "table creation... running schema"
      # THIS RELIES ON SCHEMA CODE TO SUCCEED
      # NOTE: I don't know a better way of passing the schema here
      # If you do just change it. For now this works.
      # Thanks.
      @@current_schema.each do |k, v|
        create_table db, k, v
      end
      # database.execSQL("CREATE TABLE credentials(username TEXT, password TEXT)")
    end

    #insert
    def insert(db=writable_db, table, hash_values)
      # puts "inserting data in #{table}"
      values = ContentValues.new(hash_values.count)
      hash_values.each do |k, v|
        values.put(k, v)
      end
      result = db.insert(table, nil, values)
      result
    end
    #retrieve
    def select_all(db=writable_db, table, model)
      sql = "select * from '#{table}'"
      puts sql
      cursor = db.rawQuery(sql, nil)
      Cursor.new(cursor, model) # we wrap their cursor
    end

    def select(db=writable_db, table, values, model)
      puts "selecting data from #{table}"
      value_str = values.map do |k, v|
        "#{k} = '#{v}'"
      end.join(" AND ")
      sql = "select * from '#{table}' where #{value_str}"
      puts sql
      cursor = db.rawQuery(sql, nil)
      Cursor.new(cursor, model) # we wrap their cursor
    end

    # update

    def update(db=writable_db, table, values, where_values)
      value_str = values.map do |k, v|
        "'#{k}' = '#{v}'"
      end.join(",")
      where_str = where_values.map do |k, v|
        "#{k} = '#{v}'"
      end.join(",")
      sql = "update '#{table}' set #{value_str} where #{where_str}"
      puts sql
      db.execSQL sql
    end

    #deleting all records

    def destroy_all(db=writable_db, table) # WARNING!
      puts "destroying all from #{table}"
      db.delete(table, nil, nil)
    end

    # create table
    def create_table(db=writable_db, table_name, fields)
      fields_string = fields.map { |k, v| "#{k} #{v}" }.join(',')
      sql = "CREATE TABLE #{table_name}(#{fields_string})"
      puts sql
      db.execSQL sql
    end


  end