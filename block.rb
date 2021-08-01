require 'digest'
require 'json'

class Block
  attr_reader :data
  attr_accessor :nonce

  def initialize(index:, data:, previous_hash:, nonce: nil)
    @index = index
    @nonce = nonce
    @data = data
    @timestamp = Time.now.utc.to_i 
    @previous_hash = previous_hash
  end

  def hash
    Digest::SHA256.hexdigest(serialize.to_json)
  end

  private

  def serialize
    {
      index: @index,
      nonce: @nonce,
      data: data,
      timestamp: @timestamp,
      previous_hash: @previous_hash
    }
  end
end
