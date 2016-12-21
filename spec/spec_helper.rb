ENV['RACK_ENV'] = 'test'

require('rspec')
require('pg')
require('sinatra/activerecord')
require('location')
require 'pry'

RSpec.configure do |config|
  config.after(:each) do
    Location.all.each{ |location| location.destroy }
  end
end
