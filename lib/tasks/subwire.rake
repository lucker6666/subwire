namespace :subwire do
    desc "Add the default channel 'Default'"
    task default_channel: :environment do
        channel = Channel.new(
            name: 'Default',
            planningTool: true
        )

        channel.advertising = false
        channel.save!
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

    desc "Add a default message"
    task default_message: :environment do
        message = Message.new(
            title: "Welcome to your new subwire installation!",
            content: "Hi, this is your new and fresh subwire installation. Have fun! :)",
        )

        message.user = User.first
        message.channel = Channel.first

        message.save!
    end

    desc "Add a wiki home page"
    task default_page: :environment do
        page = Page.new
        page.user = User.first
        page.channel = Channel.first
        page.is_home = true
        page.title = "Home"
        page.content = "This is the startpage of your wiki. Feel free to change that page!"
        page.save!
    end

    desc "Run all setup tasks"
    task setup: [:default_channel, :default_user, :default_message, :default_page]

    desc "Run all test tasks"
    task test: []
end
