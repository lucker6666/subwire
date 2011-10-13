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
 * Admin Template
 * The main admin template.
 */

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title><?=SITE_NAME?> <? if(isset($post)):?> - <?=$post['title']?><?endif?></title>
    <base href="<?=rtrim(SITE_URL, '/')?>/themes/<?=THEME?>/">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/themes/base/jquery-ui.css" type="text/css">
    <link rel="stylesheet" href="css/main.css" type="text/css" />
    <link rel="stylesheet" href="<?=rtrim(SITE_URL, '/')?>/assets/highlight_styles/ir_black.css" type="text/css">
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/themes/dot-luv/jquery-ui.css" type="text/css">
    <script type="text/javascript" src="<?=rtrim(SITE_URL, '/')?>/assets/html5.js"></script>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js"></script>
    <script type="text/javascript" src="<?=rtrim(SITE_URL, '/')?>/assets/highlight.js"></script>
    <script type="text/javascript" src="js/nicEdit.js"></script>
    <script type="text/javascript" src="js/main.js"></script>
    <link rel="alternate" type="application/rss+xml" title="<?=SITE_NAME?> RSS" href="<?=rtrim(SITE_URL, '/')?>/feed.php">
</head>
<body>
    <div id="container">
        <header>
            <h1><a href="<?=rtrim(SITE_URL, '/')?>/" title="<?=SITE_NAME?>"><?=SITE_NAME?></a></h1>
        </header>
        <nav>
            <a href="<?=rtrim(SITE_URL, '/')?>/manage_post.php?action=new&type=text" title="New Text Post"><img src="images/icons/text.png" width="32" height="32" alt="New Text Post"></a>
            <a href="<?=rtrim(SITE_URL, '/')?>/manage_post.php?action=new&type=quote" title="New Quote Post"><img src="images/icons/quote.png" width="32" height="32" alt="New Quote Post"></a>
            <a href="<?=rtrim(SITE_URL, '/')?>/manage_post.php?action=new&type=link" title="New Link Post"><img src="images/icons/link.png" width="32" height="32" alt="New Link Post"></a>
            <a href="<?=rtrim(SITE_URL, '/')?>/manage_post.php?action=new&type=photo" title="New Photo Post"><img src="images/icons/photo.png" width="32" height="32" alt="New Photo Post"></a>
            <a href="<?=rtrim(SITE_URL, '/')?>/manage_post.php?action=new&type=video" title="New Video Post"><img src="images/icons/video.png" width="32" height="32" alt="New Video Post"></a>
            <a href="<?=rtrim(SITE_URL, '/')?>/manage_post.php?action=new&type=audio" title="New Audio Post"><img src="images/icons/audio.png" width="32" height="32" alt="New Audio Post"></a>
            <a href="<?=rtrim(SITE_URL, '/')?>/manage_post.php?action=new&type=code" title="New Code Post"><img src="images/icons/code.png" width="32" height="32" alt="New Code Post"></a>
        </nav>
        <? if(isset($_SESSION['flash_notice'])): ?>
        <div id="flash_notice"><?=$_SESSION['flash_notice']?></div>
        <? unset($_SESSION['flash_notice']); ?>
        <? endif ?>

        <? if(isset($_SESSION['flash_error'])): ?>
        <div id="flash_error"><?=$_SESSION['flash_error']?></div>
        <? unset($_SESSION['flash_error']); ?>
        <? endif ?>

        <?=$body?>
        <? if(isset($pagination)): ?>
        <ul id="pagination">
        <? if(!isset($post)): ?>
            <? if($pages > $page): ?>
            <li class="previous"><a href="<?=rtrim(SITE_URL, '/')?>/index.php?page=<?=floor($page+1)?>">&laquo; Older</a></li>
            <? else: ?>
            <li class="previous_off">&laquo; Older</li>
            <? endif ?>
            <? if($page == 1): ?>
            <li class="next_off">Newer &raquo;</li>
            <? else: ?>
            <li class="next"><a href="<?=rtrim(SITE_URL, '/')?>/index.php?page=<?=floor($page-1)?>">Newer &raquo;</a></li>
            <? endif ?>
        <? else: ?>
            <? if($prev_post !== null): ?>
                <li class="previous"><a href="<?=rtrim(SITE_URL, '/')?>/index.php?id=<?=$prev_post?>">&laquo; Previous Post</a></li>
            <? else: ?>
                <li class="previous_off">&laquo; Previous Post</li>
            <? endif ?>
            <? if($next_post !== null): ?>
                <li class="next"><a href="<?=rtrim(SITE_URL, '/')?>/index.php?id=<?=$next_post?>">Next Post &raquo</a></li>
            <? else: ?>
                <li class="next_off">Next Post &raquo;</li>
            <? endif ?>
        <? endif ?>
        </ul>
        <? endif ?>
        <footer>
            <a target="_blank" href="http://github.com/itws/Brain-Dump">Powered by Brain Dump</a> | <a href="<?=rtrim(SITE_URL, '/')?>/feed.php">RSS</a>
        </footer>
    </div>
</body>
</html>

