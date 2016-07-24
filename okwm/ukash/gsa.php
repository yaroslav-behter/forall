<html>
<head>
<title>Get Settle Amount</title>
</head>

<body>
<a href="http://www.ukash.com"><img src="/ukash/ukash-logo.gif" border="0"></a><br /><br />

<a href="/ukash">home</a>

<center>
<h4>Retrieves the Settlement Amount based on the Voucher and Base Currency using the Voucher Value.</h4>

<FORM method="POST" action="gsa.php">

<input name="summ" type="text" value="">
<select size="1" name="vCurr">
  <option value="001">GBP</option>
  <option value="099">USD</option>
  <option value="011">EUR</option>
</select>
=> X.XX
<select size="1" name="baseCurr">
  <option value="GBP">GBP</option>
  <option value="USD">USD</option>
  <option value="EUR">EUR</option>
</select><br /><br />
<INPUT type="submit" name="GetSettleAmount" value="Get Settle Amount">
</FORM>
</center>

<?php
if (isset($HTTP_POST_VARS['GetSettleAmount'])) {
	include("uk.inc");

	$vCurr = $HTTP_POST_VARS['vCurr']; // 001 - GBP, 011 - EUR, USD - 099
	$summ = $HTTP_POST_VARS['summ'];
	$baseCurr = $HTTP_POST_VARS['baseCurr']; // 15.3 EUR = X USD
	$resp = GetSettleAmount($vCurr, $summ, $baseCurr);

	if (!$resp) {	    echo "Error: Response is empty.";
	    exit;
	}

	$result = simplexml_load_string(html_entity_decode($resp));
	$result = $result->UKashTransaction;

	if (DEBUG) var_dump($result);

	if($result->errCode == 0){	    echo "<p>$summ $vCurr => ". $result->settleAmount ." $baseCurr (001 - GBP, 011 - EUR, USD - 099)</p>";
	} else {
	    echo "<p>Error GetSettleAmount: ".$result->errDescription."</p>";
	}
}
?>


</body>
</html>
