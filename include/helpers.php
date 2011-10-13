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

function is_admin() {
    if(isset($_SESSION['is_admin'])) return (Session::getValue('is_admin')==md5(SESSION_SECRET + date("d")));
    else return false;
}

function redirect($path='index.php') {
    header("Location: ".$path);
    exit; // this can't be healthy...
}

function token($len=16) { // random token.
    return substr(str_shuffle('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'),0,$len);
}

