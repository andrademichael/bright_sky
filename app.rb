require('sinatra/activerecord')
require('sinatra')
require('sinatra/reloader')
require 'pg'
also_reload('lib/**/*.rb')
# require 'lib/location'

get("/") do
  erb(:index)
end

get("/weather_view") do
  erb(:weather_view)
end
