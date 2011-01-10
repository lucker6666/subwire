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
    New Post
    -----------------------------------------------------
    New Post Form
********************************************************/

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');
?>
<h3>New <?=ucwords($type)?> Post</h3>
<? if(isset($errors)): ?>
<div id="form_errors">
    <h4>The following errors occured:</h4>
    <ul>
    <? foreach($errors as $k=>$error) : ?>
        <li><?=$error?></li>
    <? endforeach ?>
    </ul>
</div>
<? endif ?>
<? include rtrim(ROOT_DIR, '/').'/admin/templates/post_forms/'.$type.'.php'; ?>

