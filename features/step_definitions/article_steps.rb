And /I follow to the article page/ do
  visit '/articles/1/edit'
end

Then /I add new article/ do
  steps %{
  And I am on the adding article form
  When I fill in "article_title" with "New article"
  And I fill in "article_content" with "New article content"
  And I check "article_is_editable"
  And I press "Create Article"
  }
end


Then /I update article title/ do
  steps %{
  And I am on the article list
  When I follow to the article page
  Then I fill in "article_title" with "New title"
  And I press "Update Article"
  }
end