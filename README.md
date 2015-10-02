[![endorse](https://api.coderwall.com/jsilverMDX/endorsecount.png)](https://coderwall.com/jsilverMDX)

# SwissDb

RubyMotion Android ActiveRecord-like ORM for SQLite

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

Schemas are the exact same from CoreDataQuery and go in the same place. (schemas/)

```ruby
schema "0001" do

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

Schema name (the "0001") does nothing.

# Models

Models are as such:

```ruby
class Model < SwissModel

  set_class_name "Model" # there are currently no hacks to automatically get this. sorry.
  set_primary_key "primary_key_name" # if not set, will default to "id"

end
```

# Set the context

Set the context in your bluepotion_application.rb.

```ruby
class BluePotionApplication < PMApplication

  home_screen HomeScreen

  def on_create
    DataStore.context = self
  end
end
```

# Examples

```ruby
  Model.first.name
  Model.all.last.name
  Model.all.count
  m = Model.first
  m.name = "Sam"
  m.save # will persist the data
  m.update_attribute("name", "chucky")
```


That's it! #all, #last, #first, #count, #save, #update_attribute and the usual are now available!

# Planned

* update_attributes support

* destroy just one object support

* detect class names of models for tableize

KNOWN LIMITATION: This ORM compiles in the database name and the database version as a constant. Unfortunately I don't know of a way around this yet. This means no DB migrations yet by doing the simple version bump that is supported by Android. If we get a way to configure these from outside the gem, it will open up possibilities such as multiple schemas and migrations. To get around this simply delete your local database when you need to migrate. You can delete the app from the simulator/device (probably) or use my convenience command:

```ruby
   DataStore.drop_db #=> true if the DB was dropped, false if not
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jsilverMDX/swissDB.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

