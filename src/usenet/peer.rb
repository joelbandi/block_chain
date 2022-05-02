require 'concurrent/array'
require 'faraday'
require 'json'
require "logger"
require 'sinatra'

require_relative '../chain'

Thread.abort_on_exception = true
LOGGER = Logger.new(STDOUT)

class Peer
  attr_reader :port, :name
  attr_accessor :neighbors, :chain

  def initialize(port:, name:)
    @port = port
    @name = name
    @neighbors = Concurrent::Array.new
    @chain = Chain.new
  end

  def register!(discovery_service_url = 'http://localhost:9999')
    response = Faraday.post(discovery_service_url + '/peer', {
      name: name,
      port: port,
    }).body

    raise StandardError.new(response) unless response == 'OK'
  end

  def ask_discovery_service_for_neighbors(discovery_service_url = 'http://localhost:9999')
    new_neighbors = Faraday
      .get(discovery_service_url + '/peers')
      .body
      .then do |body| 
        JSON.parse(body).keys.reject{ |neighboring_port| port == neighboring_port }
      end

    return unless new_neighbors

    neighbors.concat(new_neighbors).uniq!
    LOGGER.info "Current pool of neighbors are #{neighbors}"
  end

  def ask_neighbors_for_data
    neighbors.each do |neighbor|
      LOGGER.info "Requesting #{neighbor} for data"

      their_chain = Faraday
        .get("http://localhost:#{neighbor}/gossip")
        .body
        .then do |json|
          begin
            Chain.deserialize(JSON.parse(json))
          rescue
            nil
          end
        end

      next unless their_chain
      next if their_chain.count <= chain.count

      LOGGER.info "Chain updated with data from #{neighbor}"

      chain = their_chain
    end
  end
end

port = ARGV[0]
name = ARGV[1]

unless port
  LOGGER.fatal "Please provide port number as an argument"
  exit 1
end

current = Peer.new(port: port, name: name)
current.register!

Thread.new do
  loop do
    sleep 30
    current.ask_discovery_service_for_neighbors
  end
end

Thread.new do
  loop do
    sleep 15
    current.ask_neighbors_for_data
  end
end

# Add random data 50% of the time
# Thread.new do
#   loop do
#     sleep 15
#     if rand(2).even?
#       current.chain.add_block(('a'..'z').to_a.sample(6).join)
#       LOGGER.info "Adding random data to the chain. Chain length is now #{current.chain.count}"
#     end
#   end
# end

set :port, port.to_i
set :lock, true
set :default_content_type, :json

get '/gossip' do
  current.chain.serialize
end
