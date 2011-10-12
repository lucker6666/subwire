<?php
/**
 * Brain Dump - Public Microblogging Platform
 * By Benjamin Kammerl - ghost@itws.de
 * Based on Tangerine by Kelli Shaver - kelli@kellishaver.com
 *
 * Brain Dump is released under the Creative Commons
 * Attribution, Non-Commercial, Share-Alike license.
 *
 * http://creativecommons.org/licenses/by-nc-sa/3.0/
 *
 * Main include file: It all starts and ends here.
 */

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

// Error reporting.
// error_reporting(E_ALL ^ E_NOTICE);
ini_set('display_errors',1);
ini_set('display_startup_errors',1);

define('ROOT_DIR',str_replace('\\\\', '/', realpath(dirname(__FILE__))).'/');

require_once rtrim(ROOT_DIR, '/').'/include/config.php';
require_once rtrim(ROOT_DIR, '/').'/include/post_utils.php';

require_once rtrim(ROOT_DIR, '/').'/include/classes/db.php';
require_once rtrim(ROOT_DIR, '/').'/include/classes/format.php';
require_once rtrim(ROOT_DIR, '/').'/include/classes/post.php';
require_once rtrim(ROOT_DIR, '/').'/include/classes/image.php';
require_once rtrim(ROOT_DIR, '/').'/include/classes/session.php';
require_once rtrim(ROOT_DIR, '/').'/include/classes/validator.php';
require_once rtrim(ROOT_DIR, '/').'/include/helpers.php';

// For establishing database connection.
function db() {
    static $db=false;
    if(!$db) {
        $db = new Db;
        $db->setConnection(DB_NAME, DB_USER, DB_PASS, DB_ADAPTER, DB_HOST);
    }
    return $db;
}

// Start secure user session.
Session::create();

