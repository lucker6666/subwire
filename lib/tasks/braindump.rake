namespace :braindump do
	desc "Add the default instance 'BrainDump'"
  task :default_instance => :environment do
    Instance.create(
    	:name => 'BrainDump',
    	:advertising => false,
    	:planningTool => true
    )
  end

  desc "Add the default superadmin 'admin' with password 'admin'"
  task :default_user => :environment do
    User.create(
    	:login => 'admin',
    	:name => 'Admin',
    	:email => 'admin@example.com',
    	:is_admin => true,
    	:password => 'admin',
      :color => 'f92672'
    )

    Relationship.create(
    	:instance => Instance.find(1),
    	:user => User.find(1),
    	:admin => true
    )
  end

  desc "Add a default article"
  task :default_article => :environment do
    Article.create(
      :title => "Welcome to your new BrainDump!",
      :content => "Hi, this is your new and fresh BrainDump installation. Have fun! :)",
      :user => User.find(1),
      :instance => Instance.find(1)
    )
  end

  desc "Run all tasks"
  task :all => [:default_instance, :default_user, :default_article]
end