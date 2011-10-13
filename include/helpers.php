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
 * Brain Dump Helpers
 * A set of useful helper functions, mostly for use in views.
 */

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

function list_posts($page=1, $limit=10) {
    $start = $limit * $page - $limit;
    $sql = "SELECT * FROM posts ORDER BY posted_on DESC LIMIT $start, $limit";
    return (db()->getResult($sql))?:array();
}

function list_posts_by_tag($tag) {
    $sql = "SELECT * FROM posts WHERE tags LIKE ? ORDER BY posted_on DESC";
    return (db()->getResult($sql, '%'.$tag.'%'))?:array();
}

function total_posts() {
    $sql = "SELECT COUNT(*) FROM posts";
    return db()->getValue($sql);
}

function previous_post($when) {
    $sql = "SELECT id FROM posts WHERE posted_on < ? ORDER BY posted_on DESC LIMIT 1";
    return (db()->getValue($sql, $when))?:null;
}

function next_post($when) {
    $sql = "SELECT id FROM posts WHERE posted_on > ? ORDER BY posted_on ASC LIMIT 1";
    return (db()->getValue($sql, $when))?:null;
}

function link_to($link_data, $link_title) {
    if(SEO_URLS===true) return '<a href="'.rtrim(SITE_URL, '/').'/'.$link_data[0].'/'.$link_data[1].'/'.rawurlencode($link_title).'">'.$link_title.'</a>';
    else return '<a href="'.rtrim(SITE_URL, '/').'/?'.$link_data[0].'='.$link_data[1].'" title="'.$link_title.'">'.$link_title.'</a>';
}

function redirect($path='index.php') {
    header("Location: ".$path);
    exit; // this can't be healthy...
}

function token($len=16) { // random token.
    return substr(str_shuffle('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'),0,$len);
}

function user_color($name) {
	$colors = array(
		'a75dee',
		'10a100',
		'ff4d00',
		'25cfdb',
		'b0b500',
		'5d84ee'
	);

	$len = strlen($name);

	while (true) {
		$name = sha1($name);

		for ($i = $len; $i < 40; ++$i) {
			$index = substr($name, $i, 1);

			if (preg_match('/^[0-5]$/', $index)) {
				return $colors[$index];
			}
		}
	}
}

function _make_url_clickable_cb($matches) {
	$ret = '';
	$url = $matches[2];

	if (empty($url)) {
		return $matches[0];
	}

	// removed trailing [.,;:] from URL
	if (in_array(substr($url, -1), array('.', ',', ';', ':')) === true) {
		$ret = substr($url, -1);
		$url = substr($url, 0, strlen($url)-1);
	}

	return $matches[1] . "<a href=\"$url\" rel=\"nofollow\" target=\"_blank\">$url</a>" . $ret;
}

function _make_email_clickable_cb($matches) {
	$email = $matches[2] . '@' . $matches[3];
	return $matches[1] . "<a href=\"mailto:$email\">$email</a>";
}

function make_clickable($ret) {
	$ret = ' ' . $ret;
	// in testing, using arrays here was found to be faster
	$ret = preg_replace_callback('#([\s>])([\w]+?://[\w\\x80-\\xff\#$%&~/.\-;:=,?@\[\]+]*)#is', '_make_url_clickable_cb', $ret);
	$ret = preg_replace_callback('#([\s>])((www|ftp)\.[\w\\x80-\\xff\#$%&~/.\-;:=,?@\[\]+]*)#is', '_make_web_ftp_clickable_cb', $ret);
	$ret = preg_replace_callback('#([\s>])([.0-9a-z_+-]+)@(([0-9a-z-]+\.)+[0-9a-z]{2,})#i', '_make_email_clickable_cb', $ret);

	// this one is not in an array because we need it to run last, for cleanup of accidental links within links
	$ret = preg_replace("#(<a( [^>]+?>|>))<a [^>]+?>([^>]+?)</a></a>#i", "$1$3</a>", $ret);
	$ret = trim($ret);
	return $ret;
}
