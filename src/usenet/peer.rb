require 'concurrent/array'
require 'faraday'
require 'json'
require "logger"

Thread.abort_on_exception = true
logger = Logger.new(STDOUT)

class Peer
  attr_reader :port, :name, :chain
  attr_accessor :neighbors

  def initialize(port:, name:)
    @port = port
    @name = name
    @neighbors = Concurrent::Array.new
  end

  def register!(discovery_service_url = 'http://localhost:9999')
    response = Faraday.post(discovery_service_url + '/peer', {
      name: name,
      port: port,
    }).body

    raise StandardError.new(response) unless response == 'OK'
  end

  def fetch_neighbors(discovery_service_url = 'http://localhost:9999')
    new_neighbors = Faraday
      .get(discovery_service_url + '/peers')
      .body
      .then do |body| 
        JSON.parse(body).keys.reject{ |neighboring_port| port == neighboring_port }
      end

    return unless new_neighbors

    neighbors.concat(new_neighbors).uniq!
  end
end

port = ARGV[0]
name = ARGV[1]

unless port
  logger.fatal "Please provide port number as an argument"
  exit 1
end

current = Peer.new(port: port, name: name)
current.register!

loop do
  thread = Thread.new do
    current.fetch_neighbors

    logger.info "Current pool of neighbors are #{current.neighbors}"
  end

  thread.join
  sleep 30
end
