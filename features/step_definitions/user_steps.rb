Given /I am logged as "(.*)"/ do |name|
  email = "#{name}@mail.net"
  password = 'secretpass'

  user = User.new(:email => email,
                  :password => password,
                  :password_confirmation => password,
                  :name => name)
  user.confirmed_at = Date.today
  user.save

  if Relationship.all.empty?
    channel = Channel.new :name => "NewChannel",
                          :defaultLanguage => "en"
    channel.advertising=1
    channel.planningTool=1
    channel.save
  else
    channel = Relationship.first
  end

  rel = Relationship.new
  rel.user_id = user.id
  rel.channel_id = channel.id
  rel.admin = 0
  rel.mail_notification = 0
  rel.save

  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "sign_in"

  click_link "NewChannel"
end

Then /I logout/ do
  visit '/users/sign_out'
end