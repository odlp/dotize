# Dotize

[![Build Status](https://travis-ci.org/odlp/dotize.svg?branch=master)](https://travis-ci.org/odlp/dotize)

Access values from a deeply-nested Hash using a simple string:

```ruby
my_hash = {'a' => {'b' => {'c' => 123}}}
my_hash.extend(Dotize)
my_hash.dot('a.b.c') # => 123
```

If a value isn't found, nil is returned by default:

```ruby
my_hash.dot('a.b.z.z.z') # => nil
```

You can provide a block to override the default, like Ruby's [Hash#fetch](http://ruby-doc.org/core-2.3.0/Hash.html#method-i-fetch):

```ruby
my_hash.dot('a.b.z.z.z') { |el| 2 + 2 } # => 4
```

## Development

- Run specs via `rake` or `bundle exec rspec`

## Credits

The name of this is ~~inspired-by~~ copied from [github.com/vardars/dotize](https://github.com/vardars/dotize), a Javascript equivalent.
