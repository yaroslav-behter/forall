<?php
#--------------------------------------------------------------------
# OKWM verify script lib.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003.
#--------------------------------------------------------------------
# Requires /lib/currency.asp
#--------------------------------------------------------------------
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");


 $Point[] = 99.99;   // Point for percent OKWM in $
 $Point[] = 999.99;
 $Point[] = 4999.99;

 $Up=100000;          // Потолок суммы USD
 $Down=5;            // Нижняя граница суммы WMZ
 $UpCurier = 5000;   // Потолок суммы USD для курьера
 $DownCurier = 200;  // Минимальная сумма USD для курьера

 // Комиссии OKWM
 //               out\in

 $amP = array('WMZ'  => array ('WMZ'=>'0/0/0/0',    'WME'=>'3.5/2.5/2/2', 'WMR'=>'3/2.5/2/2',   'WMU'=>'16/15/15/14',   'YAD'=>'12/10/10/10', 'USD'=>'2/1/1/1',   'EUR'=>'2/1/1/1', 'NUAH'=>'2/1/1/1'),
              'WME'  => array ('WMZ'=>'2/1/1/1',    'WME'=>'0/0/0/0',     'WMR'=>'3/2.5/2/2',   'WMU'=>'16/15/15/14',   'YAD'=>'12/10/10/10', 'USD'=>'2/1/1/1',   'EUR'=>'2/1/1/1', 'NUAH'=>'2/1/1/1'),
              'WMR'  => array ('WMZ'=>'2/1/1/1',    'WME'=>'2.5/2/1/1',   'WMR'=>'0/0/0/0',     'WMU'=>'16/15/15/14',   'YAD'=>'12/10/10/10', 'USD'=>'2/1/1/1',   'EUR'=>'2/1/1/1', 'NUAH'=>'2/1/1/1'),
              'WMU'  => array ('WMZ'=>'4/3/3/3',    'WME'=>'5/4/4/4',     'WMR'=>'5/4/4/4',     'WMU'=>'0/0/0/0',       'YAD'=>'12/10/10/10', 'USD'=>'3/2/2/2',   'EUR'=>'3/2/2/2', 'NUAH'=>'3/2/2/2'),
              'BFU'  => array ('WMZ'=>'2/2/2/2',    'WME'=>'4/3/3/3',     'WMR'=>'4/3/3/3',     'WMU'=>'4/3/3/3',       'YAD'=>'12/10/10/10', 'USD'=>'1.5/1.5/1.5/1.5',   'EUR'=>'1.5/1.5/1.5/1.5', 'NUAH'=>'1.5/1.5/1.5/1.5'),
              'PSU'  => array ('WMZ'=>'0.5/0.5/0.5/0.5','WME'=>'5/5/5/5', 'WMR'=>'2.5/2.5/2.5/2.5','WMU'=>'4/3/3/3',    'YAD'=>'12/10/10/10', 'USD'=>'0/0/0/0',   'EUR'=>'0/0/0/0', 'NUAH'=>'0/0/0/0'),
              'USD'  => array ('WMZ'=>'4/3.5/3/3',    'WME'=>'5/4/3/3',     'WMR'=>'8/7/7/6',     'WMU'=>'8/7/7/6',     'YAD'=>'12/10/10/10', 'USD'=>'0/0/0/0',   'EUR'=>'0/0/0/0', 'NUAH'=>'0/0/0/0'),
              'EUR'  => array ('WMZ'=>'4/3.5/3/3',    'WME'=>'5/4/3/3',     'WMR'=>'8/7/7/6',     'WMU'=>'8/7/7/6',     'YAD'=>'12/10/10/10', 'USD'=>'0/0/0/0',   'EUR'=>'0/0/0/0', 'NUAH'=>'0/0/0/0'),
              'NUAH' => array ('WMZ'=>'4/3.5/3/3',    'WME'=>'5/4/3/3',     'WMR'=>'8/7/7/6',     'WMU'=>'6/5/5/4',     'YAD'=>'12/10/10/10', 'USD'=>'0/0/0/0',   'EUR'=>'0/0/0/0', 'NUAH'=>'0/0/0/0'));


 $sql = "SELECT * FROM commerce_course WHERE Date=(SELECT MAX(Date) AS LastDate FROM commerce_course WHERE 1)";
 OpenSQL ($sql, $rows, $res);
 if ($rows == 1) {    $row = NULL;
    GetFieldValue ($res, $row, 'LastDate', $Date, $IsNull);
    GetFieldValue ($res, $row, 'Date', $Date, $IsNull);
    GetFieldValue ($res, $row, 'iUSD', $iUSD, $IsNull);
    GetFieldValue ($res, $row, 'oUSD', $oUSD, $IsNull);
    GetFieldValue ($res, $row, 'iEUR', $iEUR, $IsNull);
    GetFieldValue ($res, $row, 'oEUR', $oEUR, $IsNull);
    GetFieldValue ($res, $row, 'iRUR', $iRUR, $IsNull);
    GetFieldValue ($res, $row, 'oRUR', $oRUR, $IsNull);
 } else {    echo ("Ошибка системы. Коммерческий курс валют невозможно определить.<br />");
    echo ("Сообщите, пожалуйста, об ошибке в техническую поддержку сайта.<br />");
    exit;
 }
 $RK = array('USD'=>array('in'=>$iUSD,'out'=>$oUSD),
             'EUR'=>array('in'=>$iEUR,'out'=>$oEUR),
             'RUR'=>array('in'=>$iRUR,'out'=>$oRUR));

 //require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/comis.asp");

 // Return Percent okwm (amP)
 function amPercent ($im, $om) {
    global $amP;
    return $amP [$om][$im];
 }

 // Return array amP in JavaScript sintax
 function JS_amP() {
    global $amP;
    $res = "\n var amP = new Array();\n";
    $k = array_keys($amP);
    for ($i=0; $i < count($k); $i++) {
       $v = array_keys($amP[$k[$i]]);
       $res.= " amP[\"".$k[$i]."\"] = new Array(); \n";
       for ($j=0; $j < count($v); $j++) {
          $res.= " amP[\"".$k[$i]."\"][\"".$v[$j]."\"] = '". $amP[$k[$i]][$v[$j]] ."';";
       }
       $res.= "\n";
    }
    return $res;
 }

 function VerifyFormatSum (&$Sum) {
    // Проверка и нормализация формата суммы
    if (preg_match('/^\d{1,7}(\.\d{1,2})?$/',$Sum, $reg_Sum) ==1) {
      $Sum = $reg_Sum[0];
      return true;
    } else {
        return false;
    }
 }

 // Verify (InSum * Cource) - % okwm == OutSum
 function VerifySum ($InSum, $InMoney, $OutSum, $OutMoney, &$NewInSum, &$NewOutSum, $Operation) {
    global $Point, $Down, $Up, $RK;

    if (($InMoney==$OutMoney)||(($OutSum==0)&&($InSum==0))||
       ((in_array($InMoney,array("USD","EUR","NUAH","P24US","P24UA")))&&(in_array($OutMoney,array("USD","EUR","NUAH","PCB","SBRF","BANK","P24US","P24UA","GMU"))))) {
        $NewInSum = 0;
        $NewOutSum = 0;
        return false;
    }
    $NewInSum = $InSum;
    $NewOutSum = $OutSum;
    if (($InMoney=="WMZ")||($InMoney=="USD")||($InMoney=="P24US")) {
       $iValute = "USD";
    } elseif (($InMoney=="WME")||($InMoney=="EUR")||($InMoney=="UKSH")) {
       $iValute = "EUR";
    } elseif (($InMoney=="WMR")||($InMoney=="YAD")) {
       $iValute = "RUR";
    } else {
       $iValute = "UAH";
    }
    if (($OutMoney=="WMZ")||($OutMoney=="USD")||($OutMoney=="BFU")||($OutMoney=="PSU")||($OutMoney=="P24US")) {
       $oValute = "USD";
    } elseif (($OutMoney=="WME")||($OutMoney=="EUR")||($OutMoney=="UKSH")) {
       $oValute = "EUR";
    } elseif (($OutMoney=="WMR")||($OutMoney=="YAD")) {
       $oValute = "RUR";
    } else {
       $oValute = "UAH";
    }

    // Пересчет кросс-курсов из НБУ в коммерческие
    if ($iValute!="UAH") $v_iCourse = $RK[$iValute]["out"]; else $v_iCourse = 1;
    if ($oValute!="UAH") $v_oCourse = $RK[$oValute]["in"]; else $v_oCourse = 1;

    if ($iValute == $oValute) $v_Course = 1;
    else $v_Course = ($v_oCourse!=0)? $v_iCourse / $v_oCourse : 0;

    $d=0;
    //if (getenv('REMOTE_ADDR') == "93.127.52.55") { $d=1; }
    //else { $d=0; }

    if ($d==1)
    echo ("Входящие: $InSum $InMoney = $InSum $iValute; курс = $v_iCourse <br />"),
         ("Исходящие: $OutSum $OutMoney = $OutSum $oValute; курс = $v_oCourse <br />"),
         ("кросс-курс = $v_Course <br />");

    $v_inSumUSD = ($RK['USD']['out']!=0)? $InSum*$v_iCourse / ($RK['USD']['out']) : 0;
    $v_outSumUSD = ($RK['USD']['in']!=0)? $OutSum*$v_oCourse / ($RK['USD']['in']) : 0;

    $v_amPercent = amPercent ($InMoney, $OutMoney);
    if ($Operation == "sell") {      // InSum должна быть определяющая (Const)
      if ($v_inSumUSD < $Down) {        // InSum меньше минимальной суммы приема (5 USD)
          $v_inSumUSD = $Down;
          $NewInSum = $Down * ($RK['USD']['out']) / $v_iCourse;
      }
      $v_SumUSD = $v_inSumUSD;
    } else {      // OutSum должна быть определяющая (Const)
      if ($v_outSumUSD < $Down) {
        // OutSum меньше минимальной суммы выплаты (5 USD)
          $v_outSumUSD = $Down;
          $NewOutSum = $Down * ($RK['USD']['in']) / $v_oCourse;
      }
      $v_SumUSD = $v_outSumUSD;
    }

    if ($d==1)
    echo ("Обновленные суммы"),
         ("Входящие: $InSum $InMoney = $InSum $iValute; курс = $v_iCourse <br />"),
         ("Исходящие: $OutSum $OutMoney = $OutSum $oValute; курс = $v_oCourse <br />");


    if (ereg("([0-9.]{0,6})/([.0-9]{0,6})/([.0-9]{0,6})/([.0-9]{0,6})", $v_amPercent, $ar_amPercent)) {
      // Percent OKWM sum<100$ or 100$<sum<1000$ or 1000$<sum<5000$ or 5000$<sum
        if ($v_SumUSD <= $Point[0]) {
           // Sum < Point[0]
           $v_amPercent = $ar_amPercent[1]/100;
        } else if (($Point[0] < $v_SumUSD)&&($v_SumUSD <= $Point[1])) {
           // Point[0] <= Sum < Point[1]
           $v_amPercent = $ar_amPercent[2]/100;
        } else if (($Point[1] < $v_SumUSD)&&($v_SumUSD <= $Point[2])) {
           // Point[1] <= Sum < Point[2]
           $v_amPercent = $ar_amPercent[3]/100;
        } else if ($Point[2] < $v_SumUSD) {
           // Point[2] <= Sum
           $v_amPercent = $ar_amPercent[4]/100;
        }
    } else {
        $v_amPercent = 1;
    }
    if ($d==1)
    echo ("% ($v_SumUSD)<br />"),
         ($v_amPercent*100),("% <br />");

    if ($Operation == "sell") {
       // InSum -> OutSum (sell)
       $NewOutSum = round(($NewInSum - $NewInSum*$v_amPercent)*$v_Course, 2);
       $NewInSum = round($NewInSum, 2);
    } else {
       // OutSum -> InSum (buy)
       if ($v_amPercent == 1) {          // Комиссия обмена 100%, обмен не возможен
          $NewInSum = 0;
          $NewOutSum = 0;
       } else {
          $NewInSum = round($NewOutSum/(1-$v_amPercent)/$v_Course, 2);
          $NewOutSum = round($NewOutSum, 2);
       }
    }
    // Вычисление отклонения новых сумм от первоначальных сумм
    $deltaInSum = ($NewInSum!=0)? abs($InSum*100/$NewInSum-100) : 1;
    $deltaOutSum = ($NewOutSum!=0)? abs($OutSum*100/$NewOutSum-100) : 1;
    if ($d==1)
        echo ("отклонение InSum - $deltaInSum<br />"),
             ("отклонение OutSum - $deltaOutSum<br />");
    if ($deltaInSum<0.03) {
        // отклонение 0.03% принебрегается. Суммы считаются верными.
        $NewInSum = $InSum;
    }
    if ($deltaOutSum<0.03) {
        // отклонение 0.03% принебрегается. Суммы считаются верными.
        $NewOutSum = $OutSum;
    }

    return (($OutSum == $NewOutSum)&&($InSum == $NewInSum));
 }

?>