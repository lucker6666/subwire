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
    Input Formatting Class
    -----------------------------------------------------
    A collection of functions for formatting user input
    and DB output. - Thanks to Peter (peter@osticket.com)
    for the help.
********************************************************/

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

class Format {

    public static function date($format,$gmtimestamp,$offset=0,$daylight=false){
        if(!$gmtimestamp || !is_numeric($gmtimestamp)) return "";
        $mysql_offset = ($tz=='SYSTEM')?preg_replace('/([+-]\d{2})(\d{2})/','\1',date('O')):preg_replace('/([+-]\d{2})(:)(\d{2})/','\1',$tz);
        $gmttimestamp = $gmttimestamp-($mysql_offset*3600);
        $offset+=$daylight?date('I',$gmtimestamp):0;
        return date($format,($gmtimestamp+($offset*3600)));
    }

    public static function fileSize($bytes) {
        if($bytes<1024) return $bytes.' bytes';
        if($bytes <102400) return round(($bytes/1024),1).' kb';
        return round(($bytes/1024000),1).' mb';
    }

    public static function fileName($filename) {
        $search = array('/ß/','/ä/','/Ä/','/ö/','/Ö/','/ü/','/Ü/','([^[:alnum:]._])');
        $replace = array('ss','ae','Ae','oe','Oe','ue','Ue','_');
        return preg_replace($search,$replace,$filename);
    }

    public static function phone($phone, $uk=false, $fax=false) {
        $stripped= preg_replace("/[^0-9]/", "", $phone);
        if($uk===false) {
            if(strlen($stripped) == 7) return preg_replace("/([0-9]{3})([0-9]{4})/", "$1-$2",$stripped);
            elseif(strlen($stripped) == 10) return preg_replace("/([0-9]{3})([0-9]{3})([0-9]{4})/", "($1) $2-$3",$stripped);
            else return $stripped;
        } else {
            return self::ukTelFax($phone, $fax);
        }
    }

    public static function currency($amount, $symbol='$') {
        return $symbol.number_format($amount,2);
    }

    public static function truncate($string,$len,$hard=false) {
        if(!$len || $len>strlen($string)) return $string;
        $string = substr($string,0,$len);
        return $hard?$string:(substr($string,0,strrpos($string,' ')).' ...');
    }

    public static function htmlChars($var) {
        return is_array($var)?array_map(array('Format','htmlchars'),$var):htmlentities($var,ENT_QUOTES);
    }

    public static function input($var) {
        return Format::htmlChars($var);
    }

    public static function stripTags($string) {
        return strip_tags(html_entity_decode($string)); // ...no mercy!
    }

    public static function clickableURLs($text) {
        $text=preg_replace('/(((f|ht){1}tp(s?):\/\/)[-a-zA-Z0-9@:%_\+.~#?&;\/\/=]+)/','<a href="\\1" target="_blank">\\1</a>', $text);
        $text=preg_replace("/(^|[ \\n\\r\\t])(www\.([a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+)(\/[^\/ \\n\\r]*)*)/",
                '\\1<a href="http://\\2" target="_blank">\\2</a>', $text);
        $text=preg_replace("/(^|[ \\n\\r\\t])([_\.0-9a-z-]+@([0-9a-z][0-9a-z-]+\.)+[a-z]{2,4})/",'\\1<a href="mailto:\\2" target="_blank">\\2</a>', $text);
        return $text;
    }

    public static function stripEmptyLines ($string) {
        return preg_replace("/\n{3,}/", "\n\n", $string);
    }

    public static function lineBreaks($string) {
        return urldecode(ereg_replace("%0D", " ", urlencode($string)));
    }

    public static function elapsedTime($sec){
        if(!$sec || !is_numeric($sec)) return "";
        $days = floor($sec / 86400);
        $hrs = floor(bcmod($sec,86400)/3600);
        $mins = round(bcmod(bcmod($sec,86400),3600)/60);
        if($days > 0) $tstring = $days . 'd,';
        if($hrs > 0) $tstring = $tstring . $hrs . 'h,';
        $tstring =$tstring . $mins . 'm';
        return $tstring;
    }

    public static function csvQuote($str) {
        $str = preg_replace('/"/','""', $str);
        return $str;
    }

    public static function localDateTime($var,$format='Y-m-d H:i:s',$offset=0,$daylight=false) {
        global $cfg;
        $format = str_replace('%', '', $format);
        $mysqlTZOffset = ($tz='SYSTEM')?preg_replace('/([+-]\d{2})(\d{2})/','\1',date('O')):preg_replace('/([+-]\d{2})(:)(\d{2})/','\1',$tz);
        $dbtime=is_int($var)?$var:strtotime($var);
        $timestamp = $dbtime-($mysqlTZOffset*3600);
        if(!$timestamp || !is_numeric($timestamp)) return "";
        $offset+=$daylight?date('I',$timestamp):0; //Daylight savings crap.
        return date($format,($timestamp+($offset*3600)));
    }

    public static function ukTelFax($number,$fax=false) {
        $number=ereg_replace( '[^0-9]+','',str_replace("+", "00", $number));
        $numberArray = self::splitNumber($number,explode(",",self::getTelephoneFormat($number)));
        if (substr($number,0,2)=="01" || substr($number,0,2)=="02") $numberArray[0]="(".$numberArray[0].")";
        $formattedNumber = implode(" ",$numberArray);
        return $formattedNumber;
    }

    private static function getTelephoneFormat($number) {
        $telephoneFormat = array ( '02' => "3,4,4", '03' => "4,3,4", '05' => "5,6",
            '0500' => "4,6", '07' => "5,6", '08' => "4,3,4", '09' => "4,3,4",
            '01' => "5,6", '011' => "4,3,4", '0121' => "4,3,4", '0131' => "4,3,4",
            '0141' => "4,3,4", '0151' => "4,3,4", '0161' => "4,3,4", '0191' => "4,3,4",
            '013873' => "6,5", '015242' => "6,5", '015394' => "6,5",'015395' => "6,5",
            '015396' => "6,5", '016973' => "6,5", '016974' => "6,5", '017683' => "6,5",
            '017684' => "6,5", '017687' => "6,5", '019467' => "6,5", '0169737' => "5,6",
            '0169772' => "6,4", '0169773' => "6,4", '0169774' => "6,4");

        uksort($telephoneFormat, "self::sortStrLen");
        foreach ($telephoneFormat AS $key=>$value) {
            if (substr($number,0,strlen($key)) == $key) break;
            };
        return $value;
    }

    private static function splitNumber($number,$split) {
        $start=0;
        $array = array();
        foreach($split AS $value) {
            $array[] = substr($number,$start,$value);
            $start = $value;
            }
        return $array;
    }

    private static function sortStrLen($a, $b) {return strlen($b)-strlen($a);}
}

