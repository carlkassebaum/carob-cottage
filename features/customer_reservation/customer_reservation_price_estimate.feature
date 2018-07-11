Feature: Price Estimation
    As a customer,
    So that I can determine how much my stay will cost,
    I want to view an automated price estimate on the reservation page.
    
    Background: 
        Given the following price rules exist:
        | id | name                        | value | period_type | rate_type  | min_people | max_people | start_date | end_date | min_stay_duration | max_stay_duration | description                                               |
        | 20 | Base Rate                   | 185   | per_night   | all_geusts | 1          | 2          |            |          | 2                 | 6                 | A base rate of $185 per night applies for 1 to 2 people.  |
        | 21 | Addition People             | 30    | per_night   | per_person | 3          |            |            |          |                   |                   | Additonal people are charged at $30 per night.            |    
    
    @javascript
    Scenario: Price estimation appears after check in and check out dates have been selected
        Given it is currently June 1, 2017  
        And I am on the reservation page
        And I follow "Check In"
        And I follow "14"
        And I follow "20"
        And I select "4 people" from "booking_number_of_people"
        Then I should see "1470"
