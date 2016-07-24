<?php
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");

function MB_CheckMail($mail="")
{
  $mbPassword = MB_PASSWORD;
  $mbCustID = MB_CUSTID;
  if ($mail!="") {
	  $ch = curl_init("https://www.moneybookers.com/app/email_check.pl?cust_id=$mbCustID&password=$mbPassword&email=$mail");

	  curl_setopt($ch, CURLOPT_HEADER, 0);
	  curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
      curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
	  $return = curl_exec ($ch);
	  curl_close($ch);
	  // Парсер $result
	  if (substr($return,0,2)=="OK") {          $data = explode(",", $return);
          $result = array (true, $data);
      } else          $result = array (false, $return);  } else {      $result = array(false, "");
  }
  return $result;
}


?>