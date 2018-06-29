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


Given("the following administrators exist:") do |administrators|
  administrators.hashes.each do | current_admin |
    FactoryBot.create(:administrator, current_admin)
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

