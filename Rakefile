task :environment do 
  require_relative './src/chain'
end

task console: [:environment] do
  require 'pry'
  Pry.start
end
