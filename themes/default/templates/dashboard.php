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
 * Dashboard
 * Admin dashboard.
 */

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');
?>

<section id="posts">
    <? if(count($posts) > 0): ?>
    <? foreach($posts as $p): ?>
    <div id="post-<?=$p['id']?>" class="post post_type_<?=$p['type']?>">
        <h2>
            <a href="<?=rtrim(SITE_URL, '/')?>/index.php?id=<?=$p['id']?>"><?=$p['title']?></a>
            <span>
                <a href="<?=rtrim(SITE_URL, '/')?>/manage_post.php?action=edit&id=<?=$p['id']?>">edit</a>
                <a class="delete" href="<?=rtrim(SITE_URL, '/')?>/manage_post.php?action=delete&id=<?=$p['id']?>">delete</a>
            </span>
        </h2>
        <? switch($p['type']):
           case 'text': ?>
           <?=$p['contents']?>
        <? break ?>
        <? case 'code':?>
            <pre><code><?=htmlentities($p['code'])?></code></pre>
            <p><?=$p['contents']?></p>
        <? break ?>
        <? case 'quote':?>
            <blockquote><?=$p['contents']?></blockquote>
            <cite><?=$p['byline']?></cite>
        <? break ?>
        <? case 'link':?>
            <a class="post_link" href="<?=$p['link']?>" target="_blank"><?=$p['link']?></a>
            <p><?=$p['contents']?></p>
        <? break ?>
        <? case 'photo':?>
            <? $size = @getimagesize(rtrim(ROOT_DIR, '/').'/assets/photos/'.$p['file']) ?>
            <img class="post_photo" src="<?=rtrim(SITE_URL, '/').'/assets/photos/'.$p['file']?>" width="<?=$size[0]?>" height="<?=$size[1]?>" alt="<?=$p['title']?>">
            <p><?=$p['contents']?></p>
        <? break ?>
        <? case 'audio':?>
            <object type="application/x-shockwave-flash" data="<?=rtrim(SITE_URL, '/')?>/assets/player.swf" width="200" height="20">
                <param name="movie" value="<?=rtrim(SITE_URL, '/')?>/assets/player.swf">
                <param name="bgcolor" value="#000000">
                <param name="FlashVars" value="mp3=<?=rtrim(SITE_URL, '/')?>/assets/audio/<?=$p['file']?>&amp;loadingcolor=444444">
            </object>
            <p><?=$p['contents']?></p>
        <? break ?>
        <? case 'video':?>
            <?=$p['embed']?>
            <p><?=$p['contents']?></p>
        <? break ?>
        <? endswitch ?>

        <?
            $comments = get_comments($p['id']);

            if (count($comments) > 0):
        ?>
            <ul class="comments">
                <? foreach(get_comments($p['id']) as $c): ?>
                    <li><a name="c<?= $c['id'] ?>"></a>
                        <span style="color: #<?= user_color($c['user']); ?>;"><?= $c['user'] ?>:</span>
                        <?= $c['contents'] ?>
						<i>
						(<?=Format::localDateTime($c['posted_on'],$format='d.m. - H:i',$offset=TZ,$daylight=USE_DST)?>)
						</i>
                    </li>
                <? endforeach; ?>
            </ul>
        <? endif; ?>

        <div class="newComment">
            <form method="POST" action="<?=rtrim(SITE_URL, '/')?>/manage_comment.php?action=new&id=<?=$p['id']?>">
                Name:
                <input type="text" name="user" class="user" />

                Comment:
                <input type="text" name="contents" class="comment" />

                <input type="submit" class="submit" value="send" style="display: none;" />
            </form>
        </div>
        
        <aside>
            <span class="left">
                <a href="#" onclick="toggleComment(this); return false;">Comment</a>
            </span>

            <span class="right">
                <strong>
                    From:
                    <span style="color: #<?= user_color($p['user']); ?>;"><?= $p['user'] ?></span>
                </strong>

                <strong>Posted on:</strong>
                <?=Format::localDateTime($p['posted_on'],$format='d. M - H:i',$offset=TZ,$daylight=USE_DST)?>
                
                <? if(!empty($p['tags'])): ?>
                    | <strong>Tags</strong>:
                    <? foreach(explode(' ', $p['tags']) as $tag): ?>
                        <a href="<?=rtrim(SITE_URL, '/')?>/index.php?tag=<?=$tag?>"><?=$tag?></a>
                    <? endforeach ?>
                <? endif ?>
            </span>
        </aside>
    </div>
    <? endforeach ?>
    <? else: ?>
    <div class="post">
        <? if(isset($post)): ?>
        Post not found.
        <? else: ?>
        There are currently no posts.
        <? endif ?>
    </div>
    <? endif ?>
</section>

