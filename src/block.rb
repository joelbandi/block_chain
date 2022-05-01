require 'digest'
require 'json'
require 'colorize'

class Block
  attr_accessor :index, :data, :nonce, :previous_hash, :timestamp

  def initialize(index:, data:, nonce:, previous_hash:)
    @index = index
    @data = data
    @nonce = nonce
    @previous_hash = previous_hash
    @timestamp = Time.now.utc.to_i 
  end

  def hash
    Digest::SHA256.hexdigest(serialize.to_json)
  end

  def to_s
    <<~TEXT
      #{"-" * 80}
      current hash: #{hash.to_s.light_blue.bold}
      index: #{index.to_s.yellow.bold}
      data: #{data.to_s.green.bold}
      nonce: #{nonce.to_s.red.bold}
      previous hash: #{previous_hash.to_s.light_blue.bold}
      timestamp: #{Time.at(timestamp).to_s}
      #{"-" * 80}
    TEXT
  end

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
