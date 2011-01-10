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
    Tangerine Post Form Partial
    -----------------------------------------------------
    Video post form.
********************************************************/

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');
?>

<form action="manage_post.php?action=<?=$action?>&amp;type=<?=$vars['type']?><?=($action=='edit')?'&amp;id='.$vars['id']:''?>" method="post" enctype="multipart/form-data">
    <input type="hidden" name="id" value="<?=$vars['id']?>">
    <div class="row">
        <label>Title:</label>
        <input type="text" name="title" size="80" value="<?=$vars['title']?>">
    </div>
    <div class="row">
        <label>Video Embed Code:</label>
        <textarea rows="10" cols="80" name="embed"><?=$vars['embed']?></textarea>
    </div>
    <div class="row">
        <textarea id="rte" rows="10" cols="80" name="contents"><?=$vars['contents']?></textarea>
    </div>
    <div class="row">
        <label>Tags:</label>
        <input type="text" name="tags" size="80" value="<?=$vars['tags']?>">
    </div>
    <div class="row centered">
        <a class="cancel" href="#">cancel</a> or <input type="submit" class="btn" value="Save Post">
    </div>
</form>

