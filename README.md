Subwire is the system running on [subwire.net](http://subwire.net).

[![Build Status](https://secure.travis-ci.org/YaanaLabs/subwire.png?branch=V3-0)](http://travis-ci.org/#!/YaanaLabs/subwire)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/YaanaLabs/subwire)



## What is subwire?
Subwire.net supports you to organize a group of people, share things fast and easy, write documents together, discuss hot topics and plan meetings. If you've got an association or a company, subwire.net provides you a perfect communication and collaboration platform. And if you got some friends (we hope so) you may use subwire to connect with them.

For more informations check [subwire.net](http://subwire.net)!



## Features
* Multi-User system with invitations
* Login with Twitter, Google or Github
* Manage multiple channels
* Discussions
* Wikis
* Bookmarks
* Notifications (with optinal E-Mail notifications)
* Much more!



## Usage
Just visit subwire.net. That's our hosted version of subwire and the easiest way to use subwire. Alternative you may want to host subwire yourself in your intranet or extranet. Just take a look at the installation instructions.


## Productive Installation
	$ git clone https://github.com/YaanaLabs/subwire.git && cd subwire
	$ bundle --without development test
	$ cp config/database.mysql.yml config/database.yml
Change config/database.yml and setup mysql/postgresql

	$ cp config/initializers/config.example.rb config/initializers/config.rb
Change config/initializers/config.rb

	$ rake db:setup subwire:setup

Finished! Now you can login with 'admin@example.com' and the password 'admin' to do the rest of the configuration.



## GoogleAnalytics
To activate GA you have to set the config.subwire.ga config params at the end of config/initializers/config.rb



## Contributing
Feel free to fork this repo, make changes and setup a pull request. Or mail us. Or open a ticket. Or do whatever you want to do if you feel it will help us to make subwire even better ;)

We're currently working on version 3.1 (Northstar) in the master branch. You find open tickets in our [redmine installation](http://redmine.yaana.de/projects/subwire/issues?query_id=14).

And if you want to work with us and get part of the [Yaana Labs](http://yaana.de), just write us!


### How to contribute code
1. Fork subwire via the github fork button
2. Clone your fork to your local machine
3. Run <code>bundle</code>
4. Setup a <code>config/database.yml</code>
5. Setup a <code>config/initializers/config.rb</code>
6. Run <code>rake db:create db:setup subwire:setup</code>
7. Run <code>bundle exec rspec spec/</code> and see how everything passes (green)
8. (Optional) Run <code>bundle exec guard</code> for livereload and rspec
9. (Optional) Run <code>bundle exec rails server</code> to start webserver
10. Make changes
11. Run <code>bundle exec rspec spec/</code> and repeat 10. and 11. until everything passes
12. Commit
13. Repeat 10. - 12. until you're done
14. <code>git push</code>
15. Open a pull request
16. Wait for merge



## Licence
Subwire is licenced under the AGPL. See the [LICENCE](https://raw.github.com/YaanaLabs/subwire/master/LICENSE) file for further information.


## Contributors
* Benjamin Kammerl ([phortx](https://github.com/phortx))
* Markus Genz ([ich-net-du](https://github.com/ich-net-du))
* Benjamin August ([TheBenji](https://github.com/TheBenji))
* Sebastian Brozda ([sebastianbrozda](https://github.com/sebastianbrozda))
