<?php
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");

function _TransID()
{
  $temp = time().md5(mt_rand());
  return strtoupper(substr($temp,0,20));
}

function _HttpsReqUKSH($url, $xml)
{
  // get amount for this purchase
  $request ="sRequest=".$xml;

  $ch = curl_init(UK_URL.$url);

  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
  //curl_setopt($ch, CURLOPT_CAINFO, UK_CACert);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);

  if(!($resp = curl_exec($ch))){
   return false;
  } else {
   return $resp;
  }
}

function GetSettleAmount($vCurr, $vValue, $baseCurr) {    // $vCurr - код валюты в ваучере (валюта результата)
    // $vValue - сумма исходная
    // $baseCurr - валюта исходная
    /*
    XML Input Fields
    // Сколько будет 25 USD в валюте ваучера 001 (GBP)

	<UKashTransaction>
		<ukashLogin>TestMerchant</ukashLogin>
		<ukashPassword>password123</ukashPassword>
		<voucherCurrProductCode>001</voucherCurrProductCode>
		<voucherValue>25.00</voucherValue>
		<baseCurr>USD</baseCurr>
		<brandId>UKASH00000</brandId>
	</UKashTransaction>

	XML Return Value
	<UKashTransaction>
		<settleAmount>39.31</settleAmount>
		<amountReference>123</amountReference>
		<voucherCurrency>GBP</voucherCurrency>
		<errCode>0</errCode>
		<errDescription>None</errDescription>
	</UKashTransaction>
    */

    $vValue = str_replace (",", ".", $vValue);
    $vValue = sprintf("%01.2f", $vValue);   // нормализация суммы  x.xx

    $sub_url = "/GetSettleAmount";

	$xml = "<UKashTransaction>";
	$xml.= "<ukashLogin>".UK_LOGIN."</ukashLogin>";
	$xml.= "<ukashPassword>".UK_PASSWORD."</ukashPassword>";
	$xml.= "<voucherCurrProductCode>".$vCurr."</voucherCurrProductCode>"; // 7-9 цифра ваучера, 001 - GBP
	$xml.= "<voucherValue>".$vValue."</voucherValue>";
	$xml.= "<baseCurr>".$baseCurr."</baseCurr>";
	$xml.= "<brandId>".UK_BRANDID."</brandId>";
	$xml.= "</UKashTransaction>";

    $resp = _HttpsReqUKSH($sub_url, $xml);
	// store in DB
	$sql = "insert into ukash set date=NOW(), script='GetSettleAmount', xml_query='".base64_encode($xml)."', xml_response='".base64_encode($resp)."'";
	ExecSQL($sql, $row);
	return $resp;
}

function TransactionEnquiry($vNumber, $transID, $date) {    // Allows the current transaction status to be queried within the last 48 hour window    $sub_url = "/TransactionEnquiry";
    //$transID = _TransID();
    //$date = date('Y-m-d H:i:s');

    $xml = "<UKashTransaction>";
	$xml.= "<ukashLogin>".UK_AM_LOGIN."</ukashLogin>";
	$xml.= "<ukashPassword>".UK_AM_PASSWORD."</ukashPassword>";
	$xml.= "<transactionId>".$transID."</transactionId>";
	$xml.= "<brandId>".UK_AM_BRANDID."</brandId>";
	$xml.= "<voucherNumber>".$vNumber."</voucherNumber>";
	$xml.= "<voucherValue></voucherValue>";
	$xml.= "<baseCurr></baseCurr>";
	$xml.= "<ticketValue></ticketValue>";
	$xml.= "<redemptionType>22</redemptionType>";     // 3 - Product/Service Purchase; 22 - Transaction Enquiry
	$xml.= "<merchDateTime>".$date."</merchDateTime>";
	$xml.= "<merchCustomValue></merchCustomValue>";
	$xml.= "<storeLocationId></storeLocationId>";
	$xml.= "<amountReference></amountReference>";
	$xml.= "<ukashNumber></ukashNumber>";
	$xml.= "<ukashPin></ukashPin>";
	$xml.= "</UKashTransaction>";

    $resp = _HttpsReqUKSH($sub_url, $xml);
	// store in DB
	$sql = "insert into ukash set date=NOW(), script='TransactionEnquiry', xml_query='".base64_encode($xml)."', xml_response='".base64_encode($resp)."'";
	ExecSQL($sql, $row);
	return $resp;}

function Redemption($vNumber, $vValue, $baseCurr, $tValue="", $transID="") {    // Allows Full Value and Part Spend redemption of vouchers
    $sub_url = "/Redemption";
    $vValue = str_replace (",", ".", $vValue);
    $vValue = sprintf("%01.2f", $vValue);   // нормализация суммы  x.xx
    if ($tValue != "")
        $tValue = str_replace (",", ".", $tValue);
        $tValue = sprintf("%01.2f", $tValue);   // нормализация суммы  x.xx
    if (empty($transID)) $transID = _TransID();
    $date = date('Y-m-d H:i:s');

    $xml = "<UKashTransaction>";
	$xml.= "<ukashLogin>".UK_AM_LOGIN."</ukashLogin>";
	$xml.= "<ukashPassword>".UK_AM_PASSWORD."</ukashPassword>";
	$xml.= "<transactionId>".$transID."</transactionId>";
	$xml.= "<brandId>".UK_AM_BRANDID."</brandId>";
	$xml.= "<voucherNumber>".$vNumber."</voucherNumber>";
	$xml.= "<voucherValue>".$vValue."</voucherValue>";
	$xml.= "<baseCurr>".$baseCurr."</baseCurr>";
	$xml.= "<ticketValue>".$tValue."</ticketValue>";
	$xml.= "<redemptionType>3</redemptionType>";     // 3 - Product/Service Purchase; 22 - Transaction Enquiry
	$xml.= "<merchDateTime>".$date."</merchDateTime>";
	$xml.= "<merchCustomValue></merchCustomValue>";
	$xml.= "<storeLocationId></storeLocationId>";
	$xml.= "<amountReference></amountReference>";
	$xml.= "<ukashNumber></ukashNumber>";
	$xml.= "<ukashPin></ukashPin>";
	$xml.= "</UKashTransaction>";

    $resp = _HttpsReqUKSH($sub_url, $xml);
	// store in DB
	$ip = getenv("REMOTE_ADDR");
	$sql = "insert into ukash set date=NOW(), script='Redemption', xml_query='".base64_encode($xml)."', xml_response='".base64_encode($resp)."', ip='".$ip."'";
	ExecSQL($sql, $row);
	return $resp;
}

function IssueVoucher($vNumber, $vValue, $baseCurr) {    // Allows Full Value and Part Spend redemption of vouchers
    $sub_url = "/IssueVoucher";
    $vValue = str_replace (",", ".", $vValue);
    $vValue = sprintf("%01.2f", $vValue);   // нормализация суммы  x.xx
    if ($tValue !== "")
        $tValue = sprintf("%01.2f", $tValue);   // нормализация суммы  x.xx
    $transID = _TransID();
    $date = date('Y-m-d H:i:s');

    $xml = "<UKashTransaction>";
	$xml.= "<ukashLogin>".UK_LOGIN."</ukashLogin>";
	$xml.= "<ukashPassword>".UK_PASSWORD."</ukashPassword>";
	$xml.= "<transactionId>".$transID."</transactionId>";
	$xml.= "<brandId>".UK_BRANDID."</brandId>";
	$xml.= "<voucherNumber>".$vNumber."</voucherNumber>";
	$xml.= "<voucherValue>".$vValue."</voucherValue>";
	$xml.= "<baseCurr>".$baseCurr."</baseCurr>";
	$xml.= "<ticketValue></ticketValue>";
	$xml.= "<redemptionType>4</redemptionType>";     // 3 - Product/Service Purchase; 22 - Transaction Enquiry
	$xml.= "<merchDateTime>".$date."</merchDateTime>";
	$xml.= "<merchCustomValue></merchCustomValue>";
	$xml.= "<storeLocationId></storeLocationId>";
	$xml.= "<amountReference></amountReference>";
	$xml.= "<ukashNumber></ukashNumber>";
	$xml.= "<ukashPin></ukashPin>";
	$xml.= "<shouldFail></shouldFail>";
	$xml.= "</UKashTransaction>";

    $resp = _HttpsReqUKSH($sub_url, $xml);
	// store in DB
	$ip = getenv("REMOTE_ADDR");
	$sql = "insert into ukash set date=NOW(), script='IssueVoucher', xml_query='".base64_encode($xml)."', xml_response='".base64_encode($resp)."', ip='".$ip."'";
	ExecSQL($sql, $row);
	return $resp;
}

?>