<?php
   $config_max_digits = 4;
   $config_size_image = 2; //  1..5

   function GenSecretCode() {
   	   global $config_max_digits;
	   //1) lets generate the code
	   $noautomationcode = "";
	   for($i=0; $i<$config_max_digits;$i++) {
			$sw = rand(0,1);
			if ($sw) {
				// Буква

				$noautomationcode = $noautomationcode.((rand(0,1))? strtolower(chr(rand(97,122))) : strtoupper(chr(rand(97,122))));
			} else {
				// Цифра
				$noautomationcode = $noautomationcode.rand(0,9);
			}
	   }
	   return $noautomationcode;
   }

   //functions to extract RGB values from combined 24bit color value
   function getR($col) {return (($col >> 8) >> 8) % 256;}
   function getG($col) {return ($col >> 8) % 256;}
   function getB($col) {return $col % 256;}

   function PWImage($string, $fact, $bcol, $fcol) {
       $font = 5;
       $cosrate = rand(10,19);
       $sinrate = rand(10,18);

       $charwidth = imagefontwidth($font);
       $charheight = imagefontheight($font);
       $width=(strlen($string)+2)*$charwidth;
       $height=2.5*$charheight;

       $im = @imagecreatetruecolor($width, $height) or die("Cannot Initialize new GD image stream");
       $im2 = imagecreatetruecolor($width*$fact, $height*$fact);
       $bcol = imagecolorallocate($im, $bcol[0], $bcol[1], $bcol[2]);
       $fcol = imagecolorallocate($im, $fcol[0], $fcol[1], $fcol[2]);

       imagefill($im, 0, 0, $bcol);
       imagefill($im2, 0, 0, $bcol);

       $dotcol = imagecolorallocate($im, (abs(getR($fcol)-getR($bcol)))/2.5,
                                         (abs(getG($fcol)-getG($bcol)))/2.5,
                                         (abs(getB($fcol)-getB($bcol)))/2.5);

       $dotcol2 = imagecolorallocate($im, (abs(getR($fcol)-getR($bcol)))/1.5,
                                          (abs(getG($fcol)-getG($bcol)))/1.5,
                                          (abs(getB($fcol)-getB($bcol)))/3.5);

       $linecol = imagecolorallocate($im, (abs(getR($fcol)-getR($bcol)))/2.4,
                                          (abs(getG($fcol)-getG($bcol)))/2.1,
                                          (abs(getB($fcol)-getB($bcol)))/2.5);

       for($i=0; $i<$width; $i=$i+rand(1,5)) {
           for($j=0; $j<$height; $j=$j+rand(1,5)) {
               imagesetpixel($im, $i, $j, $dotcol);
           }
       }

       imagestring($im, $font, $charwidth, $charheight/2, $string, $fcol);

       for($j=0; $j<$height*$fact; $j=$j+rand(3,6)) {
           imageline($im2, 0, $j, $width*$fact, $j, $linecol);
       }

       for($i=0; $i<$width*$fact; $i=$i+rand(4,9)) {
           imageline($im2, $i, 0, $i, $height*$fact, $linecol);
       }

       for($i=0; $i<$width*$fact; $i++) {
           for($j=0; $j<$height*$fact; $j++) {
           $x = abs(((cos($i/$cosrate)*5+sin($j/$sinrate*2)*2+$i)/$fact))%$width;
               $y = abs(((sin($j/$sinrate)*5+cos($i/$cosrate*2)*2+$j)/$fact))%$height;
               $col = imagecolorat($im, $x, $y);
               if ($col!=$bcol) imagesetpixel($im2, $i, $j, $col);
           }
       }

       for($j=0; $j<$height*$fact; $j=$j+rand(1,5)) {
           for($i=0; $i<$width*$fact; $i=$i+rand(1,5)) {
               imagesetpixel($im2, $i, $j, $dotcol2);
           }
       }

	   //header("Content-type: image/jpeg");
       imagejpeg($im2);

       imagedestroy($im);
       imagedestroy($im2);
   }


   $sid	= session_id();
   if(!$sid){
		session_start();
		$sid = session_id();
   }
   $code = GenSecretCode();
   session_register("code");
   $HTTP_SESSION_VARS["code"] = strtolower($code);

   PWImage($code, $config_size_image, array(255, 255, 255), array(0, 0, 0));

?>