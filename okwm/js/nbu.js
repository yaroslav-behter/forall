<?php
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");

    $str = GetCurrStr();
    $comStr = GetComCurrStr();
    $turday = date ("d.m.y");

echo <<<EOT
           var kurs_arr = new Array (
EOT;
    for ($i=0; $i < count($str); $i++) { echo "'",$str[$i],"',"; }
    $max_c = count($str)-1;
    echo <<<EOT
           '');
           var com_kurs_arr = new Array (
EOT;

    for ($i=0; $i < count($comStr); $i++) { echo "'",$comStr[$i],"',"; }
    $max_cc = count($comStr)-1;
    echo <<<EOT
           '');
           var c=1;
           var max_c = $max_c;
           var cc=1;
           var max_cc = $max_cc;
       function delay () {
              kurs_obj = document.getElementById? document.getElementById("kurs") : document.all.kurs;
              kurs_obj.innerHTML = 'Курс <a href="http://www.bank.gov.ua" target="_blank" title="Сайт Национального Банка Украины">НБУ</a> на $turday<br /><b>'+kurs_arr[c]+'</b>';
              comKurs_obj = document.getElementById? document.getElementById("comKurs") : document.all.comKurs;
              comKurs_obj.innerHTML = 'Коммерческий курс<br />'+com_kurs_arr[cc];
              if (c>=max_c) c = 0; else c++;
              if (cc>=max_cc) cc = 0; else cc++;
              top.setTimeout("delay();",5000);
         }
       top.setTimeout("delay();",5000);
EOT;
?>