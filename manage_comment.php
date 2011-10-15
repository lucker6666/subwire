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
 * Admin Comment Management
 * For adding, editing, deleting, and managing comments.
 */

include 'braindump.inc.php';

// Allowable actions.
$actions = array('new', 'delete');

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
        // Initializing an empty array here with all keys in tact just makes
        // life easier.
        $vars = array('id'=>'', 'user'=>'', 'contents'=>'', 'post_id'=>$_GET['id']);

        if($_POST) {
            $vars = cleanup_comment($vars); // Sanitize and format input.

            // Add the new comment and display errors or redirect.
            $new_comment = Comment::create($vars);
            if(is_array($new_comment)) { $errors = $new_comment;
			die(print_r($errors, true)); }
            else redirect('index.php?id=' . $_GET['id']);
        }

    break;
    case 'delete':
        // (Not very DRY, but short)

        // Make sure the comment ID is set and valid.
        if(!isset($_GET['id'])) {
            $_SESSION['flash_error'] = "Cannot find comment without ID.";
            redirect('index.php');
        } else $id = (integer) $_GET['id'];

        $c = new Comment($id); // Load the comment to be edited.

        // Make sure the comment exists.
        if($c->getID()==0) {
            $_SESSION['flash_error'] = "A comment with that ID does not exist.";
            redirect('index.php');
        }

        // Delete the comment.
        $sql = "DELETE FROM comments WHERE id=?";
        if(db()->execute($sql, $id)) {
            $_SESSION['flash_notice'] = "Comment deleted successfully.";
        } else $_SESSION['flash_error'] = "Unable to delete comment.";
        redirect('index.php');
    break;
}
$body = ob_get_contents();
ob_end_clean();

include rtrim(ROOT_DIR, '/').'/themes/' . THEME . '/templates/header.php';
echo $body;
include rtrim(ROOT_DIR, '/').'/themes/' . THEME . '/templates/footer.php';

