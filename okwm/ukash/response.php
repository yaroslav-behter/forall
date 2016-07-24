<?php

	$result = simplexml_load_string(html_entity_decode($xml_response));
	$result = $result->UKashTransaction;

	if (DEBUG) { var_dump($result); echo "<br />"; }

	if ($result->txCode == 0){
        // Full Value Voucher Accepted
        echo <<<EOT
        <table>
        <tr><td>Transaction Status</td><td>{$result->txDescription}</td></tr>
        <tr><td>Transaction ID</td><td>{$result->transactionId}</td></tr>
        <tr><td>Transaction Value</td><td>{$result->settleAmount}</td></tr>
        <tr><td>Transaction Currency</td><td>$baseCurr</td></tr>
        </table>

EOT;
        if ((string) $result->changeIssueVoucherNumber !== "") {
            // Part Spent Voucher Accepted
            echo <<<EOT
            <p>Ukash Changed Vaucher</p>
	        <table>
	        <tr><td>Change Voucher Number</td><td>{$result->changeIssueVoucherNumber}</td></tr>
	        <tr><td>Change Voucher Value</td><td>{$result->changeIssueAmount}</td></tr>
	        <tr><td>Voucher Currency</td><td>{$result->changeIssueVoucherCurr}</td></tr>
	        <tr><td>Change Voucher Expiry Date</td><td>{$result->changeIssueExpiryDate}</td></tr>
	        </table>
            <p>Please make sure that you have noted your change details as you will not be able to return to this screen.</p>

EOT;
        }
        if ((string) $result->IssuedVoucherNumber !== "") {
            // Part Spent Voucher Accepted
            echo <<<EOT
            <p>Ukash Issued Vaucher</p>
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
	    echo "<p>Error redemption: ".$result->txDescription."; ".$result->errDescription."</p>";
	} else {
	    echo "<p>Error redemption: (code ".$result->errCode.") ".$result->errDescription."</p>";
    }


?>