<?php
#--------------------------------------------------------------------
# AllMoney rates page for http://www.crossrates.info/?a=offer
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2007.
#--------------------------------------------------------------------
# Requires /lib/verifysum.asp
# Requires /lib/database.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/verifysum.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");

   $AutoCurrency = array("WMZ", "WME", "WMR", "WMU"); // PCUAH наверное не деньги
   // кодировка у гениев из http://www.moneyrates.info/?a=offer
   $AutoCurrencyCode = array("WMZ"=>1, "WME"=>3, "WMR"=>2, "WMU"=>20);
   $sql = "SELECT * FROM goods ORDER BY GOODS_ID";
   OpenSQL ($sql, $rows, $res);
   if ($rows) {       for ($i=0; $i<$rows; $i++) {
           $row = NULL;
           GetFieldValue ($res, $row, "GOODS_NAME", $GoodsName[$i], $IsNull);
           GetFieldValue ($res, $row, "GOODS_AMOUNT", $GoodsAmount[$i], $IsNull);
           GetFieldValue ($res, $row, "GOODS_DESCRIPTION", $GoodsDescription[$i], $IsNull);
       }
       for ($i=0; $i<$rows; $i++)
           for ($j=0; $j<$rows; $j++) {
	           if ((in_array($GoodsName[$i], $AutoCurrency)) AND (in_array($GoodsName[$j], $AutoCurrency))
	               AND ($GoodsName[$i]!=$GoodsName[$j])) {	              VerifySum(5100,$GoodsName[$i],5150,$GoodsName[$j],$in,$out,"buy");
	              $rates = round($in/$out, 4);
	              // WMZ, WME и WMR доступно меньше на 0.8% (комиссия ситстемы);
	              $GoodsAmount[$j] = (in_array($GoodsName,array("WMZ","WME","WMR","WMU")))? ($GoodsAmount[$j] - round(($GoodsAmount[$j]*0.008),2)) : $GoodsAmount[$j];
	              $res = ereg("([0-9.]{0,6})/([.0-9]{0,6})/([.0-9]{0,6})/([.0-9]{0,6})", $amP[$GoodsName[$j]][$GoodsName[$i]], $ar_amPercent);
	              echo $AutoCurrencyCode[$GoodsName[$i]].",".$AutoCurrencyCode[$GoodsName[$j]].",".
	              $rates.",".
	              $GoodsAmount[$j].";\r\n";
	           }
	       }
   }


?>