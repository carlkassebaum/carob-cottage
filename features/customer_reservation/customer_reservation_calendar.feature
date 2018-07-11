Feature: Customer Reservation Calendar
  As a customer,
  So that I can easily choose my stay dates,
  I want to select my arrival and departure dates on a calendar.
  
  @javascript
  Scenario: Select dates on the calendar
    Given it is currently June 29, 2017    
    And I am on the reservation page
    And I follow "Check In"
    And I follow "29"
    And I follow "next_month"
    And I follow "1"
    Then I should see "29-06-2017"
    And I should see "01-07-2017"
