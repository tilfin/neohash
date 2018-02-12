# Hash with attribute accessor
class NeoHash
  # Constructor
  # @param [Hash] h ({}) initial hash
  def initialize(h = {})
    set_inner_hash(h)
  end
end
