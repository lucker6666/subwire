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
    Session Management Class
    -----------------------------------------------------
    For genearting and managing secure user sessions. -
    Requires mcrypt.
********************************************************/

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

class Session {

    // TODO: Some of this is deprecated in PHP5.3 and needs to be updated.
    //       For now, we're just supressing notices on mcrypt_* functions.

    private function encrypt($value) {
        $crypttext = @mcrypt_encrypt(MCRYPT_RIJNDAEL_256, $key, $value, MCRYPT_MODE_ECB);
        return $crypttext;
    }

    private function decrypt($value) {
        $decrypttext = @mcrypt_decrypt(MCRYPT_RIJNDAEL_256, $key, $value, MCRYPT_MODE_ECB);
        return trim($decrypttext);
    }

    public static function create() {
        session_start();
    }

    public static function setValue($key, $value) {
        $_SESSION[$key] = self::encrypt($value);
    }

    public static function clearValue($value) {
        foreach($value as $val) unset($_SESSION[$val]);
    }

    public static function getValue($value) {
        return self::decrypt($_SESSION[$value]);
    }

    public static function compareValue($value1, $value2) {
        return($_SESSION[$value1] == self::encrypt($value2))?true:false;
    }

    public static function destroy() {
        unset($_SESSION);
        session_destroy();
    }
}

