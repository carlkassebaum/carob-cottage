Feature: Login in an adminstrator
  As an administrator,
  so that I can manage bookings and prices securely,
  I want the ability to log in to the system.
  
  Background:
    Given the following administrators exist:
      | name | email_address   | password | password_confirmation |
      | bob  | bob@outlook.com | foo_bar  | foo_bar               |
  
  Scenario: Standard Login procedure
    Given I am on the administrator login page
    When I fill in "email_address" with "bob@outlook.com"
    And I fill in "password" with "foo_bar"
    And I press "Sign in"
    Then I should be redirected to the administrator home page
    
  Scenario: Invalid email address
    Given I am on the administrator login page
    When I fill in "email_address" with "invalid@outlook.com"
    And I fill in "password" with "foo_bar"
    And I press "Sign in"
    Then I should see "Unkown email address or invalid password given"
    
  Scenario: Invalid password
    Given I am on the administrator login page
    When I fill in "email_address" with "bob@outlook.com"
    And I fill in "password" with "invalid"
    And I press "Sign in"
    Then I should see "Unkown email address or invalid password given"
    
  Scenario: Invalid email address and password
    Given I am on the administrator login page
    When I fill in "email_address" with "invalid@outlook.com"
    And I fill in "password" with "invalid"
    And I press "Sign in"
    Then I should see "Unkown email address or invalid password given"       