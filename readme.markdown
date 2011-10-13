Brain Dump
==========
Brain Dump is a simple blogging platform with one special aspect: everyone can post things. It's meant for team collaboration. Post
brain dumps, ideas, URLs, screenshots and other images, code and everythin else you can imagine.

Weighing in at around 300k, Brain Dump is fast, small, and flexible, with a simple theme system for easy customization.

It's based on the great work of Kelli Shavers Tangarine (https://github.com/kellishaver/Tangerine).


Supported Post Types
--------------------
- Text
- Photo
- Video
- Audio
- Link
- Quote
- Code


Features
--------
- Simple installation with a single config file.
- Automatic syntax highlighting of code snippets.
- Automaticly scale uploaded images.
- Flash MP3 player for audio posts.
- Clean, easy-to-use WYSIWYG editor for posts.
- Auto-generated RSS feed of recent posts.
- Rudimentary post tagging.


Requirements
------------
Brain Dump requires PHP5.3, GDLib, Mcrypt, and a reasonably current version of MySQL. Additionally, PHP short open tags should be turned on.



Installation
------------
1. Either download and unpack, or clone everything to a folder on your web site. 
2. Create a MySQL database.
3. Using PHPMyAdmin, the command line, etc. import the include schema.sql file into your newly created database.
4. In a text editor, open include/config.sample.php and edit the values, following the instructions included. Once done, save it as config.php
5. Make the assets/images/ and assets/audio/ directories writeable by the web suer.

Important: Brain Dump is really public! Everyone can create posts without to login. So it's very important to secure it with an HTTP
Basic Authentication. This will avoid spam.



To-Do
-----
Brain Dump will always remain lightweight and simple, but there are still a few things in the works.

1. Clean up the mess that is post_utils.php
2. Better validation for video embed codes
3. Write the .htaccess file for SE-friendly URLs
4. Better tag filtering
5. Search and montly archives (with options to enable/disable them)
6. A browser-based install script to create the database tables and writ ethe config file.
7. Captcha for unsecured use


License
-------
Brain Dump is based on Kelli Shavers Tangerine which is released under the Creative Commons Attribution, Non-Commercial, Share-Alike license.
So Brain Dump is released under the same license (Creative Commons Attribution, Non-Commercial, Share-Alike license).

By non-commercial use, we simply mean that you are not allowed to sell this software. But you are allowed to use it in your company of
course.

For more ino: http://creativecommons.org/licenses/by-nc-sa/3.0/


Support
-------
Simply Create a new issue on Github: http://github.com/itws/Brain-Dump/issues

