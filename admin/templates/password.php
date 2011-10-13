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
 * Admin Login
 *  The admin login page.
 */

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');
?>
<h3>Please Log In</h3>
<form action="login.php" method="post" id="admin_login">
    <label>Password:</label>
    <input type="password" size="30" name="password">
    <input class="btn" type="submit" value="Log In">
</form>

