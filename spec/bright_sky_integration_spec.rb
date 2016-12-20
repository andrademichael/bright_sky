require("spec_helper")
require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe("viewing current weather", {:type => :feature}) do
  it("allows the user to enter a zip code and see what the weather there is right now") do
    visit("/")
    fill_in("zip_input", :with => 97223)
    click_on("Check weather")
    expect(page).to have_content("Weather in Portland")
  end
end
