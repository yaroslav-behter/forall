<script language="php">
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/currency.asp");

function GetCurrStr() {

$USD_UAH = BaseCurr ("USD");
$RUB_UAH = BaseCurr ("RUR");
$EUR_UAH = BaseCurr ("EUR");
/* 1 USD = $USD_UAH UAH
   1 UAH = $UAH_RUB RUB
   1 UAH = $UAH_EUR EUR */
$EUR_USD = sprintf("%.4f",$EUR_UAH/$USD_UAH);
$USD_RUB = sprintf("%.4f",$USD_UAH/$RUB_UAH);
$UAH_USD = sprintf("%.4f",1/$USD_UAH);
$USD_UAH = sprintf("%.4f",$USD_UAH);
$RUB_UAH = sprintf("%.4f",$RUB_UAH);
$EUR_UAH = sprintf("%.4f",$EUR_UAH);


return array ("1 $ = $USD_UAH грн",
              "1 И = $EUR_UAH грн",
              "1 руб = $RUB_UAH грн",
              "1 грн = $UAH_USD $",
              "1 И = $EUR_USD $",
              "1 $ = $USD_RUB руб");
}

function GetComCurrStr() {

 $sql = "SELECT MAX(Date) AS LastDate FROM commerce_course WHERE 1";
 OpenSQL ($sql, $rows, $res);
 if ($rows == 1) {
 	$row = NULL;
    GetFieldValue ($res, $row, 'LastDate', $Date, $IsNull);
 } else {
    return "";
 }

 $sql = "SELECT * FROM commerce_course WHERE Date = '$Date'";
 OpenSQL ($sql, $rows, $res);
 if ($rows >= 1) {
    $row = NULL;
    GetFieldValue ($res, $row, 'Date', $Date, $IsNull);
    GetFieldValue ($res, $row, 'iUSD', $iUSD, $IsNull);
    GetFieldValue ($res, $row, 'oUSD', $oUSD, $IsNull);
    GetFieldValue ($res, $row, 'iEUR', $iEUR, $IsNull);
    GetFieldValue ($res, $row, 'oEUR', $oEUR, $IsNull);
    GetFieldValue ($res, $row, 'iRUR', $iRUR, $IsNull);
    GetFieldValue ($res, $row, 'oRUR', $oRUR, $IsNull);
 } else {
  	return "";
 }
$iUSD = sprintf("%.4f",$iUSD);
$oUSD = sprintf("%.4f",$oUSD);
$iEUR = sprintf("%.4f",$iEUR);
$oEUR = sprintf("%.4f",$oEUR);
$iRUR = sprintf("%.4f",$iRUR);
$oRUR = sprintf("%.4f",$oRUR);
return array ("<b>курс приема $ $iUSD</b><br /><b>курс выдачи $ $oUSD</b>",
              "<b>курс приема &euro; $iEUR</b><br /><b>курс выдачи &euro; $oEUR</b>",
              "<b>курс приема руб $iRUR</b><br /><b>курс выдачи руб $oRUR</b>");
}

</script>