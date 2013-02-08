Then /I add new message/ do
  steps %{
  And I am on the adding message form
  When I fill in "message_title" with "New message"
  And I fill in "message_content" with "New message content"
  And I check "message_is_editable"
  And I press "Create message"
  }
end


Then /I update message title/ do
  steps %{
  And I am on the message list
  When I go to the message "New message"
  And I fill in "change_summary" with "short summary"
  Then I fill in "message_title" with "New title"
  And I press "Update Message"
  }
end