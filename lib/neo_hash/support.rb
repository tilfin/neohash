class NeoHash
  # Provides attribute readers and Hash features
  # A class that includes this has `@h` as inner hash.
  # @example
  #   class DynamicObject
  #     include NeoHash::Support
  #     
  #     def initialize(hash)
  #       set_inner_hash(hash)
  #     end
  #   end
  # 
  #   obj = DynamicObject.new({ port: 80, "host" => "localhost" })
  #   p obj.port   # 80
  #   p obj[:host] # "localhost"
  #   obj[:host] = "192.168.1.1"
  #   p obj.host   # "192.168.1.1"
  module Support
    # @see Hash#[]
    def [](key)
      @h[key.to_sym]
    end

    # @see Hash#[]=
    def []=(key, value)
      sk = key.to_sym
      define_attr_accessor(sk) unless @h.key?(sk)
      @h[sk] = convert_val(value)
    end

    # @see Hash#include?
    def include?(key)
      @h.include?(key.to_sym)
    end

    alias_method :has_key?, :include?
    alias_method :key?, :include?
    alias_method :member?, :include?

    # @see Hash#delete
    def delete(key, &block)
      @h.delete(key.to_sym, &block)
    end

    # @see Hash#fetch
    def fetch(*args, &block)
      args[0] = args[0].to_sym
      @h.fetch(*args, &block)
    end

    def method_missing(method, *args, &block)
      if Hash.public_method_defined?(method)
        @h.send method, *args, &block
      else
        super
      end
    end

    # Convert to original Hash
    #
    # @return [Hash] hash
    # @param [Hash] opts the options to intialize
    # @option opts [String] :symbolize_keys (true) whether symbolize names or not
    def to_h(opts = {})
      symbolize = opts.fetch(:symbolize_keys, true)

      @h.map {|key, val|
        [symbolize ? key : key.to_s, to_primitive(val, opts)]
      }.to_h
    end

    # Implicitly convert to Hash
    # @return [Hash] generated hash
    def to_hash
      to_h
    end

    protected

    # Set inner hash and replace hashes in descendant with wrapping them recursively
    def set_inner_hash(hash)
      @h = coerce_hash(hash)
      define_attr_accessors
    end

    private

    def define_attr_accessors
      @h.each_key {|name| define_attr_accessor(name) }
    end

    def define_attr_accessor(name)
      define_singleton_method name, lambda { @h[name] }
      define_singleton_method "#{name}=", lambda {|val| @h[name] = convert_val(val) }
    end

    def coerce_hash(hash)
      {}.tap do |new_h|
        hash.each do |name, val|
          new_h[name.to_sym] = convert_val(val)
        end
      end
    end

    def convert_val(val)
      return NeoHash.new(val) if val.instance_of?(Hash)
      return val.map {|item| convert_val(item) } if val.instance_of?(Array)
      val
    end

    def to_primitive(val, opts)
      return val.to_h(opts) if val.is_a?(NeoHash)
      return val.map {|item| to_primitive(item, opts) } if val.is_a?(Array)
      val
    end
  end

  include Support
end
