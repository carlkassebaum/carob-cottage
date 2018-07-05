Feature: Price Rule View
  As an administrator,
  So that I can identify quickly if a price rule requires correction or change
  I want to be able to view all price rules in the system as a list.
  
  Background: 
    Given the following administrators exist:
      | name | email_address   | password | password_confirmation |
      | bob  | bob@outlook.com | foo_bar  | foo_bar               |
    And I log in as an administrator with "bob@outlook.com" and "foo_bar"  
  
  Scenario: No price rules
    Given I am on the administration page
    And I press "Price Manager"
    Then I should see "There are currently no price rules!"
  
  Scenario: View a list of price rules
    Given the following price rules exist:
      | name                        | value | period_type | min_people | max_people | start_date | end_date | min_stay_duration | max_stay_duration | description                                               |
      | Base Rate                   | 185   | per_night   | 1          | 2          |            |          | 2                 | 6                 | A base rate of $185 per night applies for 1 to 2 people.  |
      | Addition People             | 30    | per_night   | 3          |            |            |          |                   |                   | Additonal people are charged at $30 per night.            |
      | Easter                      | 205   | per_night   | 1          | 2          | 19-4       | 22-4     |                   |                   | Stays at the easter period are charged at $205 per night. | 
      | Cleaning                    | 10    | fixed       |            |            |            |          |                   |                   | A fixed $10 charge applies for cleaning.                  |
      | 7 night stay                | 170   | per_night   | 1          | 2          |            |          | 7                 | 7                 | Stays for 7 nights are charged at $170 per night.         | 
      | stays longer than 7 nights  | 165   | per_night   | 1          | 2          |            |          | 8                 |                   | Stays for 8 or more nights are charged at $165 per night. |  
    Given I am on the administration page
    And I press "Price Manager"
    Then I should see "Current Price Rules"
    And I should see the following:
      | Rule Name | Description                                                                |
      | Base Rate | A base rate of $185 per night applies for 1 to 2 people.                   |
      | Addition People | Additonal people are charged at $30 per night.                       |
      | Easter | Stays at the easter period are charged at $205 per night.                     | 
      | Cleaning | A fixed $10 charge applies for cleaning.                                    |
      | 7 night stay | Stays for 7 nights are charged at $170 per night.                       | 
      | stays longer than 7 nights | Stays for 8 or more nights are charged at $165 per night. |