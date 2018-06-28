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
    When I enter "bob@outlook.com" into the "email_address" field
    And I enter "password" into the "password" field
    And I press "Sign In"
    Then I should be on the "adminstrator home" page