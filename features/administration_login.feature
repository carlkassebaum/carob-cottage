Feature: Login in an adminstrator
  As an administrator,
  so that I can manage bookings and prices securely,
  I want the ability to log in to the system.
  
  Background:
    Given administrators with the following attributes exists:
      | id | name | email_address   | password | password_confirmation |
      | 1  | bob  | bob@outllok.com | foo_bar  | foo_bar               |
  
  Scenario:
    Given an administrator with the following attributes exists: 
    Given I am on the "adminstrator login" page
    When I enter "bob@outlook.com" into the "email_address" field
    And I enter "password" into the "password" field
    And I press "Sign In"
    Then I should be on the "adminstrator home" page