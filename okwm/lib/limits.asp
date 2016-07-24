<script language="PHP">
#--------------------------------------------------------------------
# OKWM bank accounts from database.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003.
#--------------------------------------------------------------------
# Requires /lib/database.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");

// disable Webmoney <=> "EGOLD", "EBULLION", "PCRUB"
$AutoCurrency = array("WMZ", "WME", "WMR", "WMU", "PCUAH", "MBU", "UKSH", "BFU", "PSU", "YAD");
$ManualCurrency = array("NUAH", "USD", "EUR", "PCB", "SBRF");

function LimitsToJS () {
   global $AutoCurrency, $ManualCurrency;
   // Output all records from GOODS base in JavaScript array
   $sql = "SELECT * FROM goods ORDER BY GOODS_ID";
   OpenSQL ($sql, $rows, $res);
   if ($rows) {
       echo <<<EOT

   var l = new Array();
EOT;
       for ($i=0; $i<$rows; $i++) {
           $row = NULL;
           GetFieldValue ($res, $row, "GOODS_NAME", $GoodsName, $IsNull);
           GetFieldValue ($res, $row, "GOODS_AMOUNT", $GoodsAmount, $IsNull);
           GetFieldValue ($res, $row, "GOODS_DESCRIPTION", $GoodsDescription, $IsNull);
           if (in_array($GoodsName, $AutoCurrency)) {
              // WMZ, WME и WMR доступно меньше на 0.8% (комисси€ ситстемы);
              $GoodsAmount = (in_array($GoodsName,array("WMZ","WME","WMR","WMU")))? ($GoodsAmount - round(($GoodsAmount*0.008),2)) : $GoodsAmount;
              echo <<<EOT

   l['$GoodsName'] = new Array();
   l['$GoodsName']['Name']  = '$GoodsDescription'; l['$GoodsName']['limit'] = '$GoodsAmount';
EOT;
           }
           if (in_array($GoodsName, $ManualCurrency)) {
              echo <<<EOT

   l['$GoodsName'] = new Array();
   l['$GoodsName']['Name']  = '$GoodsDescription'; l['$GoodsName']['limit'] = 'ѕќ «јя¬ ≈';
EOT;
           }
       }
   }
}




function LimitsToTable() {
    global $AutoCurrency, $ManualCurrency;
	// Output all records from GOODS base
	$sql = "SELECT * FROM goods ORDER BY GOODS_ID";
	OpenSQL ($sql, $rows, $res);
	if ($rows) {
	    for ($i=0; $i<$rows; $i++) {
	        $row = NULL;
	        GetFieldValue ($res, $row, "GOODS_NAME", $GoodsName, $IsNull);
	        GetFieldValue ($res, $row, "GOODS_AMOUNT", $GoodsAmount, $IsNull);
	        GetFieldValue ($res, $row, "GOODS_DESCRIPTION", $GoodsDescription, $IsNull);
	        if (in_array($GoodsName, $AutoCurrency)) {
	           // WMZ, WME и WMR доступно меньше на 0.8% (комисси€ ситстемы);
	           $GoodsAmount = (in_array($GoodsName,array("WMZ","WME","WMR","WMU")))? ($GoodsAmount - round(($GoodsAmount*0.008),2)) : $GoodsAmount;
	           echo <<<EOT

	         <li><a href="javascript:setval('to_cur','$GoodsName','$GoodsDescription')" ><div align="left"><span>$GoodsAmount</span></div>$GoodsDescription</a></li>
EOT;
	        }
	        if (in_array($GoodsName, $ManualCurrency)) {
	           echo <<<EOT

	         <li><a href="javascript:setval('to_cur','$GoodsName','$GoodsDescription')" ><div align="left"><span>по за€вке</span></div>$GoodsDescription</a></li>
EOT;
	        }
	    }
	}
}

</script>