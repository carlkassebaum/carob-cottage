Feature: Only logged in users can view the price rule page
    As an administrator,
    So that only I can modify price rules,
    I want unauthorised users to be redirected if they try to interact with price rules.  
    
    Scenario: Redirection on logged out view of the index page
      Given I am on the administration price manager page
      Then I should see "You must be logged in to view that content"
      And I should be on the administration login page
      
    Scenario: Redirection on logged out view of the show page
        Given the following price rules exist:
        | id | name                        | value | period_type | min_people | max_people | start_date | end_date | min_stay_duration | max_stay_duration | description                                               |
        | 30 | Base Rate                   | 185   | per_night   | 1          | 2          |            |          | 2                 | 6                 | A base rate of $185 per night applies for 1 to 2 people.  |      
        And I am on the price rule(30) page
        Then I should see "You must be logged in to view that content"
        And I should be on the administration login page
        
    Scenario: Redirection on logged out view of the edit page
        Given the following price rules exist:
        | id | name                        | value | period_type | min_people | max_people | start_date | end_date | min_stay_duration | max_stay_duration | description                                               |
        | 30 | Base Rate                   | 185   | per_night   | 1          | 2          |            |          | 2                 | 6                 | A base rate of $185 per night applies for 1 to 2 people.  |      
        And I am on the price rule(30) edit page
        Then I should see "You must be logged in to view that content"
        And I should be on the administration login page
    
    Scenario: Redirection on logged out view of the new page
        Given I am on the new price rule page
        Then I should see "You must be logged in to view that content"
        And I should be on the administration login page
