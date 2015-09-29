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

Schemas are the exact same from CoreDataQuery and go in the same place.

Models are as such:

```ruby
class Model < SwissModel

  set_table_name "model"
  set_primary_key "primary_key_name"

end
```

That's it! #all, #last, #first, #count, #save, #update_attributes and the usual are now available!

## Development

After checking out the repo, run `bin/setup` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jsilverMDX/swiss_db.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

