Subwire is the system running on [subwire.net](http://subwire.net).

[![Build Status](https://secure.travis-ci.org/YaanaLabs/subwire.png?branch=V3-0)](http://travis-ci.org/#!/YaanaLabs/subwire)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/YaanaLabs/subwire)



## What is subwire?
Subwire.net supports you to organize a group of people, share things fast and easy, and to stay in touch. If you've got an association or a company, subwire.net provides you a perfect communication and collaboration platform.

For more information check [subwire.net](http://subwire.net)!



## Quick Installation
	$ git clone https://github.com/YaanaLabs/subwire.git && cd subwire

	$ bundle install

	$ cp config/database.mysql.yml config/database.yml
Change config/database.yml

	$ cp config/initializers/config.example.rb config/initializers/config.rb
Change config/initializers/config.rb

	$ rake db:create && rake db:migrate
	$ rake subwire:setup

Finished! Now you can login with 'admin@example.com' and the password 'admin'.



## GoogleAnalytics
To activate GA you have to set the config.subwire.ga config params at the end of config/initializers/config.rb



## Contributing
Feel free to fork this repo, make changes and setup a pull request. Or mail us. Or open a ticket. Or do whatever you want to do if you feel it will help us to make subwire even better.

And if you want to work with us and get part of the ([Yaana Labs](http://yaana.de)), write us!



## Licence
Subwire is licenced under the AGPL. See the LICENCE file for further information.


## Contributors
* Benjamin Kammerl ([@itws](https://github.com/itws))
* Markus Genz ([@ich-net-du](https://github.com/ich-net-du))
* Benjamin August ([@TheBenji](https://github.com/TheBenji))
* Sebastian Brozda ([@sebastianbrozda](https://github.com/sebastianbrozda))