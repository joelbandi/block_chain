require_relative 'block'
require 'forwardable'

class Chain
  extend Forwardable
  
  attr_accessor :chain
  def_delegators :chain, :last

  def initialize
    @chain = []
    add_block('genesis_block', index: 0, previous_hash: '0000')
  end

  def add_block(data, index: chain.length + 1, previous_hash: chain.last.hash)
    block = Block.new(
      index: index,
      previous_hash: previous_hash,
      data: data,
    )

    @chain << mine!(block)
  end

  private

  def mine!(new_block)
    new_block.nonce = 0

    until new_block.hash.slice(0, 4) == '0000'
      new_block.nonce = new_block.nonce + 1
    end

    new_block
  end
end
