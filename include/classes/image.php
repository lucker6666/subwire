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
    Image Management Class
    -----------------------------------------------------
    For uploading, creatiing, scaling, and cropping
    images.
********************************************************/

if(!strcasecmp(basename($_SERVER['SCRIPT_NAME']),basename(__FILE__))) die('Kwaheri!');

class Image {
	public $source;
	public $destDir;
	public $resizeDir;
	public $cropDir;
	private $info = '';
	private $errorMsg = '';
	public $newWidth;
	public $newHeight;
	public $top = 0;
	public $left = 0;
	public $quality = 60;
	public $autoName = true;
	public $fileName;

	public function __construct(){
	}

	public function upload($source=''){
		if($source != ""){
			$this->source = $source;
		}
		if(is_array($this->source)){
			if($this->fileExists()){
				return false;
			}
			return $this->copyFile();
		} else {
			if(preg_match('|^http(s)?://[a-z0-9-]+(.[a-z0-9-]+)*(:[0-9]+)?(/.*)?$|i', $this->source)){
				$this->copyExternalFile();
			} else {
				return $this->source;
			}
		}
	}

	public function getError(){
		return $this->errorMsg;
	}

	public function getInfo(){
		return $this->info;
	}

	private function copyFile(){
		if(!$this->isWritable()){
			$this->errorMsg .= '<div>Error, the directory: ('.$this->destDir.') is not writable. Please fix the permission to be able to upload.</div>';
			return false;
		}
		if($this->autoName==true){
            $ext = explode('.', $this->source['name']);
            $this->fileName = token().'.'.$ext[(sizeof($ext)-1)];
		} else {
			$this->fileName = $this->source['name'];
		}
		if(copy($this->source['tmp_name'],$this->destDir . $this->fileName)){
			$this->info .= '<div>file was uploaded successfully.</div>';
			return $this->fileName;
		} else {
			$this->errorMsg .= '<div>Error, the file was not uploaded correctly because of an internal error. Please try again, if you see this message again, please contact web admin.</div>';
		    return false;
		}
	}

	private function copyExternalFile(){
        $parts = explode('.', basename($this->source));
        $ext = $parts[count($parts)-1];
        $file_name = token().'.'.$ext;
		if(copy($this->source,$this->destDir . $file_name)){
			// Done.
			$this->info .= '<div>file was uploaded successfully.</div>';
			return $file_name;
		} else {
			$this->errorMsg .= '<div>Error, the file was not uploaded correctly because of an internal error. Please try again, if you see this message again, please contact web admin.</div>';
			return false;
		}
	}

	private function uploaded(){
		if($this->source['tmp_name']=="" || $this->source['error'] !=0){
			$this->errorMsg .= '<div>Error, file was not uploaded to the server. Please try again.</div>';
			return false;
		} else
			return true;
	}

	private function preDir(){
		if($this->destDir!="" && substr($this->destDir, -1,1) != "/"){
			$this->destDir = $this->destDir . '/';
		}
		if($this->resizeDir!="" && substr($this->resizeDir, -1,1) != "/"){
			$this->destDir = $this->resizeDir . '/';
		}
		if($this->cropDir!="" && substr($this->cropDir, -1,1) != "/"){
			$this->destDir = $this->cropDir . '/';
		}
	}

	private function isWritable(){
		$err = false;
		if(!is_writeable($this->destDir) && $this->destDir!=""){
			$this->errorMsg .= '<div>Error, the directory ('.$this->destDir.') is not writeable. File could not be uploaded.</div>';
			$err = true;
		}
		if(!is_writeable($this->resizeDir) && $this->resizeDir!=""){
			$this->errorMsg .= '<div>Error, the directory ('.$this->resizeDir.') is not writeable. File could not be resized.</div>';
			$err = true;
		}
		if(!is_writeable($this->cropDir) && $this->cropDir!=""){
			$this->errorMsg .= '<div>Error, the directory ('.$this->cropDir.') is not writeable. File could not be cropped.</div>';
			$err = true;
		}
		if($err == true){
			return false;
		} else {
			return true;
		}
	}

	private function fileExists(){
		$this->preDir();
		if(file_exists($this->destDir.$this->source)){
			$this->errorMsg .= '<div>Upload error because file already exists.</div>';
			return true;
		} else {
			return false;
		}
	}

	public function crop($file='',$width='',$height='',$top='',$left=''){
		if($file!=""){ $this->source = $file;}
		if ($width != '') $this->newWidth = $width;
		if ($height != '') $this->newHeight = $height;
		if ($top != '') $this->top = $top;
		if ($left != '') $this->left = $left;
		return $this->_resize_crop(true);
	}

	public function resize($file='',$width='',$height='',$fixed='width'){
		if($file!=""){ $this->source = $file; }
		if($width != '') $this->newWidth = $width;
		if($height != '') $this->newHeight = $height;
		return $this->_resize_crop(false,$fixed);
	}

	private function getTemp(){
		if(is_array($this->source)){
			return $this->source['tmp_name'];
		} else {
			return $this->source;
		}
	}

	private function getFile(){
	    if($this->fileName) return $this->fileName;
	    else {
    		if(is_array($this->source)){
	    		return $this->source['name'];
	    	} else {
	    		return $this->source;
	    	}
	    }
	}

	private function _resize_crop ($crop,$fixed="width") {
		$ext = explode(".",$this->getFile());
		$ext = strtolower(end($ext));
		list($width, $height) = getimagesize($this->getTemp());
		if(!$crop){
			$ratio = $width/$height;
			if($fixed=="width"){
				if ($this->newWidth/$this->newHeight > $ratio) {
					$this->newWidth = $this->newHeight*$ratio;
				} else {
					$this->newHeight = $this->newWidth/$ratio;
				}
			} else {
				if ($this->newWidth/$this->newHeight > $ratio) {
					$this->newHeight = $this->newWidth*$ratio;
				} else {
					$this->newWidth = $this->newHeight/$ratio;
				}
			}
		}
		$normal  = imagecreatetruecolor($this->newWidth, $this->newHeight);
		if($ext == "jpg") {
			$src = imagecreatefromjpeg($this->getTemp());
		} else if($ext == "gif") {
            $src = imagecreatefromgif ($this->getTemp());
		} else if($ext == "png") {
            $src = imagecreatefrompng ($this->getTemp());
		}
		if($crop){
		    // Personally, I think cropping should resize first.
		    // In this case, we resize so that the smallest dimension
		    // meets the new size criteria, then crop whatever's left
		    // over on the longest dimension.

		    $x = imagesx($src);
		    $y = imagesy($src);

            if($fixed == 'width' && $x < $y) {
    		    if ($x > $this->newWidth) {
    		        $ratio = $this->newWidth / $x;
    		    	$x = $this->newWidth;
    		    	$y = $y*$ratio;
    		    }
            } else if($fixed == 'height' && $y < $x) {
		        if ($y > $this->newHeight) {
		            $ratio = $this->newHeight / $y;
		        	$x = $x*$ratio;
		        	$y = $this->newHeight;
		        }
		    }

		    $resized = imagecreatetruecolor($x, $y);
		    if($ext == "jpg") {
		    	$src = imagecreatefromjpeg($this->getTemp());
		    } else if($ext == "gif") {
                $src = imagecreatefromgif ($this->getTemp());
		    } else if($ext == "png") {
                $src = imagecreatefrompng ($this->getTemp());
		    }

		    imagecopyresampled($resized, $src, 0, 0, 0, 0, $x, $y, $width, $height);

 			if(imagecopy($normal, $resized, 0, 0, $this->top, $this->left, $this->newWidth, $this->newHeight)){
 				$this->info .= '<div>image was cropped and saved.</div>';
 			}
 			$dir = $this->cropDir;
		} else {
			if(imagecopyresampled($normal, $src, 0, 0, 0, 0, $this->newWidth, $this->newHeight, $width, $height)){
				$this->info .= '<div>image was resized and saved.</div>';
			}
			$dir = rtrim($this->resizeDir, '/').'/';
		}
		if($ext == "jpg" || $ext == "jpeg") {
			imagejpeg($normal, $dir . $this->getFile(), $this->quality);
		} else if($ext == "gif") {
			imagegif ($normal, $dir . $this->getFile());
		} else if($ext == "png") {
			imagepng ($normal, $dir . $this->getFile(),0);
		}
		imagedestroy($src);
		return $src;
	}
}

