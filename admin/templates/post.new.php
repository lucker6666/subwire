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
 * New Post
 * New Post Form
 */

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

