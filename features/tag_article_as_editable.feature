Feature: tag article as editable

  In order to make editable article for everyone
  As a user
  I set tag editable

  Scenario: edit an tagged article as editable
    Given I am logged as "User1"
    Then I add new article
    And I logout
    Given I am logged as "User2"
    And I update article title
    And I should see "Article was successfully updated."

  Scenario: hide editable checkbox
    Given I am logged as "User1"
    When I add new article
    And I follow to the article page
    Then I should not see "Is editable"

  Scenario: user from other channel can't edit article
    Given I am logged as "User1" with access to channel "C1"
    Then I add new article
    And I logout
    Given I am logged as "User2" with access to channel "C2"
    When I am on the article list
    Then I follow to the article page
    And I go to the article list


