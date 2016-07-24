<html>
<head>
<title>Issue Voucher</title>
</head>

<body>
<a href="http://www.ukash.com"><img src="/ukash/ukash-logo.gif" border="0"></a><br /><br />

<a href="/ukash">home</a>

<center>
<h4>This IssueVoucher method allows the issuing of a new voucher based on the details provided in the request.</h4>
<p>The request requires that a valid voucher number be sent, the product code of this voucher dictates the currency<br />
the new voucher will be issued as. The currency of the product code needs to match the base currency on the request<br />
or the transaction will be rejected.
</p>

<FORM method="POST" action="issue.php">

<!--Ukash Number <input name="vNumber" type="text" value=""><sup>*</sup><br /-->
Ukash Value <input name="vValue" type="text" value=""><sup>*</sup><br />

<INPUT type="submit" name="IssueVoucher" value="IssueVoucher">
</FORM>
</center>
<pre>
<?php

if (isset($HTTP_POST_VARS['IssueVoucher'])) {
	include("uk.inc");

	//$vNumber = $HTTP_POST_VARS['vNumber'];
	$vNumber = "6337181631273230872";
	$vValue = $HTTP_POST_VARS['vValue'];
	$baseCurr = "EUR";
	$resp = IssueVoucher($vNumber, $vValue, $baseCurr);

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
        <tr><td>Transaction Value</td><td>{$result->ukashTransactionId}</td></tr>
        <tr><td>Transaction Currency</td><td>$baseCurr</td></tr>
        <tr><td>Transaction Currency Conversion</td><td>$result->currencyConversion</td></tr>
        </table>

EOT;
        if ((string) $result->IssuedVoucherNumber !== "") {            // Part Spent Voucher Accepted
            echo <<<EOT
            <p>Ukash Change</p>
	        <table>
	        <tr><td>Issue Voucher Number</td><td>{$result->IssuedVoucherNumber}</td></tr>
	        <tr><td>Issue Voucher Value</td><td>{$result->IssuedAmount}</td></tr>
	        <tr><td>Voucher Currency</td><td>{$result->IssuedVoucherCurr}</td></tr>
	        <tr><td>Issue Voucher Expiry Date</td><td>{$result->IssuedExpiryDate}</td></tr>
	        </table>
            <p>Please make sure that you have noted your change details as you will not be able to return to this screen.</p>

EOT;
        }
	} elseif ($result->txCode == 1){
	    echo "<p>Error issue: ".$result->txDescription."; ".$result->errDescription."</p>";
	} else {	    echo "<p>Error issue: (code ".$result->errCode.") ".$result->errDescription."</p>";
    }
}
?>

</pre>
</body>
</html>

