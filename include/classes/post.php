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
 * Post Management Class
 * For the creation, updating, and deletion of posts.
 */

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

class Post {
    public $id, $title, $name, $contents, $code, $link, $embed, $file, $byline, $tags, $type, $posted_on, $data;

    function __construct($id=0) {
        $this->id = 0;
        return $this->lookup($id);
    }

    public function lookup($id) {
        $sql = "SELECT * FROM posts WHERE id=?";
        if($res = db()->getRow($sql, $id)) {
            $this->data = $res;
            foreach($res as $key=>$val) {
                $this->$key = $val;
            }
            return $this->id;
        } else return false;
    }

    public function reload() {
        self::lookup($this->getID());
        return true;
    }

    public static function create($vars) {
        return self::save(false, $vars);
    }

    public function update($vars) {
        $update = self::save($this->getID(),$vars);
        if(!is_array($update)) {
            $this->reload();
            return true;
        } else return $update;
    }

    private function save($id, $vars) {

        foreach($vars as $key=>$val) if(empty($val)) unset($vars[$key]);

        $v = new Validator();
        $v->fields = $vars;

        $v->rules['title'] = 'required|min_length(2)|max_length(128)';
        $v->rules['type']  = 'required';
        $v->rules['name']  = 'required';

        switch($vars['type']) {
            case 'audio':
                $v->rules['file']  = 'required';
            break;

            case 'code':
                $v->rules['code']  = 'required';
            break;

            case 'link':
                $v->rules['link']  = 'required|valid_url';
            break;

            case 'photo':
                $v->rules['file']  = 'required';
            break;

            case 'text':
                $v->rules['contents']  = 'required';
            break;

            case 'quote':
                $v->rules['contents']  = 'required';
            break;

            case 'video':
                 $v->rules['embed']  = 'required';
            break;
        }
        $errors = $v->run();

        if(isset($vars['embed'])) {
            $vars['embed'] = trim($vars['embed']);
             if((!stristr($vars['embed'], '<object') && !stristr($vars['embed'], '</object>')) && (!stristr($vars['embed'], '<embed') && !stristr($vars['embed'], '</embed>')))
                $errors['embed'] = "Video embed code appears invalid.";
        }

        if(!$errors) {

            $query = '';
            $params = array();
            foreach($vars as $key=>$val) {
                $query .= ",$key=:$key";
                $params[$key] = $val;
            }

            if(!$id) {
                $sql = "INSERT INTO posts SET posted_on=NOW(), updated_at=NOW() $query";
            } else {
                $sql = "UPDATE posts SET updated_at=NOW() $query WHERE id=$id";
            }
            $res = db()->execute($sql, $params);
            return ($res)?true:false;
        } else {
            return $errors;
        }
    }

    public function getID()       { return $this->id; }
    public function getTitle()    { return $this->title; }
    public function getName()     { return $this->name; }
    public function getContents() { return $this->contents; }
    public function getCode()     { return $this->code; }
    public function getLink()     { return $this->link; }
    public function getEmbed()    { return $this->embed; }
    public function getFile()     { return $this->file; }
    public function getByLine()   { return $this->byline; }
    public function getTags()     { return $this->tags; }
    public function getType()     { return $this->type; }
    public function getPostedOn() { return $this->posted_on; }
    public function getData()     { return $this->data; }
}

