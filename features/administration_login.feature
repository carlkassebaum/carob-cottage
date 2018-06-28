Feature: Login in an adminstrator
  As an administrator,
  so that I can manage bookings and prices securely,
  I want the ability to log in to the system.
  
  Background:
    Given the following administrators exist:
      | name | email_address   | password | password_confirmation |
      | bob  | bob@outllok.com | foo_bar  | foo_bar               |
  
  Scenario:
    Given I am on the "adminstrator login" page
    When I fill in "email_address" with "bob@outlook.com"
    And I fill in "password" with "foo_bar"
    And I follow "Sign In"
    Then I should be redirected to the administrator home page