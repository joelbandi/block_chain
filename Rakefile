require "rake/testtask"

task :load_env do 
  require_relative './src/chain'
end

desc 'Opens up a console to play around with block chain'
task console: [:load_env] do
  require 'pry'
  Pry.start
end

desc 'Start the Peer Discovery Service'
task :discovery do
  puts "Starting the Peer Discovery Service..."
  system 'ruby ./src/usenet/discovery_service.rb'
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
end
