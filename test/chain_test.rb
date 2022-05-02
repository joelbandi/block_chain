require 'test_helper'

class ChainTest < Minitest::Test
  def test_serialize_deserialize
    chain = Chain.new

    chain.add_block("123")
    chain.add_block("12345")
    chain.add_block("12345678")

    serialized = chain.serialize

    unserialized = Chain.deserialize(serialized)

    chain.zip(unserialized).each do |a, b|
      assert_equal a.serialize, b.serialize
    end
  end
end
