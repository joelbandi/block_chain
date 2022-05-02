require 'concurrent/hash'
require 'sinatra'
require 'json'

PEER_POOL = Concurrent::Hash.new

set :port, 9999
set :lock, true
set :default_content_type, :json

get '/peers' do
  PEER_POOL.to_json
end

post '/peer' do
  port = params[:port]
  name = params[:name]

  next respond('Bad request. Port missing.') unless port
  next respond('Port already in use.') if PEER_POOL[port]

  PEER_POOL[port] = {
    name: name,
  }

  next respond('OK')
end

def respond(msg, options = {})
  msg
end
