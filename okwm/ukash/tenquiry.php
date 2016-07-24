<html>
<head>
<title>Transaction Enquiry</title>
</head>

<body>
<a href="http://www.ukash.com"><img src="/ukash/ukash-logo.gif" border="0"></a><br /><br />

<a href="/ukash">home</a>

<center>
<h4>Allows the current transaction status to be queried within the last 48 hour window.</h4>

<FORM method="POST" action="tenquiry.php">

Ukash Number <input name="vNumber" type="text" value=""><sup>*</sup><br />
Transaction ID <input name="transID" type="text" value=""><sup>*</sup><br />
<!--Merchant Date Time <input name="date" type="text" value=""--><br /><br />

<INPUT type="submit" name="TransactionEnquiry" value="Transaction Enquiry">
</FORM>
</center>

<?php
if (isset($HTTP_POST_VARS['TransactionEnquiry'])) {
	include("uk.inc");


	$vNumber = $HTTP_POST_VARS['vNumber'];
	$transID = $HTTP_POST_VARS['transID'];
    $date = date('Y-m-d H:i:s');
	$resp = TransactionEnquiry($vNumber, $transID, $date);

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
        <tr><td>Transaction Currency</td><td>base currency (GBP)</td></tr>
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

