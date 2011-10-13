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
 * Bain Dump Default Theme
 * Main layout file for the default theme.
 */

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title><?=SITE_NAME?> <? if(isset($post)):?> - <?=$post['title']?><?endif?></title>
    <base href="<?=rtrim(SITE_URL, '/')?>/">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/themes/base/jquery-ui.css" type="text/css" />
    <link rel="stylesheet" href="<?=rtrim(SITE_URL, '/')?>/themes/<?=THEME?>/braindump.css" type="text/css" />
    <link rel="stylesheet" href="<?=rtrim(SITE_URL, '/')?>/assets/highlight_styles/ir_black.css" type="text/css" />
    <script type="text/javascript" src="<?=rtrim(SITE_URL, '/')?>/assets/html5.js"></script>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js"></script>
    <script type="text/javascript" src="<?=rtrim(SITE_URL, '/')?>/assets/highlight.js"></script>
    <script type="text/javascript" src="<?=rtrim(SITE_URL, '/')?>/assets/braindump.js"></script>
    <link rel="alternate" type="application/rss+xml" title="<?=SITE_NAME?> RSS" href="<?=rtrim(SITE_URL, '/')?>/feed.php">
</head>
<body>
    <div id="container">
        <header>
            <h1><a href="<?=SITE_URL?>" title="<?=SITE_NAME?>"><?=SITE_NAME?></a></h1>
        </header>
        <?=$body?>
        <ul id="pagination">
        <? if(!isset($post)): ?>
            <? if($pages > $page): ?>
            <li class="previous"><?=link_to(array('page', floor($page+1)), '&laquo; Older')?></li>
            <? else: ?>
            <li class="previous_off">&laquo; Older</li>
            <? endif ?>
            <? if($page == 1): ?>
            <li class="next_off">Newer &raquo;</li>
            <? else: ?>
            <li class="next"><?=link_to(array('page', floor($page-1)), 'Newer &raquo;')?></li>
            <? endif ?>
        <? else: ?>
            <? if($prev_post !== null): ?>
                <li class="previous"><?=link_to(array('id', $prev_post), '&laquo; Previous Post')?></li>
            <? else: ?>
                <li class="previous_off">&laquo; Previous Post</li>
            <? endif ?>
            <? if($next_post !== null): ?>
                <li class="next"><?=link_to(array('id', $next_post), 'Next Post &raquo;')?></li>
            <? else: ?>
                <li class="next_off">Next Post &raquo;</li>
            <? endif ?>
        <? endif ?>
        </ul>
        <footer>
            <a target="_blank" href="http://github.com/Itws/Brain-Dump">Powered by Brain Dump</a> | <a href="feed.php">RSS</a>
        </footer>
    </div>
</body>
</html>

