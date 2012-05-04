User.create(
	:login => 'admin',
	:name => 'Admin',
	:email => 'admin@example.com',
	:is_admin => true,
	:password => 'admin',
  :color => 'f92672'
)

Article.create(
	:title => "Welcome to your new BrainDump!",
	:content => "Hi, this is your new and fresh BrainDump installation. Have fun! :)",
	:user => User.find(1)
)