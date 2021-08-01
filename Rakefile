task :environment do 
  require_relative './chain'
end

task console: [:environment] do
  require 'pry'
  Pry.start
end
