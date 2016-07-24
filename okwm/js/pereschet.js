<?php
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/verifysum.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/in_form_val.asp");

global $Up;     // Потолок суммы USD
global $Down;   // Нижняя граница суммы WMZ
                // Комиссия OKWM
                // Out - сумма, которую хотят купить
                // In  - сумма, которую будут платить

global $RK;
       $USD_UAH = sprintf("%.4f",$RK["USD"]["out"]);
       $EUR_UAH = sprintf("%.4f",$RK["EUR"]["out"]);
       $RUB_UAH = sprintf("%.8f",$RK["RUR"]["out"]);
       $USD_EUR = sprintf("%.4f",($RK["USD"]["out"])/($RK["EUR"]["in"]));  // Коммерческий курс продажи EUR за USD
                                                                           // USD-in EUR-out
       $USD_RUB = sprintf("%.8f",($RK["USD"]["out"])/($RK["RUR"]["in"]));
       $EUR_RUB = sprintf("%.8f",($RK["EUR"]["out"])/($RK["RUR"]["in"]));
       $EUR_USD = sprintf("%.4f",($RK["EUR"]["out"])/($RK["USD"]["in"]));
       $RUB_USD = sprintf("%.8f",($RK["RUR"]["out"])/($RK["USD"]["in"]));
       $UAH_USD = sprintf("%.4f",1/($RK['USD']['in']));
       $RUB_EUR = sprintf("%.8f",($RK["RUR"]["out"])/($RK["EUR"]["in"]));
       $UAH_EUR = sprintf("%.4f",1/($RK["EUR"]["in"]));
       $UAH_RUB = sprintf("%.8f",1/($RK["RUR"]["in"]));

global $Town_name;
$countTown = count($Town_name);

echo <<<EOT
<!-- Hide from old browsers
//Hide from Java Script
 var Point1 = 99.99;   // первый порог в $
 var Point2 = 999.99;  // второй порог в $
 var Point3 = 4999.99; // третий порог в $
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

function InSum2OutSum (Inform, Outform, InSum) {
         var outmoney = Outform;
         var inmoney  = Inform;
         //var town = document.forms.makeexchange.town.value;
         //alert ("-="+town+"=-");
         var pos = 0;
         var C = COURSE (outmoney, inmoney);
         C = (C!=0)? 1/C : 0;
         // расчет комиссии
         InSumToBucks = SumToBucks(inmoney, InSum);
         if (P2 == '') {
            return 0;
         } else {
            pos = P2.indexOf("/");
         }
         if (InSumToBucks < Point1) {
            // комиссия до 100$, т.е. целая часть
            P2 = P2.substring(0,pos)/100;
         } else if ((Point1<=InSumToBucks)&&(InSumToBucks < Point2)) {
            // комиссия от 100$, т.е. после запятой
            P2  = P2.substring(pos+1);
            pos = P2.indexOf("/");
            P2  = P2.substring(0,pos)/100;
         }  else if ((Point2<=InSumToBucks)&&(InSumToBucks < Point3)) {
            // комиссия от 1000$, т.е. после запятой
            P2  = P2.substring(pos+1);
            pos = P2.indexOf("/");
            P2  = P2.substring(pos+1);
            pos = P2.indexOf("/");
            P2  = P2.substring(0,pos)/100;
         }  else {
            // комиссия от 5000$, т.е. после запятой
            pos = P2.lastIndexOf("/");
            P2 = P2.substring(pos+1)/100;
         }
     return (InSumToBucks < $Down)? 0 : round2((1-P2)*InSum*C);
 }

 function OutSum2InSum (Inform, Outform, OutSum) {
     var outmoney = Outform;
     var inmoney  = Inform;
     var C = COURSE (outmoney, inmoney);
     var pos = 0;
	 var K1 = 0;
	 var itog = 0;
     // расчет комиссии
     OutSumInBucks = SumToBucks(inmoney, OutSum*C);
	 if (OutSumInBucks < 5) { return 0; }
     if (P2 == '') {  return 0;  }
     pos = P2.indexOf("/");
	 K1 = P2.substring(0,pos);
  	 itog = round2(OutSum*C*(10000+100*K1+K1*K1)/10000);
     itogBucks = SumToBucks(inmoney, itog);
	 if (itogBucks > Point1) {
		P2 = P2.substring(pos+1);
	        pos = P2.indexOf("/");
	 	K1 = P2.substring(0,pos);
	  	itog = round2(OutSum*C*(10000+100*K1+K1*K1)/10000);
	  	itogBucks = SumToBucks(inmoney, itog);
		if (itogBucks > Point2) {
			P2 = P2.substring(pos+1);
		        pos = P2.indexOf("/");
		 	K1 = P2.substring(0,pos);
		  	itog = round2(OutSum*C*(10000+100*K1+K1*K1)/10000);
		  	itogBucks = SumToBucks(inmoney, itog);
			if (itogBucks > Point3) {
		 		K1 = P2.substring(pos+1);
			  	itog = round2(OutSum*C*(10000+100*K1+K1*K1)/10000);
			}
		}
	}
	return itog;
 }

 function RefComm_Back() {
         var form = document.forms.makeexchange;
         var outmoney= form.outmoney.value;
         var inmoney = form.inmoney.value;
         var outsum  = form.OutSum.value;
         var insum   = form.InSum.value;
         var comment = ((inmoney == outmoney)  ||
                       ((inmoney == "USD") ||(inmoney == "EUR") ||(inmoney == "NUAH")) &&
                       ((outmoney == "USD")||(outmoney == "EUR")||(outmoney == "NUAH")))?
             "Недопустимая операция!":
             (SumToBucks(inmoney, insum) < $Down)? "Сумма платежа должна быть не меньше "+$Down+" USD!":
             (SumToBucks(outmoney, outsum) > $Up)? "Покупка суммы более "+$Up+"\$ возможна по дополнительной договоренности!":
             ((inmoney == "WMU") && (insum > 1000))? "Сумма вывода WMU не должна превышать 1000 гривен.":
             "";

         if (Verify()) {
         	document.makeexchange.submit();
         }
 }
 function RefComm() {
	var form = document.forms.makeexchange;
	var ii = 1000;
	var jj = 1000;
	var kk = 1000;
	msg  = "Ok";
	for (var i = 0; i < form.money2out.length; i++){
		if ( document.getElementsByName("outchk"+i)[0].checked )   {jj = i;};
		if (i < form.money2give.length) {
			if ( document.getElementsByName("inchk"+i)[0].checked ) {ii = i;};
			if (i < $countTown) {
				if ( document.getElementsByName("town"+i)[0].checked )    {kk = i;};
			};
		};
	};
	if ( ii > 100 ) {
		msg = "Вы не выбрали валюту, которую хотели бы обменять!";
	};
	if ( jj > 100 ) {
		msg = "  Вы не выбрали валюту, которую хотели бы получить!";
	};
	if (( ii == 4 ) || ( ii == 5 ) || ( ii == 6 ) || ( jj == 4 ) || ( jj == 5 ) || ( jj == 6 ))  {
		if ( kk > 100 ) {
			msg = "  Вы не выбрали город, в котором хотели бы провести операцию обмена!";
		};
	};
	//if ((ii == 3) && (document.getElementsByName("OutSum6")[0].value > 1000)) {	//    msg = "Сумма вывода WMU не может превышать 1000 гривен.";
	//}
	// Submit
	if (msg=="Ok") {	    form.inmoney.value = ii;
	    form.outmoney.value = jj;
	    form.town.value = kk;
	    document.makeexchange.submit();
	} else {
	    alert(msg);
	}
 }

 function RefCancel() {
	town_off();
	for (i = 0; i < 10; i++){
		document.getElementsByName("OutSum"+i)[0].value = "";
		document.getElementsByName("outchk"+i)[0].checked = false;
		document.getElementsByName("outchk"+i)[0].style.opacity=1;
		document.getElementsByName("outchk"+i)[0].style.filter = 'alpha(opacity=100)';
		document.getElementsByName("outchk"+i)[0].style.visibility="hidden";
		document.getElementsByName("outline"+i)[0].style.opacity=0.1;
		document.getElementsByName("outline"+i)[0].style.filter = 'alpha(opacity=10)';
		document.getElementsByName("OutSum"+i)[0].style.opacity=1;
		if (i < 8){
			document.getElementsByName("InSum"+i)[0].value = "";
			document.getElementsByName("inchk"+i)[0].checked = false;
			document.getElementsByName("inchk"+i)[0].style.opacity=1;
			document.getElementsByName("inchk"+i)[0].style.filter = 'alpha(opacity=100)';
			document.getElementsByName("inchk"+i)[0].style.visibility="hidden";
			document.getElementsByName("inline"+i)[0].style.opacity=0.1;
			document.getElementsByName("inline"+i)[0].style.filter = 'alpha(opacity=10)';
			document.getElementsByName("InSum"+i)[0].style.opacity=1;
		};
	};
	document.getElementsByName("InSum0")[0].focus();
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
             // Недопустимая операция
             err = "Недопустимая операция!";
         }
         if (o_buck > $Up) {
             // Покупка суммы более N1$  возможна по дополнительной договоренности!
             err = "Покупка суммы более "+$Up+"\$ возможна по дополнительной договоренности!";
         }
         if (o_buck < $Down) {
             // Покупка суммы менее N2$ не возможна!
             err = "Покупка суммы менее "+$Down+"\$ не возможна!";
         }
         if (i_buck > $Up) {
             // Прием суммы более N3$ по дополнительной договоренности!
             err = "Прием суммы более "+$Up+"\$ по дополнительной договоренности!";
         }
         if (i_buck < $Down) {
             // Прием менее N4$ не возможен!
             err = "Прием менее "+$Down+"\$ не возможен!";
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
function In_Val_test (){
  alert(In_Val_code[2]);
}

//-->

EOT;
?>