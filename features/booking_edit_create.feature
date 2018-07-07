Feature: Edit and Create bookings
  As an administrator,
  So that I can correct and add external bookings,
  I want to be able to edit existing and create new bookings.
  
  Background:
    Given the following bookings exist:
      | id  | name   | postcode | country   | contact_number   | email_address   | number_of_people | estimated_arrival_time | preferred_payment_method | arrival_date | departure_date | cost | status   |
      | 12  | test_1 | 5000     | Australia | +61234567890     | test@domain.com | 4                | 3pm                    | cash                     | 20-1-2018    | 25-1-2018      | 123  | booked   |
      | 14  | test_2 |          | Indonesia | +62 21 6539-0605 | test@foreign.id | 5                | 2pm                    | direct_debit             | 25-1-2018    | 2-2-2018       | 1000 | reserved |
      | 23  | test_3 |          | Austria   | 0043-1-893 42 02 | test@foreign.at | 1                | 9pm                    | cash                     | 15-5-2017    | 25-5-2017      | 800  | booked   | 
      | 34  | test_4 | 2158     | Australia | +61098765432     | test@dom.com.au | 2                | 4pm                    | cash                     | 29-5-2018    | 3-6-2018       | 132  | reserved |
      | 45  | test_5 | 3142     | Australia | +61567890123     | test@for.com    | 3                | 1am                    | direct_debit             | 1-8-2019     | 2-10-2019      | 5000 | reserved |
      | 56  | test_6 | 2119     | Australia | 0478901234       | wealth@rich.com | 4                | 3pm                    | cash                     | 5-3-2018     | 10-3-2018      | 430  | booked   |
    And the following administrators exist:
      | name | email_address   | password | password_confirmation |
      | bob  | bob@outlook.com | foo_bar  | foo_bar               |
    And it is currently June 29, 2018
    And I log in as an administrator with "bob@outlook.com" and "foo_bar"  
  
  @javascript
  Scenario: Click on and edit booking
    Given I am on the administration booking manager page
    And I click on the "Booking" for the dates "20-1-2018" to "25-1-2018"
    And I press "Edit"
    And I enter the following values into the corresponding fields:
      | booking_name | booking_postcode | booking_country | booking_contact_number   | booking_email_address   | booking_number_of_people | booking_estimated_arrival_time | booking_preferred_payment_method | booking_arrival_date | booking_departure_date |
      | test_7       | 5001             | Germany         | +61111222333             | new@domain.com          | 34                       | 5pm                            | direct_debit                     | 2018-01-21           | 2018-01-25             |
    And I press "Save"
    Then I should see "Booking 12 sucessfully updated"
    And I click on the "Booking" for the dates "21-1-2018" to "25-1-2018"
    Then I should see "Booking ID: 12"
    And I should see the following: 
      | name   | postcode | country | contact_number   | email_address   | number_of_people | estimated_arrival_time | preferred_payment_method | arrival_date | departure_date | cost |
      | test_7 | 5001     | Germany | +61111222333     | new@domain.com  | 34               | 5pm                    | direct_debit             | 2018-01-21   | 2018-01-25     | 123  | 
  
  @javascript
  Scenario: Change a booking reservation status
    Given I am on the administration booking manager page
    And I click on the "Booking" for the dates "20-1-2018" to "25-1-2018"
    And I press "Edit"
    And I choose "booking_status_reserved"
    And I press "Save"
    And I should see a full year calendar containing the following bookings:
      | name   | postcode | country   | contact_number   | email_address   | number_of_people | estimated_arrival_time | preferred_payment_method | arrival_date | departure_date | cost | status   |    
      | test_2 |          | Indonesia | +62 21 6539-0605 | test@foreign.id | 5                | 2pm                    | direct_debit             | 25-1-2018    | 2-2-2018       | 1000 | reserved |
  
  @javascript
  Scenario: Create a new booking
    Given I am on the administration booking manager page
    And I press "Add"
    And I enter the following values into the corresponding fields:
      | booking_name | booking_postcode | booking_country | booking_contact_number   | booking_email_address   | booking_number_of_people | booking_estimated_arrival_time | booking_preferred_payment_method | booking_arrival_date | booking_departure_date | cost_field  |
      | test_7       | 5001             | Germany         | +61111222333             | new@domain.com          | 34                       | 5pm                            | direct_debit                     | 2018-03-05           | 2018-03-09             | 170         |
  And I choose "booking_status_reserved" 
  And I press "Save"
  Then I should see "New Booking succesfully created" 
  And I click on the "Booking" for the dates "05-03-2018" to "09-03-2018"
  Then I should see the following: 
    | name   | postcode | country | contact_number   | email_address   | number_of_people | estimated_arrival_time | preferred_payment_method | arrival_date | departure_date | cost |
    | test_7 | 5001     | Germany | +61111222333     | new@domain.com  | 34               | 5pm                    | direct_debit             | 2018-03-05   | 2018-03-09     | 170  | 

  @javascript
  Scenario: Invalid arrival dates entered on modification
    Given I am on the administration booking manager page
    And I click on the "Booking" for the dates "20-1-2018" to "25-1-2018"
    And I press "Edit"
    And I enter the following values into the corresponding fields:
      | booking_arrival_date |
      | junk_date            |
    And I press "Save"
    Then I should see "No changes made. Invalid arrival date given."

  @javascript
  Scenario: Invalid departure date entered on modification
    Given I am on the administration booking manager page
    And I click on the "Booking" for the dates "20-1-2018" to "25-1-2018"
    And I press "Edit"
    And I enter the following values into the corresponding fields:
      | booking_departure_date |
      | junk_date              |
    And I press "Save"
    Then I should see "No changes made. Invalid departure date given."
    
  @javascript
  Scenario: Overlapping booking dates on edit
    Given I am on the administration booking manager page
    And I click on the "Booking" for the dates "20-1-2018" to "25-1-2018"
    And I press "Edit"
    And I enter the following values into the corresponding fields:
      | booking_departure_date |
      | 26-1-2018              |
    And I press "Save"
    Then I should see "No changes made. Overlapping arrival/departure dates given."
    
  @javascript
  Scenario: Overlapping booking dates on creation
    Given I am on the administration booking manager page  
    And I press "Add"
    And I enter the following values into the corresponding fields:
      | booking_name | booking_arrival_date | booking_departure_date |
      | test_7       | 2018-02-01           | 2018-02-04             |
    And I press "Save"
    Then I should see "Booking not created. Overlapping arrival/departure dates given."
    
  @javascript
  Scenario: Valid same arrival dates for existing booking departure
    Given I am on the administration booking manager page
    And I click on the "Booking" for the dates "20-1-2018" to "25-1-2018" 
    And I press "Edit" 
    And I enter the following values into the corresponding fields:
      | booking_arrival_date | booking_departure_date |
      | 2018-01-19           | 2018-01-25             |    
    And I press "Save"
    And I click on the "Booking" for the dates "19-1-2018" to "25-1-2018"
    Then I should see "2018-01-19"
    And I should see "2018-01-25"
  
  @javascript
  Scenario: Valid same departure dates for existing booking arrival
    Given I am on the administration booking manager page  
    And I press "Add"
    And I enter the following values into the corresponding fields:
      | booking_name | booking_arrival_date | booking_departure_date |
      | test_7       | 2018-05-27           | 2018-05-29             |
    And I press "Save"
    Then I should see "New Booking succesfully created"    
    
  @javascript
  Scenario: Invalid arrival date entered on new booking
    Given I am on the administration booking manager page
    And I press "Add"
    And I enter the following values into the corresponding fields:
      | booking_arrival_date |
      | junk_date            |
    And I press "Save"
    Then I should see "Booking not created. Invalid arrival date given."
    
    