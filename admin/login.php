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
    Admin Login
    -----------------------------------------------------
    User authentication for admin.
********************************************************/

include '../tangerine.inc.php';
if(is_admin()) redirect('index.php'); // Already logged in.

$body='';

// Log us in.
if(isset($_POST['password'])) {
    if($_POST['password'] == ADMIN_PASSWORD) {
        Session::setValue('is_admin', md5(SESSION_SECRET + date("d")));
        redirect('index.php');
    } else {
        $_SESSION['flash_error'] = "Incorrect password.";
        redirect('login.php');
    }
}

ob_start();

// Or display the login form.
include rtrim(ROOT_DIR, '/').'/admin/templates/password.php';

$body = ob_get_contents();
ob_end_clean();

include rtrim(ROOT_DIR, '/').'/admin/templates/admin.php';

