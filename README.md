# NeoHash

[![Gem Version](https://badge.fury.io/rb/neohash.svg)](https://badge.fury.io/rb/neohash)
[![Build Status](https://travis-ci.org/tilfin/neohash.svg?branch=master)](https://travis-ci.org/tilfin/neohash)
[![Code Climate](https://codeclimate.com/github/tilfin/neohash/badges/gpa.svg)](https://codeclimate.com/github/tilfin/neohash)
[![Test Coverage](https://codeclimate.com/github/tilfin/neohash/badges/coverage.svg)](https://codeclimate.com/github/tilfin/neohash/coverage)

Accessible Hash and attaching it to an Object

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'neohash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install neohash

## Usage

```ruby
class DynamicObject
  include NeoHash::Support
  
  def initialize(hash)
    set_inner_hash(hash)
  end
end

obj = DynamicObject.new({ port: 80, "host" => "localhost" })
p obj.port   # 80
p obj[:host] # "localhost"
obj[:host] = "192.168.1.1"
p obj.host   # "192.168.1.1"
```

## License

  [MIT](LICENSE)
