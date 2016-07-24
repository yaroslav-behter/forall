<?php
#--------------------------------------------------------------------
# OKWM currency page.
# Copyright by Behter Yaroslav (behter@mail.zp.ua), (c) 2003-2004.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------
# BaseCurr ($CodeChar);
#    var    $CodeChar = {"USD"|"EUR"|"RUR"}
#    return Exchange rate concerning the Russian rouble
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");

$a_valute = array ("EUR", "RUR", "USD");
$www_valute = array (array ("EUR", "978"),     // $www_valute - массив названий валют и их кодов на сайте НБУ
                     array ("RUB", "643"),
                     array ("USD", "840"));
$Courses  = array ();
$day_ago  = 10;       // Глубина поиска неполученного курса валюты

function readDatabase($data) {
    global $a_valute, $www_valute, $Courses;
    // создается массив для валют из переданного
    // параметра $date в формате HTML
    $pattern = "|<[^>]+>(.*)</[^>]+>|U";
    $count = preg_match_all ($pattern, $data, $Course);

    // loop through the array
    for ($i=0; $i < $count-1; $i++)
       for ($j=0; $j < count($a_valute); $j++)          if ((strstr ($Course[1][$i+1], $www_valute[$j][0]))&&
              (strstr ($Course[1][$i], $www_valute[$j][1])))
             $Courses[$a_valute[$j]] = $Course[1][$i+4]/$Course[1][$i+2];
    return $Courses;
}

function createCurrFile ($date_req) {

   // - при первом обращении в сутки скачивается база курсов валют
   //   в формате HTML с BASECURRENCY (url) и сохраняется на диске
   // - при последующих обращениях база считывается из файла yyyymmdd.htm
   $longname = FSROOT;
   if (ereg("([0-9]{1,2}).([0-9]{1,2}).([0-9]{4})", $date_req, $x)) {
      $name = sprintf("%02d%02d%02d", $x[3], $x[2], $x[1] % 100);
      $longname .= "\\$name.htm";
   }

   if (file_exists ($longname)) {
      // read the htm database of currency from directory
      $data = implode("",file($longname));
      if (!$data) {
         return false;
      } else {
         return $data;
      }
   } else {
      // read the table of currency from http://www.bank.gov.ua/
      $url = BASECURRENCY."&date=$date_req";
      $ch = curl_init($url);
      curl_setopt($ch, CURLOPT_HEADER, 0);

      $tmp = tempnam ("/tmp","cur");
      $fp = fopen ($tmp,"w");
      curl_setopt ($ch, CURLOPT_FILE, $fp);
      curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
      curl_exec ($ch);
      curl_close($ch);
      fclose($fp);

      //$tmp = "c:/windows/temp/cur6AC6.tmp";
      $data = iconv("UTF-8","Windows-1251",implode("",file($tmp)));
      unlink($tmp);

      if (!empty($data)) {
         // оставляем только таблицу курсов валют
         $data = strstr ($data, '<div class="title_info">');//Нацiональний банк України<br/>встановлює такі офіційні курси гривні до іноземної валюти</div>');
         $data = ereg_replace ("&nbsp","",$data);
         $data = ereg_replace (" ","",$data);
         $data = ereg_replace (chr(13),"",$data);
         $data = ereg_replace (chr(10),"",$data);

//         if (getenv("REMOTE_ADDR")=="93.73.92.155") echo $data;

         // save file of currency
         $fcurr = fopen ($longname, "w+");
         if ($fcurr) {
            fwrite ($fcurr, $data);
         }
         fclose ($fcurr);
         return $data;
      } else {
         return false;
      }
   }
}

function BaseCurr ($CharCode) {
   // $CharCode = "USD"|"EUR"|"RUR"
   // возвращается курс валюты относительно 1 UAH
   // т.е. 1 UAH = BaseCurr единиц валюты
   global $Courses;
   return (!empty($Courses[$CharCode]))? $Courses[$CharCode] : 0;
}

// Курсы валют НБУ
$date_req = date ("d.m.Y", mktime (date("H"),-30,0, date ("m"), date ("d"), date("Y"))); // Добавление задержки обновления в 30 минут
$data = createCurrFile($date_req);
if ($data) {
   // Курсы валют получены.
   $db = readDatabase($data);
   // Сохраняем курсы валют в базе
   $Tomorrow = date ("Y-m-d 00:00:00", mktime (0,0,0, date ("m"), date ("d")+1, date("Y")));
   $Today = date ("Y-m-d 00:00:00", mktime (0,0,0, date ("m"), date ("d"), date("Y")));
   $sql = "SELECT * FROM Course WHERE Date BETWEEN '".$Today."' AND '".$Tomorrow."'";
   //echo $sql."<br>";
   OpenSQL($sql, $row, $res);
   if ($row==0)
   {      $sql = "INSERT INTO Course (Date, USD, EUR, RUR) VALUES (NOW(), ".BaseCurr("USD").",".BaseCurr("EUR").",".BaseCurr("RUR").")";
      ExecSQL($sql,$row);
   }
} else {
   // Нет связи с банком, получаем курс валюты за день раньше.
   $day = 1;
   do {
      $Yesterday = date ("d.m.Y", mktime (0,0,0, date ("m"), date ("d")-$day, date("Y")));
      $data = createCurrFile($Yesterday);
      if (!empty($data))
         $db = readDatabase ($data);
      $day++;
   } while (empty ($data));
}

// Поиск недостающих курсов валют
if (count ($Courses)!= count($a_valute)) {
   $NowCourses = $Courses;
   // send mail to admin
   $title = "($date_req) Из банка приходят курсы не всех валют!";
   $msg = count ($Courses)." валют сервер получает из НБУ\r\n";
   $msg.= "Cкрипт \lib\currency.asp\r\n";
   $msg.= "Необходимо пересмореть:\r\n - ссылку на сайт НБУ;\r\n - названия и коды валют (править массив \$www_valute).\r\nАвтомат www.okwm.com.ua\r\n";
   $from = $HTTP_SERVER_VARS['SERVER_ADMIN'];
   SendMail ($from, $title, $msg);
   if (!empty($Yesterday)) {
      // Получены курсы за предыдущий день. Ищем недостающие раньше.
      $day++;
   } else {
      // Получены курсы за текущий день. Ищем недостающие раньше
      $day = 1;
   }
   do {
      $Yesterday = date ("d.m.Y", mktime (0,0,0, date ("m"), date ("d")-$day, date("Y")));
      $data = createCurrFile($Yesterday);
      if (!empty($data))
         $db = readDatabase ($data);
      $day++;
      if ($day>$day_ago) break;
   } while (count($db)!=count($a_valute));
   // Объединение массивов с заменой старых значений на более свежие.
   $Courses = array_merge ($db, $NowCourses);
}
if (count ($Courses)!= count($a_valute)) {
   // Курсы валют не найдены даже за предыдущие 10 дней
   HTMLError ("Произошла внутренняя ошибка при получении курса валют с сервера Национального банка Украины.<br> Сообщите, пожалуйста, <a href=\"mailto:${HTTP_SERVER_VARS['SERVER_ADMIN']}\">администратору</a> об ошибке.");
   exit;
}
?>