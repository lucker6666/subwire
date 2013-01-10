namespace :subwire do
    desc "Add the default channel 'Default'"
    task default_channel: :environment do
        ins = Channel.new(
            name: 'Default',
            planningTool: true
        )

        ins.advertising = false
        ins.save!
    end

    desc "Add the default superadmin 'admin@example.com' with password 'admin'"
    task default_user: :environment do
        user = User.new(
            name: 'Admin',
            email: 'admin@example.com',
            password: 'admin'
        )

        user.is_admin = true
        user.confirmed_at = Time.now
        user.invitation_pending = false
        user.save!

        rel = Relationship.new
        rel.channel = Channel.first
        rel.user = user
        rel.admin = true
        rel.save!
    end

    desc "Add a default article"
    task default_article: :environment do
        article = Article.new(
            title: "Welcome to your new subwire installation!",
            content: "Hi, this is your new and fresh subwire installation. Have fun! :)",
        )

        article.user = User.first
        article.channel = Channel.first

        article.save!
    end

    desc "Run all setup tasks"
    task setup: [:default_channel, :default_user, :default_article]

    desc "Run all test tasks"
    task test: []
end
