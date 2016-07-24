<script language="PHP">
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/verifysum.asp");

$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;

global $Up;     // ������� ����� USD
global $Down;   // ������ ������� ����� WMZ
                // �������� OKWM
                // Out - �����, ������� ����� ������
                // In  - �����, ������� ����� �������

global $RK;
       $USD_UAH = sprintf("%.4f",$RK["USD"]["out"]);
       $EUR_UAH = sprintf("%.4f",$RK["EUR"]["out"]);
       $RUB_UAH = sprintf("%.8f",$RK["RUR"]["out"]);
       $USD_EUR = sprintf("%.4f",($RK["USD"]["out"])/($RK["EUR"]["in"]));  // ������������ ���� ������� EUR �� USD
                                                                           // USD-in EUR-out
       $USD_RUB = sprintf("%.8f",($RK["USD"]["out"])/($RK["RUR"]["in"]));
       $EUR_RUB = sprintf("%.8f",($RK["EUR"]["out"])/($RK["RUR"]["in"]));
       $EUR_USD = sprintf("%.4f",($RK["EUR"]["out"])/($RK["USD"]["in"]));
       $RUB_USD = sprintf("%.8f",($RK["RUR"]["out"])/($RK["USD"]["in"]));
       $UAH_USD = sprintf("%.4f",1/($RK['USD']['in']));
       $RUB_EUR = sprintf("%.8f",($RK["RUR"]["out"])/($RK["EUR"]["in"]));
       $UAH_EUR = sprintf("%.4f",1/($RK["EUR"]["in"]));
       $UAH_RUB = sprintf("%.8f",1/($RK["RUR"]["in"]));
echo <<<EOT
<script language="JavaScript">
<!-- Hide from old browsers
//Hide from Java Script
 var Point1 = 99.99;   // ������ ����� � $
 var Point2 = 999.99;  // ������ ����� � $
 var Point3 = 4999.99; // ������ ����� � $
 var P2 = '';
 var Course = new Array();    //    USD,      EUR,     RUB,    UAH        -out
     Course["USD"] = new Array (       1, $USD_EUR, $USD_RUB, $USD_UAH);
     Course["EUR"] = new Array ($EUR_USD,        1, $EUR_RUB, $EUR_UAH);
     Course["RUB"] = new Array ($RUB_USD, $RUB_EUR,        1, $RUB_UAH);
     Course["UAH"] = new Array ($UAH_USD, $UAH_EUR, $UAH_RUB,        1);
EOT;
 // Print array of OKWM Percent
 echo JS_amP();
 echo <<<EOT

 function InSum2OutSum (form, InSum) {
         var outmoney = form.outmoney;
         var inmoney  = form.inmoney;
         var pos = 0;
         var C = COURSE (outmoney, inmoney);
         C = (C!=0)? 1/C : 0;
         // ������ ��������
         InSumToBucks = SumToBucks(inmoney.value, InSum);
         if (P2 == '') {
            return 0;
         } else {
            pos = P2.indexOf("/");
         }
         if (InSumToBucks < Point1) {
            // �������� �� 100$, �.�. ����� �����
            P2 = P2.substring(0,pos)/100;
         } else if ((Point1<=InSumToBucks)&&(InSumToBucks < Point2)) {
            // �������� �� 100$, �.�. ����� �������
            P2  = P2.substring(pos+1);
            pos = P2.indexOf("/");
            P2  = P2.substring(0,pos)/100;
         }  else if ((Point2<=InSumToBucks)&&(InSumToBucks < Point3)) {
            // �������� �� 1000$, �.�. ����� �������
            P2  = P2.substring(pos+1);
            pos = P2.indexOf("/");
            P2  = P2.substring(pos+1);
            pos = P2.indexOf("/");
            P2  = P2.substring(0,pos)/100;
         }  else {
            // �������� �� 5000$, �.�. ����� �������
            pos = P2.lastIndexOf("/");
            P2 = P2.substring(pos+1)/100;
         }
         return (InSumToBucks < $Down)? 0 : round2((1-P2)*InSum*C);
 }

 function OutSum2InSum (form, OutSum) {
         var outmoney = form.outmoney;
         var inmoney  = form.inmoney;
         var C = COURSE (outmoney, inmoney);
         var pos = 0;
         // ������ ��������
         OutSumInBucks = SumToBucks(outmoney.value, OutSum);
         if (P2 == '') {
            return 0;
         } else {
            pos = P2.indexOf("/");
         }
         if (OutSumInBucks < Point1) {
            // �������� �� 100$, �.�. ����� �����
            P2 = P2.substring(0,pos)/100;
         } else if ((Point1<=OutSumInBucks)&&(OutSumInBucks < Point2)) {
            // �������� �� 100$, �.�. ����� �������
            P2  = P2.substring(pos+1);
            pos = P2.indexOf("/");
            P2  = P2.substring(0,pos)/100;
         }  else if ((Point2<=OutSumInBucks)&&(OutSumInBucks < Point3)) {
            // �������� �� 1000$, �.�. ����� �������
            P2  = P2.substring(pos+1);
            pos = P2.indexOf("/");
            P2  = P2.substring(pos+1);
            pos = P2.indexOf("/");
            P2  = P2.substring(0,pos)/100;
         }  else {
            // �������� �� 5000$, �.�. ����� �������
            pos = P2.lastIndexOf("/");
            P2 = P2.substring(pos+1)/100;
         }
         return (OutSumInBucks < $Down) ? 0 : round2(OutSum/(1-P2)*C);
 }

 function RefComm() {
         var form = document.forms.makeexchange;
         var outmoney= form.outmoney.value;
         var inmoney = form.inmoney.value;
         var outsum  = form.OutSum.value;
         var insum   = form.InSum.value;
         var comment = ((inmoney == outmoney)  ||
                       ((inmoney == "USD") ||(inmoney == "EUR") ||(inmoney == "NUAH")) &&
                       ((outmoney == "USD")||(outmoney == "EUR")||(outmoney == "NUAH")))?
             "������������ ��������!":
             (SumToBucks(inmoney, insum) < $Down)? "����� ������� ������ ���� �� ������ "+$Down+" USD!":
             (SumToBucks(outmoney, outsum) > $Up)? "������� ����� ����� "+$Up+"\$ �������� �� �������������� ��������������!":
             "";

         if (Verify()) {         	document.makeexchange.submit();
         }
 }

 function Verify() {
         var form = document.forms.makeexchange;
         var InSum = norm_in(form.InSum.value);
         var InMoney = form.inmoney.value;
         var i_buck = SumToBucks (InMoney, InSum);

         var OutSum = norm_in(form.OutSum.value);
         var OutMoney = form.outmoney.value;
         var o_buck = SumToBucks (OutMoney, OutSum);
         var err ="";
         if ((OutSum == 0 || OutSum == '') ||
             (InSum == 0 || InSum == '')) {
             // ������������ ��������
             err = "������������ ��������!";
         }
         if (o_buck > $Up) {
             // ������� ����� ����� N1$  �������� �� �������������� ��������������!
             err = "������� ����� ����� "+$Up+"\$ �������� �� �������������� ��������������!";
         }
         if (o_buck < $Down) {
             // ������� ����� ����� N2$ �� ��������!
             err = "������� ����� ����� "+$Down+"\$ �� ��������!";
         }
         if (i_buck > $Up) {
             // ����� ����� ����� N3$ �� �������������� ��������������!
             err = "����� ����� ����� "+$Up+"\$ �� �������������� ��������������!";
         }
         if (i_buck < $Down) {
             // ����� ����� N4$ �� ��������!
             err = "����� ����� "+$Down+"\$ �� ��������!";
         }
         if (((InMoney.substring(0,2)=="WM")&&(OutMoney=="PCUAH")) ||
             ((OutMoney.substring(0,2)=="WM")&&(InMoney=="PCUAH"))) {         	 // ��������� ������� Webmoney �� ��������� ����� ������
         	 err = "������������ �����!";
         }

         if (err != "") {
             alert (err);
             form.OutSum.select();
             form.OutSum.focus();
             return false;
         } else {
             return true;
         }
 }

//-->
</script>
EOT;
</script>