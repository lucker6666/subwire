namespace :braindump do
	desc "Add the default instance 'BrainDump'"
	task :default_instance => :environment do
		Instance.create(
			:name => 'BrainDump',
			:advertising => false,
			:planningTool => true
		)
	end

	desc "Add the default superadmin 'admin@example.com' with password 'admin'"
	task :default_user => :environment do
		User.create(
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

	desc "Run all setup tasks"
	task :setup => [:default_instance, :default_user, :default_article]

	desc "Run all test tasks"
	task :test => []
end
