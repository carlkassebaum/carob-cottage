Feature: Customer Reservation Calendar
  As a customer,
  So that I can easily choose my stay dates,
  I want to select my arrival and departure dates on a calendar.
  
  @javascript
  Scenario: Select dates on the calendar
    Given I am on the reservation page
    And it is currently June 29, 2018
    And I press "Check In"
    And I follow "29"
    And I press "next_month"
    And I follow "1"
    Then I should see "29-06-2018"
    And I should see "1-7-2018"
