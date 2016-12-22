require('sinatra/activerecord')
require('sinatra')
require('sinatra/reloader')
require 'pg'
require 'pry'
also_reload('lib/**/*.rb')
require('./lib/location.rb')
require 'httparty'
require 'dotenv'
Dotenv.load

get("/") do
  @locations = Location.all()
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
  # ================= GEOCODING API STUFF =================
  coordinates = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{city},+#{state},+#{zip}&key=#{ENV['GOOGLE_GEOCODE_KEY']}")

  # --------------- invalid input branch ---------------------

  if coordinates.fetch('status') == 'ZERO_RESULTS'
    @locations = Location.all()
    erb(:index)

  # ---------------- valid input branch ---------------------

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
    # ================= DARK SKY API STUFF ====================
    weather_data = HTTParty.get("https://api.darksky.net/forecast/#{ENV['DARK_SKY_KEY']}/#{latitude},#{longitude}")

    # ------------- current weather -------------

    @summary = weather_data.fetch('currently').fetch('summary')
    @temp = weather_data.fetch('currently').fetch('temperature').round().to_i()
    @feels_like = weather_data.fetch('currently').fetch('apparentTemperature').round().to_i()
    @humidity = (weather_data.fetch('currently').fetch('humidity').to_f * 100).round
    @chance_of_precip = (weather_data.fetch('currently').fetch('precipProbability').to_f * 100).round
    daily_data = weather_data.fetch('daily').fetch('data')
    @high_temp = daily_data[0].fetch('temperatureMax').round().to_i()
    @low_temp = daily_data[0].fetch('temperatureMin').round().to_i()
    if weather_data.include?('alerts')
      @alerts = weather_data.fetch('alerts')
    else
      @alerts = []
    end

    # --------------- 3-day forecast -----------------
    daily_data = weather_data.fetch('daily')
    week_summary = daily_data.fetch('summary')
    days_array = daily_data.fetch('data')
    tomorrow = days_array[1]
    @day1_summary = tomorrow.fetch("summary")
    @day1_precip = (tomorrow.fetch("precipProbability") * 100).round
    @day1_min = tomorrow.fetch("temperatureMin").round().to_i()
    @day1_max = tomorrow.fetch("temperatureMax").round().to_i()
    day_after_tomorrow = days_array[2]
    @day2_summary = day_after_tomorrow.fetch("summary")
    @day2_precip = (day_after_tomorrow.fetch("precipProbability") * 100).round
    @day2_min = day_after_tomorrow.fetch("temperatureMin").round().to_i()
    @day2_max = day_after_tomorrow.fetch("temperatureMax").round().to_i()
    third_day = days_array[3]
    @day3_summary = third_day.fetch("summary")
    @day3_precip = (third_day.fetch("precipProbability") * 100).round
    @day3_min = third_day.fetch("temperatureMin").round().to_i()
    @day3_max = third_day.fetch("temperatureMax").round().to_i()

    # ============= populate locations array and get view =============
    @locations = Location.all()
    erb(:weather_view)
  end
end

post('/') do
  city = params[:city_add]
  state = params[:state_add]
  @new_location = Location.create({city: city, state: state})
  @locations = Location.all()
  redirect to "/weather_view/#{@new_location.id()}"
end


get('/weather_view/:id') do
  @location = Location.find(params[:id].to_i())
  @locations = Location.all()
  city = @location.city
  state = @location.state
  now = Time.now()
  @day1 = (now+86400).strftime('%A')
  @day2 = (now+172800).strftime('%A')
  @day3 = (now+259200).strftime('%A')
  # --------------- GEOCODING API STUFF ---------------
  coordinates = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{city},+#{state}&key=#{ENV['GOOGLE_GEOCODE_KEY']}")

  # --------------- invalid input branch ---------------------

  if coordinates.fetch('status') == 'ZERO_RESULTS'
    @locations = Location.all()
    erb(:index)

    # ---------------- valid input branch ---------------------

  else
    geolocation_result = coordinates.fetch('results')
    latitude = geolocation_result[0].fetch('geometry').fetch('location').fetch('lat').to_f
    longitude = geolocation_result[0].fetch('geometry').fetch('location').fetch('lng').to_f
    @city = geolocation_result[0].fetch('address_components')[0].fetch('long_name')
    @state = geolocation_result[0].fetch('address_components')[2].fetch('short_name')
    # --------------- DARK SKY API STUFF --------------
    weather_data = HTTParty.get("https://api.darksky.net/forecast/#{ENV['DARK_SKY_KEY']}/#{latitude},#{longitude}")

    # ------------- current weather -------------

    @summary = weather_data.fetch('currently').fetch('summary')
    @temp = weather_data.fetch('currently').fetch('temperature').round().to_i()
    @feels_like = weather_data.fetch('currently').fetch('apparentTemperature').round().to_i()
    @humidity = (weather_data.fetch('currently').fetch('humidity') * 100).round()
    @chance_of_precip = weather_data.fetch('currently').fetch('precipProbability') * 100
    daily_data = weather_data.fetch('daily').fetch('data')
    @high_temp = daily_data[0].fetch('temperatureMax').round().to_i()
    @low_temp = daily_data[0].fetch('temperatureMin').round().to_i()
    if weather_data.include?('alerts')
      @alerts = weather_data.fetch('alerts')
    else
      @alerts = []
    end

    # --------------- 3-day forecast -----------------

    daily_data = weather_data.fetch('daily')
    week_summary = daily_data.fetch('summary')
    days_array = daily_data.fetch('data')
    tomorrow = days_array[1]
    @day1_summary = tomorrow.fetch("summary")
    @day1_precip = (tomorrow.fetch("precipProbability") * 100).round
    @day1_min = tomorrow.fetch("temperatureMin").round().to_i()
    @day1_max = tomorrow.fetch("temperatureMax").round().to_i()
    day_after_tomorrow = days_array[2]
    @day2_summary = day_after_tomorrow.fetch("summary")
    @day2_precip = (day_after_tomorrow.fetch("precipProbability") * 100).round
    @day2_min = day_after_tomorrow.fetch("temperatureMin").round().to_i()
    @day2_max = day_after_tomorrow.fetch("temperatureMax").round().to_i()
    third_day = days_array[3]
    @day3_summary = third_day.fetch("summary")
    @day3_precip = (third_day.fetch("precipProbability") * 100).round
    @day3_min = third_day.fetch("temperatureMin").round().to_i()
    @day3_max = third_day.fetch("temperatureMax").round().to_i()

    # ============= populate locations array and get view =============
    @locations = Location.all()
    erb(:weather_view)

  end
end

delete('/weather_view/:id') do
  location = Location.find(params[:id].to_i)
  location.destroy
  redirect '/'
end
