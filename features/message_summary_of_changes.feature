Feature: Message summary of changes
  In order to make summary of changes
  As a user
  I edit an message

  Scenario: I fill summary of changes
    Given I am logged as "User1"
    When I add new message
    And I am on the message list
    And I go to the message "New message"
    Then I fill in "change_summary" with "short summary"
    When I press "Update Message"
    Then I should see "short summary"

  Scenario: I don't fill summary
    Given I am logged as "User1"
    When I add new message
    And I am on the message list
    And I go to the message "New message"
    When I press "Update Message"
    Then I should see "Change summary cannot be empty"