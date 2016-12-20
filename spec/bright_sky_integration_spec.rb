require("spec_helper")
require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe("viewing current weather by zipcode", {:type => :feature}) do
  it("allows the user to enter a zip code and see what the weather there is right now") do
    visit("/")
    fill_in("zip_input", :with => 97223)
    click_on("Check weather")
    expect(page).to have_content("Weather in Portland, OR")
  end
end

describe("viewing current weather by city/state", {:type => :feature}) do
  it("allows the user to enter a city and state and see what the weather there is right now") do
    visit("/")
    fill_in("city_input", :with => 'Portland')
    fill_in("state_input", :with => 'OR')
    click_on("Check weather")
    expect(page).to have_content("Weather in Portland, OR")
  end
end
