Work in progress. Stay tuned!

[![Build Status](https://secure.travis-ci.org/YaanaLabs/BrainDump.png?branch=master)](http://travis-ci.org/#!/YaanaLabs/BrainDump)


Installation
============
* $ git clone --quiet https://itws@github.com/YaanaLabs/BrainDump.git
* $ cd BrainDump
* $ bundle install
* For MySQL: $ cp config/database.mysql.yml config/database.yml
* For SQLite: $ cp config/database.sqlite.yml config/database.yml
* $ vim config/database.yml
* change database connection configuration
* $ cp config/initializers/secret_token.rb.example config/initializers/secret_token.rb
* $ vim config/initializers/secret_token.rb
* Specify a secret token!
* $ rake db:create; rake db:migrate
* $ rake braindump:setup

Finished! Now you can login with 'admin@example.com' and the password 'admin'.
