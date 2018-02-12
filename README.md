# NeoHash

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
