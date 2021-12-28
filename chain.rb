require_relative 'block'
require 'forwardable'

class Chain
  attr_accessor :chain, :proof_of_work
  
  extend Forwardable
  def_delegators :chain, :last

  def initialize(&proof_of_work)
    proof_of_work ||= proc { |unmined_block| unmined_block.hash.start_with?('0000') }
    
    @chain = []
    @proof_of_work = proof_of_work
    add_block('genesis_block', index: 0, previous_hash: '0000')
  end

  def add_block(data, index: chain.length + 1, previous_hash: chain.last.hash)
    block = Block.new(
      index: index,
      previous_hash: previous_hash,
      data: data,
    )

    @chain << mine(block)
  end

  def valid?
    chain.all? { |block| proof_of_work.call(block) }
  end

  private

  def mine(new_block)
    new_block.nonce = 0

    until proof_of_work.call(new_block)
      new_block.nonce = new_block.nonce + 1
    end

    new_block
  end
end
