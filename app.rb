require('sinatra/activerecord')
require('sinatra')
require('sinatra/reloader')
require 'pg'
also_reload('lib/**/*.rb')
require('./lib/location.rb')
require 'httparty'
require 'dotenv'
Dotenv.load

get("/") do
  erb(:index)
end

get("/weather_view") do
  zip = params[:zip_input]
  city = params[:city_input]
  state = params[:state_input]
  coordinates = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{city},+#{state},+#{zip}&key=#{ENV['GOOGLE_GEO_KEY']}")
  geolocation_result = coordinates.fetch('results')
  latitude = geolocation_result[0].fetch('geometry').fetch('location').fetch('lat').to_f
  longitude = geolocation_result[0].fetch('geometry').fetch('location').fetch('lng').to_f
  if city == '' && state == ''
    @city = geolocation_result[0].fetch('address_components')[1].fetch('long_name')
    @state = geolocation_result[0].fetch('address_components')[3].fetch('short_name')
  else
    @city = geolocation_result[0].fetch('address_components')[0].fetch('long_name')
    @state = geolocation_result[0].fetch('address_components')[2].fetch('short_name')
  end
  erb(:weather_view)
end
