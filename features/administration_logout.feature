Feature: Log out as an administrator
  As an administrator,
  so that I can keep the system secure,
  I want to be able to log out of the system.
    
  Background:
    Given the following administrators exist:
      | name | email_address   | password | password_confirmation |
      | bob  | bob@outlook.com | foo_bar  | foo_bar               |
  
  Scenario: Standard log out procedure
    Given I log in as an administrator with "bob@outlook.com" and "foo_bar"
    And I am on the administration booking manager page
    When I press "Sign out"
    Then I should see "Sign out successful"
    And I should be on the administration login page
    
  Scenario: Invalid logout attempt
    #Attempting to logout without being logged in
    Given I am on the administration login page
    And I attempt to logout as an administrator
    Then I should be on the administration login page 
    