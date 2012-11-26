Feature: Article summary of changes
  In order to make summary of changes
  As a user
  I edit an article

  Scenario: I fill summary of changes
    Given I am logged as "User1"
    When I add new article
    And I am on the article list
    And I go to the article "New article"
    Then I fill in "change_summary" with "short summary"
    When I press "Update Article"
    Then I should see "short summary"

  Scenario: I don't fill summary
    Given I am logged as "User1"
    When I add new article
    And I am on the article list
    And I go to the article "New article"
    When I press "Update Article"
    Then I should see "Change summary cannot be empty"