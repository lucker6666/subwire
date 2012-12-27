Given /^I am logged as "([^"]*)"( with access to channel "([^"]*)")?$/ do |name, not_used, channel_name|
  channel_name = 'DefaultChannel' if channel_name.blank?
  email = "#{name}@mail.net"


  password = 'secretpass'

  user = User.new(:email => email,
                  :password => password,
                  :password_confirmation => password,
                  :name => name)
  user.confirmed_at = Date.today
  user.is_admin = true
  user.save.should be_true


  channel = Channel.find_by_name channel_name
  unless channel
    channel = Channel.new :name => channel_name,
                          :defaultLanguage => "en"
    channel.advertising=1
    channel.planningTool=1
    channel.save.should be_true
  end

  rel = Relationship.new
  rel.user_id = user.id
  rel.channel_id = channel.id
  rel.admin = 0
  rel.mail_notification = 0
  rel.save.should be_true

  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "sign_in"

  click_link channel_name
end

Then /I logout/ do
  visit '/users/sign_out'
end