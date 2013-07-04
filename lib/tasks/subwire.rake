namespace :subwire do
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
    end

    desc "Run all setup tasks"
    task setup: [:default_user]

    desc "Run all test tasks"
    task test: []
end
