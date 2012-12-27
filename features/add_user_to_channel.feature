Feature: Add user to channel
  As a logged user
  I want to add user to chanel

  Scenario: Add user to channel
    Given I am logged as "user1" with access to channel "channel1"
    When I go to the new relationship page
    And I should be on the new relationship page
    Then I fill in "relationship_email" with "test@testamil.com"
    And I check "relationship_admin"
    And I fill in "invitation_text" with "hello123"
    And I press "Add user to channel"
