<html>
<head>
<title>Redeem</title>
</head>

<body>
<a href="http://www.ukash.com"><img src="/ukash/ukash-logo.gif" border="0"></a><br /><br />

<a href="/ukash">home</a>

<center>
<h4>Allows Full Value and Part Spend redemption of vouchers.</h4>
<p>Ukash enables easy, safe and private online payments for everyone.
You can use Ukash without needing to share your financial or personal details online.
Find out where to get Ukash at www.ukash.com/find.
</p>

<FORM method="POST" action="redeem.php">

Ukash Number <input name="vNumber" type="text" value=""><sup>*</sup><br />
Ukash Value <input name="vValue" type="text" value=""><sup>*</sup><br />
Amount to deposit <input name="tValue" type="text" value=""> (base Currency EUR)<br /><br />

<INPUT type="submit" name="Redeem" value="Redeem">
</FORM>
</center>

<?php
if (isset($HTTP_POST_VARS['Redeem'])) {
	include("uk.inc");


	$vNumber = $HTTP_POST_VARS['vNumber'];
	$vValue = $HTTP_POST_VARS['vValue'];
	$baseCurr = "EUR";
	if (isset($HTTP_POST_VARS['tValue'])) {	    $tValue = $HTTP_POST_VARS['tValue'];
	} else {	    $tValue = "";
	}
	$resp = Redemption($vNumber, $vValue, $baseCurr, $tValue);

	if (!$resp) {	    echo "Error: false";
	    exit;
	}
    if (DEBUG) { print_r($resp); echo "<br />"; }

	$result = simplexml_load_string(html_entity_decode($resp));
	$result = $result->UKashTransaction;

	if (DEBUG) { var_dump($result); echo "<br />"; }

	if ($result->txCode == 0){        // Full Value Voucher Accepted
        echo <<<EOT
	    <p>Thank you for choosing Ukash as you preferred payment options</p>
        <table>
        <tr><td>Transaction Status</td><td>{$result->txDescription}</td></tr>
        <tr><td>Transaction ID</td><td>{$result->transactionId}</td></tr>
        <tr><td>Transaction Value</td><td>{$result->settleAmount}</td></tr>
        <tr><td>Transaction Currency</td><td>$baseCurr</td></tr>
        </table>

EOT;
        if ((string) $result->changeIssueVoucherNumber !== "") {            // Part Spent Voucher Accepted
            echo <<<EOT
            <p>Ukash Change</p>
	        <table>
	        <tr><td>Change Voucher Number</td><td>{$result->changeIssueVoucherNumber}</td></tr>
	        <tr><td>Change Voucher Value</td><td>{$result->changeIssueAmount}</td></tr>
	        <tr><td>Voucher Currency</td><td>{$result->changeIssueVoucherCurr}</td></tr>
	        <tr><td>Change Voucher Expiry Date</td><td>{$result->changeIssueExpiryDate}</td></tr>
	        </table>
            <p>Please make sure that you have noted your change details as you will not be able to return to this screen.</p>

EOT;
        }
	} elseif ($result->txCode == 1){
	    echo "<p>Error redemption: ".$result->txDescription."; ".$result->errDescription."</p>";
	} else {	    echo "<p>Error redemption: (code ".$result->errCode.") ".$result->errDescription."</p>";
    }
}
?>


</body>
</html>

