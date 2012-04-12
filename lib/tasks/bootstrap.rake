namespace :bootstrap do
  desc "Add the default user 'admin' (as admin) with password 'admin'"
  task :default_user => :environment do
    User.create(
    	:login => 'admin',
    	:name => 'Admin',
    	:email => 'admin@example.com',
    	:is_admin => true,
    	:password => 'admin'
    )
  end

  desc "Run all bootstrapping tasks"
  task :all => [:default_user]
end