Subwire is the system running on [subwire.net](http://subwire.net).

[![Build Status](https://secure.travis-ci.org/YaanaLabs/subwire.png?branch=master)](http://travis-ci.org/#!/YaanaLabs/subwire)



What is subwire?
================
Subwire.net supports you to organize a group of people, share things fast and easy, and to stay in touch. If you've got an association or a company, subwire.net provides you a perfect communication and collaboration platform.

For more information check [subwire.net](http://subwire.net)!



Installation
============
* $ git clone --quiet https://itws@github.com/YaanaLabs/subwire.git
* $ cd subwire
* $ bundle install
* For MySQL: $ cp config/database.mysql.yml config/database.yml
* For SQLite: $ cp config/database.sqlite.yml config/database.yml
* $ vim config/database.yml
* change database connection configuration
* $ cp config/initializers/secret_token.rb.example config/initializers/secret_token.rb
* $ vim config/initializers/secret_token.rb
* Specify a secret token!
* $ cp config/initializers/setup_mail.rb.exmaple config/initializers/setup_mail.rb
* $ vim config/initializers/setup_mail.rb
* Change E-Mail settings
* $ rake db:create; rake db:migrate
* $ rake subwire:setup

Finished! Now you can login with 'admin@example.com' and the password 'admin'.



GoogleAnalytics
===============
To activate GA you have to set the config.subwire.ga config params at the end of config/application.rb



Contributing
============
Feel free to fork this repo, make changes and setup a pull request. Or mail us. Or open a ticket. Or do whatever you want to if you feel it will help us to make subwire even better.

Oh and if you want to work with us and get part of the Yaana Labs (non-profit), write us!



Licence
=======
Subwire is licenced under the AGPL. See the LICENCE file for further information.