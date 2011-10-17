Brain Dump
==========
The main idea is to provide an very easy, intuitive and lightwight platform to share brain dumps*, ideas, URLs, screenshots, images,
code and everything else you can imagine and want to share with someone else. Like your twitter stream or your facebook wall but not
limited to 140 letters and public: everyone can post.

I've created that app to optimize the information flow in the yaana.de project. Everyday I sent an E-Mail with Nightly Build Release
Notes. Every Week one Team-Newsletter and everytime we've got to share something our favorite communication tool was E-Mail. But we're
livin in the 21th centuary. E-Mail is out. And E-Mail uncool. Brain Dump is cool ;)

After that I realized that I could use Brain Dump as my personal startpage too. I could note things here and have an list of my
favorite links (webmailer, google reader, github, and so on).

(* brain dumps (came from core dump) are that kind of raw messy text, which comes up if I simply stream my toughts and everything what
crosses my mind in a textfield (or a chat window). Mostly thats a mess of unsorted ideas, thoughts, sensless stuff and so on).

It's based on the great work of Kelli Shavers lightweight tumblelog application "Tangerine" (https://github.com/kellishaver/Tangerine).


Use Cases
---------
- Team Collaboration. Installed on an public server with Basic Authentication or within an intranet this can be used for team
  collaboration. Quick sharing of all kinds of content in your team improves the information flow.
- Could also be used as your personal startpage. Install it locally on your LAMP/WAMP/whatever or on your server (with a Basic
  Authentication). Brain-Dump provides the possibility to configure a linklist, which will be displayed on the top. Your favorites may
  take place here.



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
- Different colors for each user.
- Automatic link detection
- Linklist function.
- Comment function.


Try it!
-------
I've installed a demo version of Brain-Dump just for you. Give it a try ;)
http://bddemo.itws.de/


Requirements
------------
Brain Dump requires PHP5.3, GDLib, Mcrypt, and a reasonably current version of MySQL. Additionally, PHP short open tags should be turned on.


Installation
------------
1. Either download and unpack, or clone everything to a folder on your web site. 
2. Create a MySQL database.
3. Import the include schema.sql file into your newly created database.
4. In a text editor, open include/config.sample.php and edit the values, following the instructions included. Once done, save it as config.php
5. Make the assets/images/ and assets/audio/ directories writeable by the web suer.

Important: Brain Dump is really public! Everyone can create posts without to login. So it's very important to secure it with an HTTP
Basic Authentication. This will avoid spam.


License
-------
Brain Dump is based on Kelli Shavers Tangerine which is released under the Creative Commons Attribution, Non-Commercial, Share-Alike license.
So Brain Dump is released under the same license (Creative Commons Attribution, Non-Commercial, Share-Alike license).

By non-commercial use, we simply mean that you are not allowed to sell this software. But you are allowed to use it in your company of
course.

For more infos: http://creativecommons.org/licenses/by-nc-sa/3.0/


Support
-------
Simply Create a new issue on Github: http://github.com/itws/Brain-Dump/issues

