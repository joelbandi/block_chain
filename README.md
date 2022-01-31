# Block Chain
My implementation of a block chain with a simple "n leading zeros" SHA256 based proof of work algorithm.
The Proof of work algorithm can also be customized in the constructor


# Usage

1. `$ rake console`

2. ```ruby
     c = Chain.new # creates a new chain

     c.add_block('any_data') # adds a new block

     # A Chain instance is an enumerable so enumerable methods work

     c.map { |block| block.data }

     # Custom proof proof work algorithms can be implemented
     c2 = Chain.new do |block_to_be_mined|
       block_to_be_mined.hash.start_with?('1234')
     end

     # Each block has accessor methods
    attr_accessor :index, :data, :nonce, :previous_hash, :timestamp

   ```

## Story so far...

1. Create a model for how the block and chain looks

## Coming up...

2. Actual Decentralization through P2P Gossip protocol
3. Adding Byzantine fault tolerance

## Much later...Using the block chain we built above

4. Define a simple monetary policy for the block chain
5. Identity through a unique address.
6. Start supporting transactions through the network
7. Authenticity through public-private keys
8. Mining rewards in the form of tokens/coins
