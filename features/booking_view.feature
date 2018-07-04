Feature: Booking View
  As an administrator,
  So that I can view and check the details of a booking,
  I want to be able to view all details of a booking.
  
  Background:
    Given the following bookings exist:
      | id | name   | postcode | country   | contact_number   | email_address   | number_of_people | estimated_arrival_time | preferred_payment_method | arrival_date | departure_date | cost | status   |
      | 1  | test_1 | 5000     | Australia | +61234567890     | test@domain.com | 4                | 3pm                    | cash                     | 20-1-2018    | 25-1-2018      | 123  | booked   |
      | 2  | test_2 |          | Indonesia | +62 21 6539-0605 | test@foreign.id | 5                | 2pm                    | direct_debit             | 25-1-2018    | 2-2-2018       | 1000 | reserved |
      | 3  | test_3 |          | Austria   | 0043-1-893 42 02 | test@foreign.at | 1                | 9pm                    | cash                     | 15-5-2017    | 25-5-2017      | 800  | booked   | 
      | 4  | test_4 | 2158     | Australia | +61098765432     | test@dom.com.au | 32               | 4pm                    | cash                     | 29-5-2018    | 3-6-2018       | 132  | reserved |
      | 5  | test_5 | 3142     | Australia | +61567890123     | test@for.com    | 3                | 1am                    | direct_debit             | 1-8-2019     | 2-10-2019      | 5000 | reserved |
      | 6  | test_6 | 2119     | Australia | 0478901234       | wealth@rich.com | 4                | 3pm                    | cash                     | 5-3-2018     | 10-3-2018      | 430  | booked   |
    And the following administrators exist:
      | name | email_address   | password | password_confirmation |
      | bob  | bob@outlook.com | foo_bar  | foo_bar               |
    And it is currently June 29, 2018
    And I log in as an administrator with "bob@outlook.com" and "foo_bar"
  
  # @javascript
  # Scenario: Click on and view booking
  #   Given I am on the administration booking manager page
  #   And I click on the "Booking" for the dates "20-1-2018" to "25-1-2018"
  #   Then I should see the following: 
  #     | Name   | Postcode | Country   | Contact Number   | Email Address   | Number Of Guests | Estimated Arrival Time | Preferred Payment Method | Arrival Date  | Departure Date  | Cost  | Status   |
  #     | test_1 | 5000     | Australia | +61234567890     | test@domain.com | 4                | 3pm                    | cash                     | 2018-01-20    | 2018-01-25      | $123  | Booked   |


  @javascript
  Scenario: Close an open booking
    Given I am on the administration booking manager page
    And I click on the "Booking" for the dates "29-5-2018" to "3-6-2018"
    And I press on the close booking button
    Then I should not see the following:
      | Name   | Postcode | Country   | Contact Number   | Email Address   | Number Of Guests | Estimated Arrival Time | Preferred Payment Method | Arrival Date  | Departure Date | Cost | Status   |      
      | test_4 | 2158     | Australia | +61098765432     | test@dom.com.au | 32               | 4pm                    | cash                     | 29-5-2018     | 3-6-2018       | 132  | reserved |


    