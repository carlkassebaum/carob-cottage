Feature: Customer Reservation Form
    As a customer,
    So that I can place a reservation,
    I want to be able to enter all critical customer details into a form. 
    
    @javascript
    Scenario: Enter the customer details and see confirmation
        Given it is currently June 29, 2017  
        And I am on the reservation page
        And I enter the following values into the corresponding fields:
            | booking_name | booking_postcode | booking_country | booking_contact_number   | booking_email_address   | booking_estimated_arrival_time |
            | Bob          | 5001             | Germany         | +61111222333             | new@domain.com          | 5pm                            |
        And I follow "Check In"
        And I follow "29"
        And I follow "next_month"
        And I follow "1"
        And I select "2 people" from "booking_number_of_people"
        And I choose "booking_preferred_payment_method_direct_debit"
        And I tick "booking_agreement"
        And I press "Place Reservation"
        Then I should see "Your reservation request has been placed! You will receive a confirmation email shortly."
        
        
    @javascript
    Scenario: Omit critical customer details
        Given I am on the reservation page
        And I enter the following values into the corresponding fields:
            | booking_name | booking_country | booking_estimated_arrival_time | 
            | Bob          | Germany         | 5pm                            |
        And I tick "booking_agreement"
        And I press "Place Reservation"
        Then I should see the following:
            | error_message                                |
            | You must provide an email address            |
            | You must provide a contact number            |
            | You must select an arrival date              |
            | You must select a departure date             |
        And I should be on the reservation page
