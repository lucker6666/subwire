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
 * Admin Index
 * The admin dashboard, shows an overview of posts.
 */

include 'templates/dashboard.php';

$body = ob_get_contents();
ob_end_clean();

include 'templates/main.php';

