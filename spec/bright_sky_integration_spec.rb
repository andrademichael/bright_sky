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

describe("adding a location to the database", {:type => :feature}) do
  it("allows the user to save a location") do
    visit("/")
    fill_in("city_add", :with => 'Portland')
    fill_in("state_add", :with => 'OR')
    click_on("Add")
    expect(page).to have_content("Portland, OR")
  end
end

describe("view weather for saved location", {:type => :feature}) do
  it("allows the user to view the weather for saved location") do
    visit("/")
    fill_in("city_add", :with => 'Portland')
    fill_in("state_add", :with => 'OR')
    click_on("Add")
    click_on("Portland, OR")
    expect(page).to have_content("Weather in Portland, OR")
  end
end
