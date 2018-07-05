Feature: Delete a price rule
  As an administrator,
  So that I can remove old tariffs,
  I want to delete price rules.
  
  Background:
    Given the following administrators exist:
      | name | email_address   | password | password_confirmation |
      | bob  | bob@outlook.com | foo_bar  | foo_bar               |
    And I log in as an administrator with "bob@outlook.com" and "foo_bar"
    And the following price rules exist:
      | id | name                        | value | period_type | min_people | max_people | start_date | end_date | min_stay_duration | max_stay_duration | description                                               |
      | 20 | Base Rate                   | 185   | per_night   | 1          | 2          |            |          | 2                 | 6                 | A base rate of $185 per night applies for 1 to 2 people.  |
      | 21 | Addition People             | 30    | per_night   | 3          |            |            |          |                   |                   | Additonal people are charged at $30 per night.            |
      | 22 | Easter                      | 205   | per_night   | 1          | 2          | 19-4       | 22-4     |                   |                   | Stays at the easter period are charged at $205 per night. | 
      | 23 | Cleaning                    | 10    | fixed       |            |            |            |          |                   |                   | A fixed $10 charge applies for cleaning.                  |
      | 24 | 7 night stay                | 170   | per_night   | 1          | 2          |            |          | 7                 | 7                 | Stays for 7 nights are charged at $170 per night.         | 
      | 25 | stays longer than 7 nights  | 165   | per_night   | 1          | 2          |            |          | 8                 |                   | Stays for 8 or more nights are charged at $165 per night. |

  Scenario: Delete an existing price rule
    Given I am on the administration price manager page
    And I press "delete_price_rule_23"
    Then I should see "Price rule \"Cleaning\" succesfully deleted"