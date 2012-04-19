namespace :bootstrap do
  desc "Add the default user 'admin' (as admin) with password 'admin'"
  task :default_user => :environment do
    User.create(
    	:login => 'admin',
    	:name => 'Admin',
    	:email => 'admin@example.com',
    	:is_admin => true,
    	:password => 'admin',
      :color => 'f92672'
    )
  end

  desc "Add a default article"
  task :default_article => :environment do
    Article.create(
      :title => "Welcome to your new BrainDump!",
      :content => "Hi, this is your new and fresh BrainDump installation. Have fun! :)",
      :user => User.find(1)
    )
  end

  desc "Run all bootstrapping tasks"
  task :all => [:default_user, :default_article]
end