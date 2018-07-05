require 'cucumber/rails'
require 'uri'
require 'cgi'
require 'factory_bot_rails'
require 'database_cleaner'



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
  
  def search_for_booking_date(date_range)
    Capybara.default_selector = :xpath
    len = date_range.length
    date_range.each_with_index do | date, index |
      current_date = Date.parse(date)
      #Get corresponding month calendar
      result = get_elements_by_xpath("//td[@id='#{Date::MONTHNAMES[current_date.mon]}']/div/table/tbody[@class='full_reservation_calendar_body']/tr/td") 
      
      #becomes true when the day is found 
      found = false
      
      result.each do | element |
        if element.text.to_i == current_date.day
          yield element, index
          #Should appear as reserved or booked
          found = true
          break
        end
      end
      
      raise "Day not found" unless found
      
    end
  end
end
World(ReservationHelpers)

module WaitForAjax
  
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
  
  def reload_page   
    page.evaluate_script("window.location.reload()")
  end
  
end
World(WaitForAjax)

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

Given("the following price rules exist:") do |price_rules|
  price_rules.hashes.each do | price_rule |
    FactoryBot.create(:price_rule, price_rule)
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

Given("I press on the close booking button") do
  find(:xpath, "//div[@id='individual_booking_place_holder']/img").click  
end

When("I click on the {string} for the dates {string} to {string}") do | type, arrival_date, departure_date|
  raise "Invalid type" unless (type == "Booking" || type == "Reservation")  
  type = "booked" if type == "Booking"
  type = "reserved" if type == "Reservation"
  
  date_range = (arrival_date..departure_date).map(&:to_s)
  len = date_range.length
  
  search_for_booking_date(date_range) do | element, index |
    navigation_elements = element.all(:xpath,".//div[contains(@class, 'booking_link_wrapper')]")      
    expect(navigation_elements.length).to eq(1)  
    navigation_elements[0].click_link
    break
  end
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
    date_range = (start_date..end_date).map(&:to_s)
    len        = date_range.length
    
    search_for_booking_date(date_range) do | element, index |
      highlight_elements = element.all(:xpath,".//div[contains(@class, 'full_cal_#{reservation_keywords(index, len)}_#{booking[:status]}')]")      
      expect(highlight_elements.length).to eq(1)      
    end
  end
end

Then("I should see the following:") do |table|
  table.hashes.each do | expected_content |
    expected_content.values.each do | content |
      if page.respond_to? :should
        page.should have_content(content)
      else
        assert page.has_content?(content)
      end
    end
  end
end

Then("I should not see the following:") do |table|
  table.hashes.each do | expected_content |
    expected_content.values.each do | content |
      if page.respond_to? :should
        page.should have_no_content(content)
      else
        assert !page.has_content?(content)
      end
    end
  end
end

Given("I enter the following values into the corresponding fields:") do |field_values|
  field_values.hashes.each do | entry |
    entry.each do | field, value |
      fill_in(field, with: value)      
    end
  end
end

When(/^(?:|I )choose "([^"]*)"$/) do |field|
  choose(field)
end
