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
 * Admin Post Management
 * Sanitizes post data and uploads images and audio.
 */

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

// This is messy, but our list of fields is short and it
// adds an extra measure of security, so what the hell?
function cleanup_comment($type) {
    $vars=array();
    $vars['post_id']  = (isset($_GET['id']))?$_GET['id']:null;
    $vars['user']     = (isset($_POST['user']))?strtolower($_POST['user']):null;
    $vars['contents'] = (isset($_POST['contents']))?strip_tags($_POST['contents'],
	'<span><div><br><ol><li><ul><img><a><i><b><strong><em><u><hr>'):null;

    $vars['contents'] = make_clickable($vars['contents']);
    
    return $vars;
}

