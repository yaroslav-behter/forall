<html>

<head>
  <title></title>
</head>

<body>

<?php
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wmparser.inc");

      // read the table of currency from http://www.ufs.com.ua/
      // Официальные курсы валют НБУ на УФС - http://www.ufs.com.ua/xml/nbu_fx.php
      // Наличные курсы гривны к валютам, Банки Украины - http://www.ufs.com.ua/xml/cash_fx.php
      // Кросс-курсы основных мировых валют - http://www.ufs.com.ua/xml/cross_fx.php (похоже не работает)
      // Межбанковские курсы валют на УФС - http://www.ufs.com.ua/xml/forex_fx.php

      $url1 = "http://www.ufs.com.ua/xml/nbu_fx.php";
      $url2 = "http://www.ufs.com.ua/xml/nbu_fx.php";
      $url3 = "http://www.ufs.com.ua/xml/cash_fx.php";
      $url4 = "http://www.ufs.com.ua/xml/forex_fx.php";

      $ch = curl_init($url1);
      curl_setopt($ch, CURLOPT_HEADER, 0);
      curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
      $data1 = curl_exec ($ch);
      curl_close($ch);

      $ch = curl_init($url2);
      curl_setopt($ch, CURLOPT_HEADER, 0);
      curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
      $data2 = curl_exec ($ch);
      curl_close($ch);

      $ch = curl_init($url3);
      curl_setopt($ch, CURLOPT_HEADER, 0);
      curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
      $data3 = curl_exec ($ch);
      curl_close($ch);

      $ch = curl_init($url4);
      curl_setopt($ch, CURLOPT_HEADER, 0);
      curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
      $data4 = curl_exec ($ch);
      curl_close($ch);

      //$data1 = iconv("UTF-8","Windows-1251",$data1);

      // WMXIParser
      $parser = new WMXIParser();
      $structure1 = $parser->Parse($date1, "windows-1251");
      $structure2 = $parser->Parse($date2, "windows-1251");
      $structure3 = $parser->Parse($date3, "windows-1251");
      $structure4 = $parser->Parse($date4, "windows-1251");
      $transformed1 = $parser->Reindex($structure1, true);
      $transformed2 = $parser->Reindex($structure2, true);
      $transformed3 = $parser->Reindex($structure3, true);
      $transformed4 = $parser->Reindex($structure4, true);

      echo "<pre>";
      print_r($transformed1);
      print_r($transformed2);
      print_r($transformed3);
      print_r($transformed4);
      echo "</pre>";
?>

</body>

</html>