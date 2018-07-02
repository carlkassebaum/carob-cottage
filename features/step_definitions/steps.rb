require 'cucumber/rails'
require 'uri'
require 'cgi'
require 'factory_bot_rails'

module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    when /^the administrator login page$/
      '/administration/login'
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n"
      end
    end
  end
end
World(NavigationHelpers)

module SearchHelpers
  def get_elements_by_xpath(xpath)
    page.all(:xpath, xpath)
  end
end
World(SearchHelpers)

module ReservationHelpers
  
  #return logical key words for arrivals, departures and stays for testing
  def reservation_keywords(index, date_range_len)
    return "arrive" if index == 0
    return "depart" if index == date_range_len - 1
    return "stay"
  end
  
  def search_for_booking_date(date_range, booking_status)
    Capybara.default_selector = :xpath
    len = date_range.length
    date_range.each_with_index do | date, index |
      current_date = Date.parse(date)
      #Get corresponding month calendar
      result = get_elements_by_xpath("//td[@id='#{Date::MONTHNAMES[current_date.mon]}']/div/table/tr/td") 
      result.each do | element |
        if element.text.to_i == current_date.day
          #Should appear as reserved or booked
          expect(element.all(:xpath,".//div[contains(@class, 'full_cal_#{booking_status}_#{reservation_keywords(index, len)}')").length).to eq(1)
          puts "passed"
        end
      end
    end
  end
end
World(ReservationHelpers)

Given("the following administrators exist:") do |administrators|
  administrators.hashes.each do | current_admin |
    FactoryBot.create(:administrator, current_admin)
  end      
end

Given("the following bookings exist:") do |bookings|
  bookings.hashes.each do | booking |
    FactoryBot.create(:booking, booking)
  end      
end

Given(/^(?:|I )am on (.+)$/) do |page_name|
  visit path_to(page_name)
end

Given("I log in as an administrator with {string} and {string}") do |email_address, password|
  visit path_to("the administrator login page")
  fill_in("email_address", with: email_address)
  fill_in("password", with: password)
  click_button("Sign in")
end

When(/^(?:|I )fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
    fill_in(field, with: value)
end

When(/^(?:|I )follow "([^"]*)"$/) do |link|
  click_link(link)
end

When(/^(?:|I )press "([^"]*)"$/) do |button|
  click_button(button)
end

Then(/^I should be redirected to the administrator home page$/) do
  current_path.should == administration_path
end

Then(/^(?:|I )should see "([^"]*)"$/) do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then(/^(?:|I )should be on (.+)$/) do |page_name|
  expect(current_path).to eq path_to(page_name)
end

Given("I attempt to logout as an administrator") do
  delete '/administration/logout'
end

Then("I should see a full year calendar containing the following bookings:") do |bookings|
  bookings.hashes.each do | booking |
    start_date = Date.parse(booking[:arrival_date])
    end_date   = Date.parse(booking[:departure_date])
    search_for_booking_date((start_date..end_date).map(&:to_s), booking[:status])
  end
end
