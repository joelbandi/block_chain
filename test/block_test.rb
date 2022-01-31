require 'test_helper'

class BlockTest < Minitest::Test
  def test_sanity
    block = Block.new(
      index: 0,
      data: 'some data',
      nonce: 23,
      previous_hash: '1234567890',
    )

    assert_equal 0, block.index
    assert_equal 'some data', block.data
    assert_equal 23, block.nonce
    assert_equal '1234567890', block.previous_hash
  end
end
