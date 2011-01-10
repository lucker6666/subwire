Tangerine
=========
Tangerine is a simple PHP blogging platform, similar to Tumblr. It allows you to do one thing; post a tumblelog style stream of posts of varying types from a single author account.

Weighing in at around 300k, Tangerine is fast, small, and flexible, with a simple theme system for easy customization. It's designed for lightweight blogging by a single person.

*(Note: This is a very early release. It hasn't undergone much testing at all)*


Supported Post Types
--------------------
Tangerine supports the following post types:

- Text
- Photo
- Video
- Audio
- Link
- Quote
- Code


Features
--------
Some key features of Tangerine include:

- Dead-simple installation with a single config file.
- Automatic syntax highlighting of code snippets.
- Automaticly scale uploaded images.
- Flash MP3 player for audio posts.
- Clean, easy-to-use WYSIWYG editor for posts.
- Auto-generated RSS feed of recent posts.
- Rudimentary post tagging.


Requirements
------------
Tangerine requires PHP5.3, GDLib, Mcrypt, and a reasonably current version of MySQL. Additionally, PHP short open tags should be turned on.

Other database types (Postgress, SQLite, MSSQL) should work with Tangerine, as its SQL structure is fairly generic, but these haven't been tested.

Tangerine's default public theme and administrative interface don't support IE6, and IE won't display rounded corners unless you want to apply the ie-css3.htc file.


Installation
------------
Just follow the simple steps outlined below to install Tangerine on your server.

1. Either download and unpack, or clone everything to a folder on your web site. Tangerine can reside on a domain, subdomain, or folder within your site. It's not picky.
2. Create a MySQL database for Tangerine.
3. Using PHPMyAdmin, the command line, etc. import the include schema.sql file into your newly created database.
4. In a text editor, open include/Tangerine-config.sample.php and edit the values, following the instructions included. Once done, save it as Tangerine-config.php
5. Make the assets/images/ and assets/audio/ directories writeable by the web suer.


Customizing Tangerine
----------------
Customizing the look and feel of Tangerine is straightforward and simple. Tangerine themes are located inside the themes/ directory and while you may wish to follow the structure outlined in the default theme, you're quite free to move things around. For instance, you could create another directorie for images, or for CSS files, add additionla javascript files, or break the post loop up into multiple include files. There are only two required files for a theme.

- blog.php - This is the main layout file for Tangerine. It may help to think of it as a page shell which all of the blog content resides within. Essentially, it contains the header, footer, and pagination links for Tangerine posts.
- post.php - This is the post loop which controls how posts are displayed on the blog.

Tangerine uses PHP's alternate syntax for code within the templates.


Reserved Variables
------------------
There are a handful of reserved variables that exist within the global scope and shouldn't be overwritten when customizing your themes.

    $actions   - Array of acceptable page actions (used internally)
    $action    - The current page action (used internally)
    $types     - Array of post types (used internally)
    $type      - The current post type (used internally)
    $posts     - Array of posts (used internally and in public templates)
    $post      - The current post (used internally and in public templates)
    $pages     - Total number of pages (used internally)
    $page      - The current page (used internally and in public templates)
    $id        - The id of the current post (used internally and in public templates)
    $tag       - The currently selected tag (used internally and in public templates)
    $body      - Page body markup (used internally)
    $prev_post - The previous post (used internally and in public templates)
    $next_post - The next post (used internally and in public templates)


To-Do
-----
Tangerine will always remain lightweight and simple, but there are still a few things in the works.

1. Clean up the mess that is post_utils.php
2. Better validation for video embed codes
3. Write the .htaccess file for SE-friendly URLs
4. Better tag filtering
5. Search and montly archives (with options to enable/disable them)
6. A browser-based install script to create the database tables and writ ethe config file.
7. Some social sharing functionalith (Tweet, Share on Facebook, Reddit)


License
-------
Tangerine is released under the Creative Commons Attribution, Non-Commercial, Share-Alike license.

If you want to use Tangerine for your company blog, etc. we're cool. By non-commercial use, I simply mean that you are not allowed to sell my software.

For more ino: http://creativecommons.org/licenses/by-nc-sa/3.0/


Support
-------
If you need support with Tangerine, your bset course of action here is to create a new issue on Github: http://github.com/kellishaver/Tangerine/issues - I don't have the time to offer individualized email support at this time. Please post your questions and problems here, so others may benefit from the discussion.

