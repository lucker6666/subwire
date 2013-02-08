Feature: tag message as editable

  In order to make editable message for everyone
  As a user
  I set tag editable

  Scenario: edit an tagged message as editable
    Given I am logged as "User1"
    Then I add new message
    And I logout
    Given I am logged as "User2"
    And I update message title
    And I should see "message was successfully updated."

  Scenario: hide editable checkbox
    Given I am logged as "User1"
    When I add new message
    And I go to the message "New message"
    Then I should not see "Is editable"

  Scenario: user from other channel can't edit message
    Given I am logged as "User1" with access to channel "C1"
    Then I add new message
    And I logout
    Given I am logged as "User2" with access to channel "C2"
    When I am on the message list
    Then I go to the message "New message"
    And I go to the message list


