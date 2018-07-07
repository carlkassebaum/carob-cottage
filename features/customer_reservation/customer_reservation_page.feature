Feature: Customer Reservation Form
    As a customer,
    So that I can place a reservation,
    I want to be able to enter all critical customer details into a form. 
    
    @javascript
    Scenario: Enter the customer details and see confirmation
        Given I am on the reservation page
        And I enter the following values into the corresponding fields:
            | booking_name | booking_postcode | booking_country | booking_contact_number   | booking_email_address   | booking_number_of_people | booking_estimated_arrival_time |
            | Bob          | 5001             | Germany         | +61111222333             | new@domain.com          | 6                        | 5pm                            |
        And I choose "booking_preferred_payment_method_direct_debit"
        And I tick "booking_agreement"
        And I press "Place Reservation"
        Then I should see "Your reservation request has been placed! You will receive a confirmation email shortly."
        And I should be on the reservation notification page


