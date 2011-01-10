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
    Input Validation Class
    -----------------------------------------------------
    A collection of functions for validationg user input,
    with validation rules similar to CodeIgnitor/Rails. -
    Thanks to Peter (peter@osticket.com) for some of the
    validation rules.
********************************************************/

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

class Validator {

    // IMPORTANT: The validation rules below other than 'required' return
    // true on an empty string (so 'min_length' and 'exact_length' should
    // only be used in conjunction with required).

    public $rules;
    public $fields;
    private $str;

    function run() {
        $errors = array();
        foreach($this->rules as $field=>$val) {
            $ruleset = explode('|', $val);

            if(in_array('isset', $ruleset) || in_array('required', $ruleset))
                if(!isset($this->fields[$field])) $errors[] = $this->set_error($field, 'required');

            $str = (isset($this->fields[$field]))?$this->fields[$field]:null;
            foreach($ruleset as $rule) {
                if($rule != 'required' && $rule != 'isset') {
                    $f = explode('(', $rule);
                    $func = $f[0];
                    $param = str_replace(')', '', (isset($f[1]))?$f[1]:'');
                    if($param) $result = $this->{$f[0]}($str, $param);
                    else $result = $this->{$f[0]}($str);
                    if(!$result) $errors[] = $this->set_error($field, $func);
                }
            }
        } return $errors;
    }

    public static function matches($str, $field) {
        if(empty($str)) return true;
        if (!isset($_POST[$field])) return false;
        return ($str !== $_POST[$field])?false:true;
    }

    public static function min_length($str, $val) {
        if(empty($str)) return true;
        if (preg_match("/[^0-9]/", $val)) return false;
        if (function_exists('mb_strlen')) return (mb_strlen($str) < $val) ? false : true;
        return (strlen($str) < $val)?false:true;
    }

    public static function max_length($str, $val) {
        if(empty($str)) return true;
        if (preg_match("/[^0-9]/", $val)) return false;
        if (function_exists('mb_strlen')) return (mb_strlen($str) > $val) ? false : true;
        return (strlen($str) > $val) ? false : true;
    }

    public static function exact_length($str, $val) {
        if(empty($str)) return true;
        if (preg_match("/[^0-9]/", $val)) return false;
        if (function_exists('mb_strlen')) return (mb_strlen($str) != $val) ? false : true;
        return (strlen($str) != $val)?false:true;
    }

    public static function valid_email($str) {
        if(empty($str)) return true;
        return (!preg_match("/^([a-z0-9\+_\-]+)(\.[a-z0-9\+_\-]+)*@([a-z0-9\-]+\.)+[a-z]{2,6}$/ix", $str)) ? false : true;
    }

    public static function valid_ip($str) {
        if(empty($str)) return true;
        if(!$str or empty($str))
            return false;

        $str=trim($str);
        if(preg_match("/^[0-9]{1,3}(.[0-9]{1,3}){3}$/",$str)) {
            foreach(explode(".", $str) as $block)
                if($block<0 || $block>255 )
                    return false;
            return true;
        }
        return false;
    }

    public static function alpha($str) {
        if(empty($str)) return true;
        return (!preg_match("/^([a-z])+$/i", $str))?false:true;
    }

    public static function alpha_numeric($str) {
        if(empty($str)) return true;
        return (!preg_match("/^([a-z0-9])+$/i", $str))?false:true;
    }

    public static function alpha_dash($str) {
        if(empty($str)) return true;
        return (!preg_match("/^([-a-z0-9_-])+$/i", $str))?false:true;
    }

    public static function is_numeric($str) {
        if(empty($str)) return true;
        return (!is_numeric($str))?false:true;
    }

    public static function is_integer($str) {
        if(empty($str)) return true;
        return (bool)preg_match( '/^[\-+]?[0-9]+$/', $str);
    }

    public static function is_natural($str, $nonzero=false) {
        if(empty($str)) return true;
        if($nonzero=true) if($str==0 || !preg_match( '/^[0-9]+$/', $str)) return false;
        return (bool)preg_match( '/^[0-9]+$/', $str);
    }

    public static function valid_url($str) {
        if(empty($str)) return true;
        return preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $str);
    }

    public static function valid_phone($str) {
        if(empty($str)) return true;
        $stripped=preg_replace("(\(|\)|\-|\+|[  ]+)","",$str);
        return (!is_numeric($stripped) || ((strlen($stripped)<7) || (strlen($stripped)>16)))?false:true;
    }

    private function set_error($field, $func) {
        $error_messages = array(
            'required'        =>'is required.',
            'matches'         =>'mismatch.',
            'min_length'      =>'is too short.',
            'max_length'      =>'is too long.',
            'exact_length'    =>'is the wrong length.',
            'valid_email'     =>'is not a valid e-mail address.',
            'valid_ip'        =>'is not a valid IP address.',
            'alpha'           =>'is not a letter.',
            'alpha_numberic'  =>'is not alpha-numeric',
            'alpha_dash'      =>'contains illegal characters.',
            'is_numeric'      =>'is not a number.',
            'is_natural'      =>'is not a number.',
            'is_integer'      =>'is not a number.',
            'valid_phone'     =>'is not a valid phone number.',
            'valid_url'       =>'is not a valid URL.'
        );
        return ucwords(str_replace('_', ' ', $field)).' '.$error_messages[$func];
    }
}

