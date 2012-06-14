namespace :braindump do
	desc "Add the default instance 'BrainDump'"
	task :default_instance => :environment do
		ins = Instance.new(
			:name => 'BrainDump',
			:planningTool => true
		)

		ins.advertising = false
	end

	desc "Add the default superadmin 'admin@example.com' with password 'admin'"
	task :default_user => :environment do
		user = User.new(
			:name => 'Admin',
			:email => 'admin@example.com',
			:password => 'admin',
			:color => 'f92672'
		)

		user.is_admin = true

		rel = Relationship.new
		rel.instance = Instance.find(1)
		rel.user = User.find(1)
		rel.admin = true
	end

	desc "Add a default article"
	task :default_article => :environment do
		article = Article.new(
			:title => "Welcome to your new BrainDump!",
			:content => "Hi, this is your new and fresh BrainDump installation. Have fun! :)",
		)

		article.user = User.find(1)
		article.instance = Instance.find(1)
	end

	desc "Run all setup tasks"
	task :setup => [:default_instance, :default_user, :default_article]

	desc "Run all test tasks"
	task :test => []
end
