Feature: tag article as editable

  In order to make editable article for everyone
  As a user
  I set tag editable

  Scenario: edit an tagged article as editable
    Given I am logged as "User1"
    And I am on the adding article form
    When I fill in "article_title" with "New article"
    And I fill in "article_content" with "New article content"
    And I check "article_is_editable"
    And I press "Create Article"
    Then I logout
    Given I am logged as "User2"
    And I am on the article list
    When I follow to the article page
    Then I fill in "article_title" with "New title"
    And I press "Update Article"
    And I should see "Article was successfully updated."