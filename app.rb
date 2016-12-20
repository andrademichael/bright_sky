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
  now = Time.now()
  @day1 = (now+86400).strftime('%A')
  @day2 = (now+172800).strftime('%A')
  @day3 = (now+259200).strftime('%A')
  # --------------- GEOCODING API STUFF ---------------
  coordinates = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{city},+#{state},+#{zip}&key=#{ENV['GOOGLE_GEO_KEY']}")
  if coordinates.fetch('status') == 'ZERO_RESULTS'
    erb(:index)
  else
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
    # --------------- DARK SKY API STUFF --------------
    weather_data = HTTParty.get("https://api.darksky.net/forecast/de6e497d48c4d73de9049c55b3c7fc90/#{latitude},#{longitude}")
    @summary = weather_data.fetch('currently').fetch('summary')
    @temp = weather_data.fetch('currently').fetch('temperature').round().to_i()
    @feels_like = weather_data.fetch('currently').fetch('apparentTemperature').round().to_i()
    @humidity = weather_data.fetch('currently').fetch('humidity').to_f * 100
    @chance_of_precip = weather_data.fetch('currently').fetch('precipProbability').to_i * 100
    daily_data = weather_data.fetch('daily').fetch('data')
    @high_temp = daily_data[0].fetch('temperatureMax').round().to_i()
    @low_temp = daily_data[0].fetch('temperatureMin').round().to_i()
    erb(:weather_view)
  end
end
