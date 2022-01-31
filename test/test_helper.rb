require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end


require 'require_all'
require_rel '../src'
require 'minitest/autorun'


require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
