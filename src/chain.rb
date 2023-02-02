require 'concurrent/array'
require_relative 'block'

class Chain
  include Enumerable

  attr_accessor :chain, :proof_of_work

  def initialize(&proof_of_work)
    proof_of_work ||= proc { |unmined_block| unmined_block.hash.start_with?('0000') }

    @chain = Concurrent::Array.new
    @proof_of_work = proof_of_work
  end

  def add_block(data)
    new_block = Block.new(
      index: count,
      data: data,
      nonce: 0,
      previous_hash: chain.empty? ? '' : chain.last.hash,
    )

    mine(new_block)
  end

  def each(&block)
    chain.each(&block)
  end

  def to_s
    delimiter = [
      "|".rjust(38),
      "|".rjust(38),
      "v".rjust(38),
      "",
    ].join("\n")

    map(&:to_s).join(delimiter)
  end

  def valid?
    each_cons(2).all? do |a, b|
      next false unless a.is_a?(Block)
      next false unless proof_of_work.call(a)

      next true if b.nil?
      
      next false unless b.is_a?(Block)
      next false unless proof_of_work.call(b)

      a.hash == b.previous_hash
    end
  end

  def serialize
    map(&:serialize)
  end

  def self.deserialize(source)
    instance = new

    source.each do |block_data|
      instance.chain << Block.new(
        index: block_data[:index],
        nonce: block_data[:nonce],
        data: block_data[:data],
        timestamp: block_data[:timestamp],
        previous_hash: block_data[:previous_hash]
      )
    end

    instance if instance.valid?
  end

  private

  def mine(new_block)
    until proof_of_work.call(new_block)
      new_block.nonce = new_block.nonce.next
    end

    (chain << new_block).last
  end
end
