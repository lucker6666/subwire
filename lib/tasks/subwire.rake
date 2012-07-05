namespace :subwire do
	desc "Add the default instance 'Default'"
	task :default_instance => :environment do
		ins = Instance.new(
			:name => 'Default',
			:planningTool => true
		)

		ins.advertising = false
		ins.save
	end

	desc "Add the default superadmin 'admin@example.com' with password 'admin'"
	task :default_user => :environment do
		user = User.new(
			:name => 'Admin',
			:email => 'admin@example.com',
			:password => 'admin'
		)

		user.is_admin = true
		user.confirmed_at = Time.now
		user.invitation_pending = false
		user.save

		rel = Relationship.new
		rel.instance = Instance.first
		rel.user = user
		rel.admin = true
		rel.save
	end

	desc "Add a default article"
	task :default_article => :environment do
		article = Article.new(
			:title => "Welcome to your new subwire installation!",
			:content => "Hi, this is your new and fresh subwire installation. Have fun! :)",
		)

		article.user = User.first
		article.instance = Instance.first

		article.save
	end

	desc "Run all setup tasks"
	task :setup => [:default_instance, :default_user, :default_article]

	desc "Run all test tasks"
	task :test => []
end
