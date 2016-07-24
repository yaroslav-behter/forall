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
$www_valute = array (array ("EUR", "978"),     // $www_valute - ������ �������� ����� � �� ����� �� ����� ���
                     array ("RUB", "643"),
                     array ("USD", "840"));
$Courses  = array ();
$day_ago  = 10;       // ������� ������ ������������� ����� ������

function readDatabase($data) {
    global $a_valute, $www_valute, $Courses;
    // ��������� ������ ��� ����� �� �����������
    // ��������� $date � ������� HTML
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

   // - ��� ������ ��������� � ����� ����������� ���� ������ �����
   //   � ������� HTML � BASECURRENCY (url) � ����������� �� �����
   // - ��� ����������� ���������� ���� ����������� �� ����� yyyymmdd.htm
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
         // ��������� ������ ������� ������ �����
         $data = strstr ($data, '<div class="title_info">');//���i�������� ���� ������<br/>���������� ��� ������� ����� ����� �� �������� ������</div>');
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
   // ������������ ���� ������ ������������ 1 UAH
   // �.�. 1 UAH = BaseCurr ������ ������
   global $Courses;
   return (!empty($Courses[$CharCode]))? $Courses[$CharCode] : 0;
}

// ����� ����� ���
$date_req = date ("d.m.Y", mktime (date("H"),-30,0, date ("m"), date ("d"), date("Y"))); // ���������� �������� ���������� � 30 �����
$data = createCurrFile($date_req);
if ($data) {
   // ����� ����� ��������.
   $db = readDatabase($data);
   // ��������� ����� ����� � ����
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
   // ��� ����� � ������, �������� ���� ������ �� ���� ������.
   $day = 1;
   do {
      $Yesterday = date ("d.m.Y", mktime (0,0,0, date ("m"), date ("d")-$day, date("Y")));
      $data = createCurrFile($Yesterday);
      if (!empty($data))
         $db = readDatabase ($data);
      $day++;
   } while (empty ($data));
}

// ����� ����������� ������ �����
if (count ($Courses)!= count($a_valute)) {
   $NowCourses = $Courses;
   // send mail to admin
   $title = "($date_req) �� ����� �������� ����� �� ���� �����!";
   $msg = count ($Courses)." ����� ������ �������� �� ���\r\n";
   $msg.= "C����� \lib\currency.asp\r\n";
   $msg.= "���������� �����������:\r\n - ������ �� ���� ���;\r\n - �������� � ���� ����� (������� ������ \$www_valute).\r\n������� www.okwm.com.ua\r\n";
   $from = $HTTP_SERVER_VARS['SERVER_ADMIN'];
   SendMail ($from, $title, $msg);
   if (!empty($Yesterday)) {
      // �������� ����� �� ���������� ����. ���� ����������� ������.
      $day++;
   } else {
      // �������� ����� �� ������� ����. ���� ����������� ������
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
   // ����������� �������� � ������� ������ �������� �� ����� ������.
   $Courses = array_merge ($db, $NowCourses);
}
if (count ($Courses)!= count($a_valute)) {
   // ����� ����� �� ������� ���� �� ���������� 10 ����
   HTMLError ("��������� ���������� ������ ��� ��������� ����� ����� � ������� ������������� ����� �������.<br> ��������, ����������, <a href=\"mailto:${HTTP_SERVER_VARS['SERVER_ADMIN']}\">��������������</a> �� ������.");
   exit;
}
?>