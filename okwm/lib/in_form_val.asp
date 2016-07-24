<?php
#-----------------------------------------------------------------------
# Для нового калькулятора понадобилось создать отдельные массивы валют
# При подключении дизайна пришлось вынести их в отдельный модуль
# Behter Yaroslav behter@mail.ru 28-12-2010
#-----------------------------------------------------------------------

# При изменении порядка валют в массивах необходимо внести изменения в файлы /wmu.asp, /wmupoker.asp и /wmubetfair.asp
# Коды валют надо внести в переменные inmoney и outmoney.
# wmu.asp - WMU=3; UKSH=7;
# wmupoker.asp - WMU=3; PSU=9;
# wmubetfair.asp - WMU=3; BFU=8;

$In_Val_name  = array("WMZ","WME","WMR","WMU","$,USD","&#x20AC;,евр","грн","Яндекс.Деньги");
$In_Val_code  = array("WMZ","WME","WMR","WMU","USD","EUR","NUAH","YAD");
$Out_Val_name = array("WebMoney WMZ","WebMoney WME","WebMoney WMR","WebMoney WMU","Нал Доллар, USD","Нал Евро, EUR","Нал Гривна, ГРН","Betfair USD","Pokerstars");
$Out_Val_code = array("WMZ","WME","WMR","WMU","USD","EUR","NUAH","BFU","PSU");
$Town_name    = array("Киев","Днепропетровск","Одесса"); //  (/js/main.js - строка 13) var countTown = 5;
$max_name     = $In_Val_name + $Out_Val_name + $Town_name;
?>