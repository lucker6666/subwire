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
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><?=SITE_NAME?> <? if(isset($post)):?> - <?=$post['title']?><?endif?></title>
    <base href="<?=rtrim(SITE_URL, '/')?>/themes/<?=THEME?>/">
    <link rel="stylesheet" href="css/main.css" type="text/css" />
    <link rel="stylesheet" href="<?=rtrim(SITE_URL, '/')?>/assets/highlight_styles/ir_black.css" type="text/css">
    <link rel="stylesheet" href="css/dot-luv/jquery.ui.css" type="text/css">
    <script type="text/javascript" src="<?=rtrim(SITE_URL, '/')?>/assets/html5.js"></script>
    <script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="js/jquery.ui.js"></script>
    <script type="text/javascript" src="<?=rtrim(SITE_URL, '/')?>/assets/highlight.js"></script>
    <script type="text/javascript" src="js/nicEdit.js"></script>
    <script type="text/javascript" src="js/main.js"></script>
    <link rel="alternate" type="application/rss+xml" title="<?=SITE_NAME?> RSS" href="<?=rtrim(SITE_URL, '/')?>/feed.php">
</head>
<body>
    <div id="container">
		<?
			if (count($__linklist) > 0) {
				echo '<ul class="linklist">';
				echo '<li><strong>' . LINKLIST_LABEL . ':</strong></li>';

				foreach ($__linklist as $label=>$url) {
					echo '<li><a href="' . $url . '" target="_blank">' . $label . '</a></li>';
				}

				echo '</ul>';
			}
		?>
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

			<div class="right">
				<a href="#" title="Show last comments" onclick="toggleLastComments(); return false;"><img src="images/icons/comments.png" width="32" height="32" alt="Show last
				comments"></a>
			</div>
        </nav>

		<div id="lastComments" class="post">
			<h2>Last comments:</h2>

			<ul>
				<? foreach(get_comments() as $c): ?>
                    <li>
						<i>(<?=Format::localDateTime($c['posted_on'],$format='d.m. - H:i',$offset=TZ,$daylight=USE_DST)?>)</i>

						<span style="color: #<?= user_color($c['user']); ?>;"><?= $c['user'] ?></span>
						to <strong><a href="<?=rtrim(SITE_URL, '/')?>/index.php?id=<?= $c['post_id'] ?>#c<?= $c['id'] ?>"><?= $c['title']
						?></a></strong>:
						
						<?= substr($c['contents'], 0, 30) ?>
						
						<strong><a href="<?=rtrim(SITE_URL, '/')?>/index.php?id=<?= $c['post_id'] ?>#c<?= $c['id']
						?>">(...)</a></strong>
                    </li>
                <? endforeach; ?>
			</ul>
		</div>

        <? if(isset($_SESSION['flash_notice'])): ?>
        <div id="flash_notice"><?=$_SESSION['flash_notice']?></div>
        <? unset($_SESSION['flash_notice']); ?>
        <? endif ?>

        <? if(isset($_SESSION['flash_error'])): ?>
        <div id="flash_error"><?=$_SESSION['flash_error']?></div>
        <? unset($_SESSION['flash_error']); ?>
        <? endif ?>


