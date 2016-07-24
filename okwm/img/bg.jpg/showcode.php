<?PHP
	error_reporting(85);//serious error only
	require(dirname(__FILE__)."/config.php");
	$sid=trim($HTTP_GET_VARS["sid"]);

	session_id($sid);
	session_start();
	$noautomationcode = $HTTP_SESSION_VARS["noautomationcode"];
	$img_path	= dirname(__FILE__)."/$config_back_image";
	$img		= ImageCreateFromJpeg($img_path);
	$img_size	= getimagesize($img_path);

	$fw = imagefontwidth($config_font);
	$fh = imagefontheight($config_font);

	$x = ($img_size[0] - strlen($noautomationcode)*$fw)/2;
	$y = ($img_size[1] - $fh)/2; // middle of the code string will be in middle of the background image

	$color = imagecolorallocate($img,
								hexdec(substr($config_code_color,1,2)),
								hexdec(substr($config_code_color,3,2)),
								hexdec(substr($config_code_color,5,2))
								);
	imagestring ( $img, $config_font, $x, $y, $noautomationcode, $color);
	header("Content-type: image/jpeg");
	imagejpeg($img);

?>