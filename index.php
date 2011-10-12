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
 * ssentially functions as a controller for posts.
 */

include 'braindump.inc.php';

// Variables - We'll need these later.
$body = '';
$pagination = '';
$posts = array();
$pages = ceil(total_posts()/POSTS_PER_PAGE);

$prev_post = null;
$next_post = null;

// Find out which page we're on.
if(isset($_GET['page'])) $page = (integer) $_GET['page'];
else $page=1;

// Are we browsing by tag?
if(isset($_GET['tag'])) $tag = $_GET['tag'];

// Are we viewing an individual post?
if(isset($_GET['id'])) $id = (integer) $_GET['id'];

if(isset($id)) { // Viewing a single post.
    $post = (array) new Post($id);
    $prev_post = previous_post($post['posted_on']);
    $next_post = next_post($post['posted_on']);
    if($post['id'] > 0) $posts[] = $post;
} else if(isset($tag)) { // Viewing posts by tag.
    $posts = list_posts_by_tag($tag);
} else $posts = list_posts($page, POSTS_PER_PAGE); // Viewing all posts.

ob_start();

include rtrim(ROOT_DIR, '/').'/themes/'.THEME.'/post.php';

$body = ob_get_contents();
ob_end_clean();

include rtrim(ROOT_DIR, '/').'/themes/'.THEME.'/blog.php';

