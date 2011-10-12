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
    Admin Post Management
    -----------------------------------------------------
    Sanitizes post data and uploads images and audio.
********************************************************/
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
 * Sanitizes post data and uploads images and audio.
 */

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

// This is messy, but our list of fields is short and it
// adds an extra measure of security, so what the hell?
function cleanup_post($type) {
    $vars=array();
    $vars['type']     = $type;
    $vars['id']       = (isset($_POST['id']))?$_POST['id']:null;
    $vars['title']    = (isset($_POST['title']))?Format::stripTags($_POST['title']):null;
    $vars['contents'] = (isset($_POST['contents']))?strip_tags($_POST['contents'], '<span><div><br><ol><li><ul><img><a>'):null;
    $vars['code']     = (isset($_POST['code']))?$_POST['code']:null;
    $vars['link']     = (isset($_POST['link']))?Format::stripTags($_POST['link']):null;
    $vars['byline']   = (isset($_POST['byline']))?Format::stripTags($_POST['byline']):null;
    $vars['embed']    = (isset($_POST['embed']))?$_POST['embed']:null;
    $vars['tags']     = (isset($_POST['tags']))?Format::stripTags($_POST['tags']):null;

    // You break it, you fix it.
    // For the record, this code stinks.
    if(isset($_FILES['file'])) {
        if($type=='audio') { // Handle audio file upload.
            if($_FILES['file']['type'] != 'audio/mpeg') $vars['file']=''; // No mp3, no upload.
            else {
                // Generate the new file name.
                $parts = explode('.', $_FILES['file']['name']);
                $ext = $parts[count($parts)-1];
                $filename = token().'.'.$ext;

                // Move the file to the audio files folder and rename it.
                if(@move_uploaded_file($_FILES['file']['tmp_name'], rtrim(UPLOADS_DIR, '/').'/audio/'.$filename))
                    $vars['file']=$filename;
                else { // If that fails quietly return a blank value,
                       // so we'll either get an error (on creation) or the edit
                       // won't destroy any existing media files for the post (on edit)
                    if(!empty($vars['id'])) $vars['file']=$p->getFile();
                    else $vars['file'] = '';
                }
            }
        } else if($type='photo') { // Handle photo file upload.
            // Make sure the photo is an allowed filetype.
            $mimetypes = array('image/jpeg', 'image/pjpeg', 'image/png', 'image/gif');
            if(!in_array($_FILES['file']['type'], $mimetypes)) $vars['file']='';
            else {
                // If it is, then we process the upload and, if necessary, scale down to
                // the diemnsions specified in the config file.
                $img = new Image();
                $img->source = $_FILES['file'];
                $img->destDir = rtrim(UPLOADS_DIR, '/').'/photos';
                $img->resizeDir = $img->destDir;
                $img->autoName = true;

                // Do the upload, and if it worked, resize the photo.
                if($i=$img->upload()) {
                    $img->fileName = $i;
                    $img->newWidth = MAX_IMG_WIDTH;
                    $img->newHeight = MAX_IMG_HEIGHT;
                    $img->resize();
                    $vars['file'] = $i; // Our newly added photo!
                } else { // If it failed, again, quietly return a blank value.
                    if(!empty($vars['id'])) $vars['file']=$p->getFile();
                    else $vars['file'] = '';
                }
            }
        } else $vars['file'] = ''; // This should never happen.
    } else $vars['file'] = ''; // And, just in case.
    return $vars;
}

