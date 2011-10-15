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
 * Comment Management Class
 * For the creation, updating, and deletion of comments.
 */

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

class Comment {
    public $id, $user, $contents, $posted_on, $post_id, $data;

    function __construct($id=0) {
        $this->id = 0;
        return $this->lookup($id);
    }

    public function lookup($id) {
        $sql = "SELECT * FROM comments WHERE id=?";
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

        $v->rules['contents'] = 'required|min_length(2)';
        $v->rules['user']  = 'required';

        $errors = $v->run();

        if(!$errors) {
            $query = '';
            $params = array();
            foreach($vars as $key=>$val) {
                $query .= ",$key=:$key";
                $params[$key] = $val;
            }

            if(!$id) {
                $sql = "INSERT INTO comments SET posted_on=NOW() $query";
            } else {
                $sql = "UPDATE comments SET $query WHERE id=$id";
            }
            $res = db()->execute($sql, $params);
            return ($res)?true:false;
        } else {
            return $errors;
        }
    }

    public function getID()       { return $this->id; }
    public function getPostId()   { return $this->post_id; }
    public function getContents() { return $this->contents; }
    public function getUser()     { return $this->user; }
    public function getPostedOn() { return $this->posted_on; }
    public function getData()     { return $this->data; }
}

