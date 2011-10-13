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
 * Admin Post Management
 * For adding, editing, deleting, and managing posts.
 */

include 'braindump.inc.php';

// Allowable actions and post types.
$actions = array('edit', 'new', 'delete');
$types   = array('audio', 'code', 'link', 'photo', 'quote', 'text', 'video');

// Make sure we're performing a valid action.
if(!isset($_GET['action']) || !in_array($_GET['action'], $actions)) {
    $_SESSION['flash_error'] = "Action is invalid or not specified.";
    redirect('index.php');
} else $action = $_GET['action'];

$body=''; // just in case...

ob_start();

switch($action) {
    case 'new':
    default:
        // Make sure the post type is valid (adds another layer of protection
        // against filesystem access).
        if(!isset($_GET['type']) || !in_array($_GET['type'], $types)) {
            $_SESSION['flash_error'] = "Post type is invalid or not specified.";
            redirect('index.php');
        } else $type   = $_GET['type'];

        // Initializing an empty array here with all keys in tact just makes
        // life easier.
        $vars = array('id'=>'', 'user'=>'', 'title'=>'', 'tags'=>'', 'code'=>'',
                      'embed'=>'', 'link'=>'', 'contents'=>'', 'byline'=>'',
                      'type'=>$type, 'file'=>'');

        if($_POST) {
            $vars = cleanup_post($type); // Sanitize and format input.

            // Add the new post and display errors or redirect.
            $new_post = Post::create($vars);
            if(is_array($new_post)) $errors = $new_post;
            else redirect('index.php');
        }
        include rtrim(ROOT_DIR, '/').'/themes/' . THEME . '/templates/post.new.php';

    break;
    case 'edit':
        // Make sure the post ID is set and valid.
        if(!isset($_GET['id'])) {
            $_SESSION['flash_error'] = "Cannot find post without ID.";
            redirect('index.php');
        } else $id = (integer) $_GET['id'];

        $p = new Post($id); // Load the post to be edited.

        // Make sure the post exists.
        if($p->getID()==0) {
            $_SESSION['flash_error'] = "A post with that ID does not exist.";
            redirect('index.php');
        }

        $vars = $p->getData(); // Now we can dump the post data into the $vars
                               // variable that's used by the template.

        if($_POST) {
            $vars = cleanup_post($p->getType()); // Sanitize and format input.

            // Double-check to make sure a file is set.
            // Also delete the old file if a new one has been uploaded.
            if($p->getFile() && empty($vars['file'])) $vars['file'] = $p->getFile();
            else if($vars['file'] != $p->getFile()) @unlink(rtrim(UPLOADS_DIR, '/').'/'.$vars['type'].'/'.$p->getFile());

            // Update post and display errors or redirect.
            $edit_post = $p->update($vars);
            if(is_array($edit_post)) $errors = $edit_post;
            else redirect('index.php');
        }

        include rtrim(ROOT_DIR, '/').'/themes/' . THEME . '/templates/post.edit.php';
    break;
    case 'delete':
        // (Not very DRY, but short)

        // Make sure the post ID is set and valid.
        if(!isset($_GET['id'])) {
            $_SESSION['flash_error'] = "Cannot find post without ID.";
            redirect('index.php');
        } else $id = (integer) $_GET['id'];

        $p = new Post($id); // Load the post to be edited.

        // Make sure the post exists.
        if($p->getID()==0) {
            $_SESSION['flash_error'] = "A post with that ID does not exist.";
            redirect('index.php');
        }

        // Delete the post.
        $sql = "DELETE FROM posts WHERE id=?";
        if(db()->execute($sql, $id)) {
            // If it's an audio or photo post, delete the associated media
            // (but continue quietly if you can't).
            if($p->getFile()) @unlink(rtrim(UPLOADS_DIR, '/').'/'.$p->getType().'/'.$p->getFile());
            $_SESSION['flash_notice'] = "Post deleted successfully.";
        } else $_SESSION['flash_error'] = "Unable to delete post.";
        redirect('index.php');
    break;
}
$body = ob_get_contents();
ob_end_clean();

include rtrim(ROOT_DIR, '/').'/themes/' . THEME . '/templates/main.php';

