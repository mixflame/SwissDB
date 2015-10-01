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

Schemas are the exact same from CoreDataQuery and go in the same place. (schemas/)

Schema name does nothing.

```

Models are as such:

```ruby
class Model < SwissModel

  set_class_name "Model" # there are currently no hacks to automatically get this. sorry.
  set_primary_key "primary_key_name" # if not set, will default to "id"

end
```

Don't forget to set $app_context in your bluepotion_application.rb. Don't panic. This won't be a global in the next release.

```ruby
class BluePotionApplication < PMApplication

  home_screen HomeScreen

  def on_create
    $app_context = self
  end
end
```

That's it! #all, #last, #first, #count, #save, #update_attributes and the usual are now available!

KNOWN LIMITATION: This ORM compiles in the database name and the database version as a constant. Unfortunately I don't know of a way around this yet. This means no DB migrations yet by doing the simple version bump that is supported by Android. If we get a way to configure these from outside the gem, it will open up possibilities such as multiple schemas and migrations. To get around this simply delete your local database when you need to migrate. You can delete the app from the simulator/device (probably) or use my convenience command:

```ruby
   DataStore.new($app_context).drop_db #=> true if the DB was dropped, false if not
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jsilverMDX/swiss_db.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

