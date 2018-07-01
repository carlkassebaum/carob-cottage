Feature: Booking summary calendar
  As an administrator,
  So that I can quickly identify if a time period is free,
  I want to be able to view a summary of all bookings in a year on a calendar.
  
  Background:
    Given the following bookings exist:
      | name   | postcode | country   | contact_number   | email_address   | number_of_people | estimated_arrival_time | preferred_payment_method | arrival_date | departure_date | cost | status   |
      | test_1 | 5000     | Australia | +61234567890     | test@domain.com | 4                | 3pm                    | cash                     | 20-1-2018    | 25-1-2018      | 123  | booked   |
      | test_2 |          | Indonesia | +62 21 6539-0605 | test@foreign.id | 5                | 2pm                    | direct_debit             | 25-1-2018    | 2-2-2018       | 1000 | reserved |
      | test_3 |          | Austria   | 0043-1-893 42 02 | test@foreign.at | 1                | 9pm                    | cash                     | 15-5-2017    | 25-5-2017      | 800  | booked   | 
      | test_4 | 2158     | Australia | +61098765432     | test@dom.com.au | 2                | 4pm                    | cash                     | 29-5-2018    | 3-6-2018       | 132  | reserved |
      | test_5 | 3142     | Australia | +61567890123     | test@for.com    | 3                | 1am                    | direct_debit             | 1-8-2019     | 2-10-2019      | 5000 | reserved |
      | test_6 | 2119     | Australia | 0478901234       | wealth@rich.com | 4                | 3pm                    | cash                     | 5-3-2018     | 10-3-2018      | 430  | booked   |
    Given the following administrators exist:
      | name | email_address   | password | password_confirmation |
      | bob  | bob@outlook.com | foo_bar  | foo_bar               |
  
  Scenario: View yearly summary
    Given I log in as an administrator with "bob@outlook.com" and "foo_bar"
    And it is currently June 29, 2018    
    When I am on the administration page
    And I press "Booking Manager"
    Then I should see "Bookings for the 2018 calendar year"
    And I should see a full year calendar containing the following bookings:
      | name   | postcode | country   | contact_number   | email_address   | number_of_people | estimated_arrival_time | preferred_payment_method | arrival_date | departure_date | cost | status   |
      | test_1 | 5000     | Australia | +61234567890     | test@domain.com | 4                | 3pm                    | cash                     | 20-1-2018    | 25-1-2018      | 123  | booked   |
      | test_2 |          | Indonesia | +62 21 6539-0605 | test@foreign.id | 5                | 2pm                    | direct_debit             | 25-1-2018    | 2-2-2018       | 1000 | reserved |
      | test_4 | 2158     | Australia | +61098765432     | test@dom.com.au | 2                | 4pm                    | cash                     | 29-5-2018    | 3-6-2018       | 132  | reserved |
      | test_6 | 2119     | Australia | 0478901234       | wealth@rich.com | 4                | 3pm                    | cash                     | 5-3-2018     | 10-3-2018      | 430  | booked   |