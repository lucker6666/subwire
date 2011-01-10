<?php
/********************************************************
    vim: expandtab sw=4 ts=4 sts=4:
    -----------------------------------------------------
    Tangerine - Microblogging Platform
    By Kelli Shaver - kelli@kellishaver.com
    -----------------------------------------------------
    Tangerine is released under the Creative Commons
    Attribution, Non-Commercial, Share-Alike license.

    http://creativecommons.org/licenses/by-nc-sa/3.0/
    -----------------------------------------------------
    Tangerine Config
    -----------------------------------------------------
    Basic configuration settings for Tangerine.
********************************************************/

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

define('DB_NAME', 'tangerine');
define('DB_USER', 'tangerine');
define('DB_PASS', 'password');
define('DB_HOST', 'localhost');
define('DB_ADAPTER', 'mysql');

// Used to encrypt the session.
define('SESSION_SECRET', "There is one friend in the life of each of us who seems not a separate person, however dear and beloved, but an expansion, an interpretation of one's self, the very meaning of one's soul.");

// What's the name of the site?
define('SITE_NAME', "Tangerine");

// A witty tag-line, perhaps?
define('TAG_LINE', 'Tangerine is pretty cool tumblelog software.');

// What's the URL?
define('SITE_URL', 'http://example.com');

// What's the admin password?
// Keep it simple - one admin for now.
define('ADMIN_PASSWORD', 'test123');

// What's the email address of the site admin?
define('ADMIN_EMAIL', 'you@yourdomain.com');


// Where do we store uploaded media?
// This needs to be the absolute path to the assets folder.
// If you use something other than the assets folder, you
// will need to modify the template accordingly for audio,
// and photo posts.
define('UPLOADS_DIR', '/home/you/www/tangerine/assets/');

// Which theme do we use?
define('THEME', 'default');

// How many posts per page?
define('POSTS_PER_PAGE', 5);

// SE-Friendly URLs?
// For now, you'll need to write your own rewrite rules.
define('SEO_URLS', false);

// Default timezone for posts relative to GMT.
define('TZ', '-5');

// Use daylight savings time?
define('USE_DST', true);

// What are the maximum dimensions for uploaded images?
define('MAX_IMG_WIDTH', 700);
define('MAX_IMG_HEIGHT', 500);

