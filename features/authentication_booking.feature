Feature: Booking authentication
  As an administrator,
  So that only I can view, edit, create and destroy bookings,
  I want unauthorised users to be redirected from the system if they try to interact with bookings.
  
  Scenario: Redirection from the booking index page with no login
    Given I am on the administration booking manager page
    Then I should see "You must be logged in to view that content"
    And I should be on the administration login page
