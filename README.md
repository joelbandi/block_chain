# Block Chain
My implementation of a block chain with a simple "n leading zeros" SHA256 based proof of work algorithm.
The Proof of work algorithm can also be customized in the constructor


# usage

1. `$ rake console`

2. ```ruby
     c = Chain.new # creates a new chain

     c.add_block('any_data') # adds a new block

     c.chain # returns chain

     c.last # returns last block

     c2 = Chain.new do |block_to_be_mined|
       block_to_be_mined.hash.start_with?('1234')
     end
   ```
