<?php
require_once ("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/verifysum.asp");
require_once ("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/xajax/xajax_core/xajax.inc.php");

$xajax = new xajax();
//$xajax->configure('debug', true);

function calc($formData)
{
	$objResponse = new xajaxResponse();
	$formData['inSum'] = str_replace (",", ".", $formData['inSum']);
	$formData['outSum'] = str_replace (",", ".", $formData['outSum']);
	$res = VerifySum($formData['inSum'], $formData['inMoney'], $formData['outSum'], $formData['outMoney'], $NewInSum, $NewOutSum, $formData['Action'])? "OK" : "No";

    $objResponse->assign("outSum", "value", $NewOutSum);
	$objResponse->assign("inSum", "value", $NewInSum);
	$objResponse->assign("submittedDiv", "innerHTML", nl2br("$res: $NewInSum ${formData['inMoney']} => $NewOutSum ${formData['outMoney']}"));
	return $objResponse;
}

$xajax->registerFunction("calc");
$xajax->processRequest();

?>