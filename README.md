[![endorse](https://api.coderwall.com/jsilverMDX/endorsecount.png)](https://coderwall.com/jsilverMDX)

# SwissDb

RubyMotion Android ActiveRecord-like ORM for SQLite. **Known to work on RM 4.4 and not work on RM 4.5** A bug report has been submitted so we'll update this when that gets fixed.

## Example

See: https://github.com/KCErb/swissdb_debug

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'swiss_db'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install swiss_db

## Usage

# Schemas

Schemas go in the project root under `schemas/`. You can stash multiple schema files here for your own records (`schema1.rb`, `schema2.rb`, etc.) but the schema your app actually uses must be named `schema.rb`.

We're attempting to support both Core Data Query and Active Record type specifications like `datetime` `integer32` and `integer`. In SQLite there are only a few types anyways so that `integer32` and `integer` get created the same.

```ruby
schema version: 1 do

    entity "Car" do
      boolean   :is_red
      string    :model
      integer32 :tire_size
      integer32 :tire_weight
      integer32 :mileage
    end

    entity "Boat" do
      string    :name
      integer32 :weight
      double    :worth_in_millions
    end

end
```

### Schema Version and Migrations

You must specify a version with your schema. This integer (which must start at 1) is stored internally to the SQLite database and is used to determine if migrations need to be run.

Migrating your database is not yet supported by SwissDB but is the next thing on the To-Do list.

# Models

Models are as such:

```ruby
class Model < SwissDB::SwissModel

  set_class_name "Model" # there are currently no hacks to automatically get this. sorry.
  set_primary_key "primary_key_name" # if not set, will default to "id"

end
```

# Setup SwissDB

Since SwissDB needs to use your app's context you need to help it get setup like so:

```ruby
class BluePotionApplication < PMApplication

  home_screen HomeScreen

  def on_create
    SwissDB.setup(self)
  end
end
```

# Examples

```ruby
  Model.first.name
  Model.all.last.name
  Model.all.count
  Model.find_by_<column>("some value") # dynamic finders
  Model.create(hash_values) # returns created model
  m = Model.first
  m.name = "Sam" # changed values will persist in the model instance
  m.save # will persist the data to the database
  m.update_attribute("name", "chucky")
  m = Model.new
  m.thing = "stuff"
  m.save # upsert, (insert if doesn't exist, and update if does)
```


That's it! #all, #last, #first, #count, #save, #update_attribute and the usual are now available!

As of 0.7.1 all returned objects are SwissModel instances. Model methods will now work properly.

# Planned

* update_attributes support

* destroy just one object support

* detect class names of models for tableize

KNOWN LIMITATION: No DB migrations yet by doing the simple version bump that is supported by Android. To get around this simply delete your local database when you need to migrate. You can delete the app from the simulator/device (probably) or use this convenience command:

```ruby
   SwissDB::DataStore.drop_db #=> true if the DB was dropped, false if not
```

## Contributors


## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jsilverMDX/swissDB.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
