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
    RSS Feed Generation
    -----------------------------------------------------
    Generates an RSS feed of the 10 most recent posts.
********************************************************/
include 'tangerine.inc.php';
$posts = list_posts(1, POSTS_PER_PAGE*2);
header("Content-Type: application/rss+xml");
?><?='<'.'?xml version="1.0" encoding="utf-8"?'.'>'?>
<rss version="2.0">
    <channel>
        <title><?=SITE_NAME?></title>
        <link><?=SITE_URL?></link>
        <guid><?=SITE_URL?></guid>
        <pubDate><?=date("M, d Y H:i:s", time())?></pubDate>
        <description>RSS feed for <?=SITE_NAME?></description>
        <language>en-us</language>
        <copyright>Copyright (C) <?= date('Y') ?> <?=SITE_URL?></copyright>
        <? foreach($posts as $post): ?>
    	<item>
            <title><?=$post['title']?></title>
            <link><?=rtrim(SITE_URL, '/')?>/?id=<?=$post['id']?></link>
            <description>
                <![CDATA[
                <? switch($post['type']):
                   case 'text'?>
                   <?=$post['contents']?>
                <? break ?>
                <? case 'code':?>
                    <pre><code><?=htmlentities($post['code'])?></code></pre>
                    <p><?=$post['contents']?></p>
                <? break ?>
                <? case 'quote':?>
                    <blockquote><?=$post['contents']?></blockquote>
                    <cite><?=$post['byline']?></cite>
                <? break ?>
                <? case 'link':?>
                    <a class="post_link" href="<?=$post['link']?>" target="_blank"><?=$post['link']?></a>
                    <p><?=$post['contents']?></p>
                <? break ?>
                <? case 'photo':?>
                    <? $size = @getimagesize(rtrim(ROOT_DIR, '/').'/assets/photos/'.$post['file']) ?>
                    <img class="post_photo" src="<?=rtrim(SITE_URL, '/')?>/assets/photos/'.$post['file']?>" width="<?=$size[0]?>" height="<?=$size[1]?>" alt="<?=$post['title']?>">
                    <p><?=$post['contents']?></p>
                <? break ?>
                <? case 'audio':?>
                    <object type="application/x-shockwave-flash" data="<?=rtrim(SITE_URL, '/')?>/assets/player.swf" width="200" height="20">
                        <param name="movie" value="<?=rtrim(SITE_URL, '/')?>/assets/player.swf">
                        <param name="bgcolor" value="#000000">
                        <param name="FlashVars" value="mp3=<?=rtrim(SITE_URL, '/')?>/assets/audio/<?=$post['file']?>&amp;loadingcolor=444444">
                    </object>
                    <p><?=$post['contents']?></p>
                <? break ?>
                <? case 'video':?>
                    <?=$post['embed']?>
                    <p><?=$post['contents']?></p>
                <? break ?>
                <? endswitch ?>
                ]]>
            </description>
        </item>
        <? endforeach ?>
    </channel>
</rss>

