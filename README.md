Work in progress. Stay tuned!

[![Build Status](https://secure.travis-ci.org/YaanaLabs/BrainDump.png?branch=master)](http://travis-ci.org/#!/YaanaLabs/BrainDump)


Installation
============
* $ git clone https://itws@github.com/YaanaLabs/BrainDump.git
* $ cd BrainDump
* $ bundle
* $ cp config/database.example.yml config/database.yml
* $ vim config/database.yml
* change database connection configuration
* $ rake db:setup; rake db:migrate
* $ rake braindump:all

Finished! Now you can login with 'admin@example.com' and the password 'admin'.
