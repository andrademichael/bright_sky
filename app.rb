require('sinatra/activerecord')
require('sinatra')
require('sinatra/reloader')
require 'pg'
also_reload('lib/**/*.rb')
require('./lib/location.rb')

get("/") do
  erb(:index)
end