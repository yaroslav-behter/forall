<?php

// 10.09.2001
// (win1251 encoded)
//
//----------   WM HTTPS-interface example
//----------   Пример использования WM HTTPS-интерфейсов
//
// Webmoney Transfer (c), Shaposhnikov Max    (maxicus@hotmail.com)

//          ******************************************************
//          ***   Модуль реализации функций htts-интерфейсов   ***
//          ******************************************************

include("wmconst.inc");
//require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wmconst.inc");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wmparser.inc");

/////////////////////////////////////////////////////////////////
// _DateID - Возвращает уникальное 14-байтовое значение.
//           Для внутреннего пользования функциями данного модуля
//
// Возвращает :
//   Строку - уникальное значение

function _DateID()
{
  $tm = localtime(time(), 1);

  return sprintf( "%04d%02d%02d%02d%02d%02d", $tm["tm_year"]+1900, $tm["tm_mon"]+1,
                  $tm["tm_mday"], $tm["tm_hour"], $tm["tm_min"], $tm["tm_sec"]
                );
}



/////////////////////////////////////////////////////////////////
// _GetSign - формирование строки подписи.
//            Для внутреннего пользования функциями данного модуля
//
// Параметры :
//   $inStr  - Строка для подписи
// Возвращает :
//   Строку - подпись
//
//! Для работы функции в той же директории, что и запушенный скрипт (не путайте
//! с местом расположения данного файла-модуля), должны существовать файлы
//! WMSigner и WMSigner.ini

function _GetSign($inStr)
{
  global $HTTP_SERVER_VARS;
  //$root = $HTTP_SERVER_VARS['DOCUMENT_ROOT'];
  $root = "c:/var/spool/okwm/wm";
  $tmp  = tempnam ("/tmp","wm");
  $PlanStr = "$inStr\004\r\n";
  $fp = fopen ($tmp, "w");
  fwrite($fp,$PlanStr);
  fclose($fp);
  $res = exec ("$root/WMSigner.exe <$tmp", $a);
  unlink($tmp);
  return $res;
}



/////////////////////////////////////////////////////////////////
// _HttpsReq - реализация https-запроса к сертификационному центру webmoney
//             Для внутреннего пользования функциями данного модуля
//
// Параметры :
//   $addr  - Адрес запроса (начиная с имени скрипта)
//            пр. "/cgi-bin/myscript.cgi?PRM1=VAL1"
// Возвращает :
//   Результат вызова https-запроса (без заголовков)

function _HttpsReq($addr, $post="")
{
  global $wmCAcert;
  $ch = curl_init("https://w3s.webmoney.ru".$addr);
  curl_setopt($ch, CURLOPT_HEADER, 0);
  // CURLOPT_RETURNTRANSFER часто работает некорректно, но попробуем
  curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
  //curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  //curl_setopt($ch, CURLOPT_SSLVERSION, 3);
  curl_setopt($ch, CURLOPT_CAINFO, $wmCAcert);
  if ($post !== "")
  {
     curl_setopt ($ch, CURLOPT_POST, 1);
     curl_setopt ($ch, CURLOPT_POSTFIELDS, $post);
  }

  //$tmp = tempnam ("/tmp","wm");
  //$fp = fopen ($tmp,"w");
  //curl_setopt ($ch, CURLOPT_FILE, $fp);
  $result = curl_exec ($ch);
  /*if (getenv("REMOTE_ADDR")=="82.207.125.214")  {      echo curl_error($ch);
      echo " res=".$result;
  }*/

  curl_close($ch);
  //fclose($fp);

  //$fp = fopen ($tmp,"r");
  //$result = fgets($fp,1024);
  //fclose($fp);
  //unlink($tmp);
  return $result;
}



/////////////////////////////////////////////////////////////////
// InvCreate - выписка счета
//
// Параметры :
//   $wmid   - WMидентификатор получателя счета
//   $summ   - Сумма счета (. - разделитель)
//   $inv_id - № счета в магазине
//   $dsc    - Описание покупки (win1251 encoding)
//   $adr    - Адрес доставки (win1251 encoding)
// Возвращает :
//   2-хэлеметный массив ($wminv_id, $err), где
//     $wminv_id - номер созданного счета (внутренний номер WM-счета)
//     $err      - текст ошибки
//
// При успешной отработке $wminv_id содержит положительный номер созданного
// счета (это внутренний номер счета, уникальный среди всех счетов WM).
// В случае ошибки $wminv_id содержит пустую строку, а $err - текст ошибки,
// приведшей к этому.
//
//! Для работы функции в той же директории, что и запушенный скрипт (не путайте
//! с местом расположения данного файла-модуля), должны существовать файлы
//! WMSigner и WMSigner.ini

function InvCreate($wmid, $summ, $inv_id, $dsc, $adr, $purse, $protect=0)
{
  $summ = sprintf("%d", $summ*100)/100;   // нормализация суммы

  global $wmconst__shop_wmzpurse;
  global $wmconst__shop_wmepurse;
  global $wmconst__shop_wmrpurse;
  global $wmconst__shop_wmupurse;
  global $wmconst__shop_wmid;
  global $wmconst__invc_active;

  $OrderID       = "$inv_id";                   // № счета
  // Кошелек в магазине, куда будут перечислены деньги
  if ($purse=="E") { $PurseOfStores = "$wmconst__shop_wmepurse"; }
  if ($purse=="Z") { $PurseOfStores = "$wmconst__shop_wmzpurse"; }
  if ($purse=="R") { $PurseOfStores = "$wmconst__shop_wmrpurse"; }
  if ($purse=="U") { $PurseOfStores = "$wmconst__shop_wmupurse"; }
  $LoginOfStores = "$wmconst__shop_wmid";       // WM id магазина
  $LoginOfCust   = "$wmid";                     // WM id покупателя
  $InvAddress    = "$adr";                      // Адрес доставки
  $Amount        = "$summ";                     // Сумма
  $Desc          = "$dsc";                      // Описание покупки
  $Period        = "$protect";                  // Срок протекции
  $Experation    = "$wmconst__invc_active";     // Время действительности счета
  $RequestN      = _DateID();                   // Монотонно возрастающий номер запроса

  // Формирование строки для подписи
  $PlanStr = "$OrderID$LoginOfCust$PurseOfStores$Amount$Desc$InvAddress$Period$Experation$RequestN";
  // Формирование подписи
  $SignStr = _GetSign($PlanStr);
  // https-запрос
  $W3sUrl="/asp/Invoice.asp?SL=$LoginOfStores&SP=$PurseOfStores&CL=$LoginOfCust&IN=$OrderID&D=".
          urlencode($Desc)."&AD=".urlencode($InvAddress).
          "&A=$Amount&E=$Experation&P=$Period&RN=$RequestN&SS=$SignStr";

  $httpsRes = _HttpsReq($W3sUrl);

  // Разбор полученного от сертификационного цента результата
  $err      = "Ошибка связи с сертификационным центром WebMoney";
  $wminv_id = "";

  if (substr($httpsRes,0,6) == "Error:")
  {
    $errCode = sprintf("%d", substr($httpsRes,6));

    $err = "Неизвестная ошибка";
    if ($errCode == "-9")
    { $err = "Неверная подпись"; }
    elseif ($errCode == "-8")
    { $err = "R==uestN задан некорректно"; }
    elseif ($errCode == "-7")
    { $err = "Слишком длинный адрес доставки"; }
    elseif ($errCode == "-6")
    { $err = "Слишком длинное описание"; }
    elseif ($errCode == "-5")
    { $err = "Неверно задана сумма"; }
    elseif ($errCode == "-4")
    { $err = "Неверно задан WM-идентификатор web-ресурса"; }
    elseif ($errCode == "-3")
    { $err = "Неверно задан WM-кошелек web-ресурса"; }
    elseif ($errCode == "-2")
    { $err = "Неверно задан WM-идентификатор покупателя"; }
    elseif ($errCode == "-1")
    { $err = "Неверно задан номер счета"; }
    elseif ($errCode == "5")
    { $err = "Web-ресурса с указанным идентификатором не существует"; }
    elseif ($errCode == "6")
    { $err = "Покупателя с указанным идентификатором не существует"; }
    elseif ($errCode == "7")
    { $err = "Указанного WM-кошелька web-ресурса не существует"; }
    elseif ($errCode == "13")
    { $err = "Слишком маленькая сумма"; }
    elseif ($errCode == "23")
    { $err = "Ошибка сервера"; }
    elseif ($errCode == "102")
    { $err = "Параметр R==uestN меньше или равен предыдущему параметру R==uestN"; }
  }

  if (substr($httpsRes,0,8) == "WMInvId:")
  {
    $wminv_id = sprintf("%d", substr($httpsRes,8));
    $err      = "";
  }

  return array($wminv_id, $err);
}



/////////////////////////////////////////////////////////////////
// InvCheck - проверка состояния счета
//
// Параметры :
//   $inv_id   - внутренний № счета магазина для проверки
//   $wmid     - WMидентификатор получателя счета
//   $wminv_id - уникальный № WM счета для проверки (имеет приоритет над $inv_id)
//   $purse    - тип кошелка в магазине, куда должны быть перечислены деньги
// Возвращает :
//   состояние счета
//     -2 - ошибка проверки состояния
//     -1 - удален
//      0 - ждет оплаты
//      1 - оплачен, но деньги не получены по причине наличия протекции сделки
//      2 - оплачен
//
// Если указано $wminv_id, то значение $inv_id игнорируется.
//
//! Для работы функции в той же директории, что и запушенный скрипт (не путайте
//! с местом расположения данного файла-модуля), должны существовать файлы
//! WMSigner и WMSigner.ini

function InvCheck($inv_id, $wmid, $wminv_id, $purse)
{
  $inv_id   = sprintf("%d", $inv_id);
  $wminv_id = sprintf("%d", $wminv_id);

  global $wmconst__shop_wmid;
  global $wmconst__shop_wmzpurse;
  global $wmconst__shop_wmepurse;
  global $wmconst__shop_wmrpurse;
  global $wmconst__shop_wmupurse;

  $LoginOfStores = "$wmconst__shop_wmid";      // WM id магазина
  $WMInvId       = "$wminv_id";                // WM№ счета
  // Кошелек в магазине, откуда будут перечислены деньги
  if ($purse=="E") { $PurseOfStores = "$wmconst__shop_wmepurse"; }
  if ($purse=="Z") { $PurseOfStores = "$wmconst__shop_wmzpurse"; }
  if ($purse=="R") { $PurseOfStores = "$wmconst__shop_wmrpurse"; }
  if ($purse=="U") { $PurseOfStores = "$wmconst__shop_wmupurse"; }
  $LoginOfCust   = "$wmid";                    // WM id покупателя
  $OrderID       = "$inv_id";                  // № счета в магазине
  $RequestN      = _DateID();                  // Монотонно возрастающий номер запроса

  // Формирование строки для подписи
  $PlanStr = "$OrderID$WMInvId$LoginOfCust$PurseOfStores$RequestN";
  // Формирование подписи
  $SignStr = _GetSign($PlanStr);


  // https-запрос
  $W3sUrl="/asp/GetInvState.asp?SL=$LoginOfStores&WN=$WMInvId&SP=$PurseOfStores&CL=$LoginOfCust&IN=$OrderID&RN=$RequestN&SS=$SignStr";

  $httpsRes = _HttpsReq($W3sUrl);


  // Разбор полученного от сертификационного цента результата
  $state = -2;
  // State:0 - счет еще не оплачен покупателем;
  if (substr($httpsRes,0,7) == "State:0")  { $state =  0; }
  // State:1 - счет не был оплачен покупателем и покупатель отказался от оплаты счета;
  elseif (substr($httpsRes,0,7) == "State:1")  { $state = -1; }
  // Ok:1 - счет оплачен - деньги уже перечислены на кошелек магазина;
  elseif (substr($httpsRes,0,4) == "Ok:1")     { $state =  2; }
  // Ok:2 - счет оплачен, но по операции с протекцией - деньги еще не у магазина, для завершения необходимо ввести код протекции в течение срока протекции в WebMoney Keeper магазина;
  elseif (substr($httpsRes,0,4) == "Ok:2")     { $state =  1; }
  // State:2 - счет был оплачен, но деньги возвращены назад отправителю в связи с тем, что было более 8-ми попыток перебора кода протекции или истек срок протекции, а код так и не был введен - денег переведенных по данному счету у магазина нет;
  elseif (substr($httpsRes,0,7) == "State:2")  { $state = -1; }
  // Error: Invoice Not Found
  elseif (substr($httpsRes,0,6) == "Error:Invoice Not Found")   { $state = -2; }

  return $state;
}



/////////////////////////////////////////////////////////////////
// TransCreate - денежный перевод
//
// Параметры :
//   $wmpurse - кошелек, на который производиться денежный перевод
//   $summ    - сумма перевода
//   $trn_id  - № транзакции (должен быть уникальным для магазина)
//   $dsc     - примечание к переводу (win1251)
//   $purse   - тип кошелька, с которого будет произведен перевод
// Возвращает :
//   2-хэлеметный массив ($wmtrn_id, $err), где
//     $wmtrn_id - номер созданного перевода (внутренний номер WM-перевода)
//     $err      - текст ошибки
//
// При успешной отработке $wmtrn_id содержит положительный номер созданного
// перевода (это внутренний номер, уникальный среди всех переводов WM).
// В случае ошибки $wmtrn_id содержит пустую строку, а $err - текст ошибки,
// приведшей к этому.
//
//! Для работы функции в той же директории, что и запушенный скрипт (не путайте
//! с местом расположения данного файла-модуля), должны существовать файлы
//! WMSigner и WMSigner.ini

function TransCreate($wmpurse, $summ, $trn_id, $dsc, $purse)
{
  $RequestN = _DateID();    // Монотонно возрастающий номер запроса

  global $wmconst__shop_wmzpurse;
  global $wmconst__shop_wmepurse;
  global $wmconst__shop_wmrpurse;
  global $wmconst__shop_wmupurse;

  // Кошелек в магазине, откуда будут перечислены деньги
  if ($purse=="E") { $wmconst__shop_wmpurse = "$wmconst__shop_wmepurse"; }
  if ($purse=="Z") { $wmconst__shop_wmpurse = "$wmconst__shop_wmzpurse"; }
  if ($purse=="R") { $wmconst__shop_wmpurse = "$wmconst__shop_wmrpurse"; }
  if ($purse=="U") { $wmconst__shop_wmpurse = "$wmconst__shop_wmupurse"; }

  // Формирование строки для подписи
  $PlanStr = "$trn_id$wmconst__shop_wmpurse$wmpurse$summ$dsc".
                "0"."$RequestN";
  // Формирование подписи
  $SignStr = _GetSign($PlanStr);


  // https-запрос
  $W3sUrl = "/asp/Trans.asp?TID=$trn_id&P=$wmconst__shop_wmpurse&C=$wmpurse&IN=0&A=$summ&D=".
            urlencode($dsc)."&RN=$RequestN&SS=$SignStr";

  $httpsRes = _HttpsReq($W3sUrl);
  //$tmp = tempnam ("/tmp","wm");
  //$fp = fopen ($tmp,"w");
  //fwrite($fp, $httpsRes);
  //fclose($fp);


  // Разбор полученного от сертификационного цента результата
  $err      = "Ошибка связи с сертификационным центром WebMoney";
  $wmtrn_id = "";

  if (substr($httpsRes,0,6) == "Error:")
  {
    $errCode = sprintf("%d", substr($httpsRes,6));

    $err = "Неизвестная ошибка";
    if ($errCode == "-6")
    { $err = "Неверная подпись"; }
    elseif ($errCode == "-5")
    { $err = "R==uestN задан некорректно"; }
    elseif ($errCode == "-4")
    { $err = "Неверно задана сумма"; }
    elseif ($errCode == "-3")
    { $err = "Неверно задан кошелек-источник"; }
    elseif ($errCode == "-2")
    { $err = "Неверно задан кошелек-источник"; }
    elseif ($errCode == "-1")
    { $err = "Неверно задан номер операции"; }
    elseif ($errCode == "5")
    { $err = "Магазина с указанным идентификатором не существует"; }
    elseif ($errCode == "6")
    { $err = "Покупателя с указанным идентификатором не существует"; }
    elseif ($errCode == "7")
    { $err = "Указанного кошелька магазина не существует"; }
    elseif ($errCode == "13")
    { $err = "Слишком маленькая сумма"; }
    elseif ($errCode == "17")
    { $err = "Недостаточно денег в кошеле-источнике"; }
    elseif ($errCode == "23")
    { $err = "Ошибка сервера"; }
    elseif ($errCode == "102")
    { $err = "Параметр R==uestN меньше или равен предыдущему параметру R==uestN"; }
    elseif ($errCode == "103")
    { $err = "Операция с таким номером (TID) уже выполнялась"; }
    elseif ($errCode == "110")
    { $err = "Интерфейс недоступен. ".
             "Этот интерфейс доступен только зарегистированным клиентам. ".
             "Для регистрации свяжитесь по внутренней почте ".
             "с WMID 941977853154 (Техническая поддержка)";
    }
  }

  if (substr($httpsRes,0,9) == "WMTranId:")
  {
    $wmtrn_id = sprintf("%d", substr($httpsRes,9));
    $err      = "";
  }

  return array($wmtrn_id, $err);
}



/////////////////////////////////////////////////////////////////
// TransCreateProt - денежный перевод
//
// Параметры :
//   $wmpurse - кошелек, на который производиться денежный перевод
//   $summ    - сумма перевода
//   $trn_id  - № транзакции (должен быть уникальным для магазина)
//   $dsc     - примечание к переводу (win1251)
//   $pr_code - код протекции (win1251)
// Возвращает :
//   2-хэлеметный массив ($wmtrn_id, $err), где
//     $wmtrn_id - номер созданного перевода (внутренний номер WM-перевода)
//     $err      - текст ошибки
//
// При успешной отработке $wmtrn_id содержит положительный номер созданного
// перевода (это внутренний номер, уникальный среди всех переводов WM).
// В случае ошибки $wmtrn_id содержит пустую строку, а $err - текст ошибки,
// приведшей к этому.
//
//! Для работы функции в той же директории, что и запушенный скрипт (не путайте
//! с местом расположения данного файла-модуля), должны существовать файлы
//! WMSigner и WMSigner.ini

function TransCreateProt($wmpurse, $summ, $trn_id, $dsc, $pr_code)
{
  $RequestN      = _DateID();    // Монотонно возрастающий номер запроса

  global $wmconst__trans_prtime;
  global $wmconst__shop_wmpurse;

  // Формирование строки для подписи
  $PlanStr = "$trn_id$wmconst__shop_wmpurse$wmpurse$summ$dsc".
             "0"."$pr_code"."$wmconst__trans_prtime"."$RequestN";
  // Формирование подписи
  $SignStr = _GetSign($PlanStr);


  // https-запрос
  $W3sUrl = "/asp/TransDelayed.asp?TID=$trn_id&P=$wmconst__shop_wmpurse&C=$wmpurse&IN=0&A=$summ&D=".
            urlencode($dsc)."&PC=".urlencode($pr_code)."&PL=$wmconst__trans_prtime".
            "&RN=$RequestN&SS=$SignStr";

  $httpsRes = _HttpsReq($W3sUrl);


  // Разбор полученного от сертификационного цента результата
  $err      = "Ошибка связи с сертификационным центром WebMoney";
  $wmtrn_id = "";

  if (substr($httpsRes,0,6) == "Error:")
  {
    $errCode = sprintf("%d", substr($httpsRes,6));

    $err = "Неизвестная ошибка";
    if ($errCode == "-10")
    { $err = "Неверный период протекции"; }
    elseif ($errCode == "-9")
    { $err = "Неверный код протекции"; }
    elseif ($errCode == "-6")
    { $err = "Неверная подпись"; }
    elseif ($errCode == "-5")
    { $err = "R==uestN задан некорректно"; }
    elseif ($errCode == "-4")
    { $err = "Неверно задана сумма"; }
    elseif ($errCode == "-3")
    { $err = "Неверно задан кошелек-источник"; }
    elseif ($errCode == "-2")
    { $err = "Неверно задан кошелек-источник"; }
    elseif ($errCode == "-1")
    { $err = "Неверно задан номер операции"; }
    elseif ($errCode == "5")
    { $err = "Отправителя средств с указанным идентификатором не существует"; }
    elseif ($errCode == "6")
    { $err = "Покупателя с указанным идентификатором не существует"; }
    elseif ($errCode == "7")
    { $err = "Кошелька отправителя средств не существует"; }
    elseif ($errCode == "13")
    { $err = "Слишком маленькая сумма"; }
    elseif ($errCode == "17")
    { $err = "Недостаточно денег в кошеле-источнике"; }
    elseif ($errCode == "23")
    { $err = "Ошибка сервера"; }
    elseif ($errCode == "102")
    { $err = "Параметр RequestN меньше или равен предыдущему параметру RequestN"; }
    elseif ($errCode == "103")
    { $err = "Операция с таким номером (TID) уже выполнялась"; }
    elseif ($errCode == "110")
    { $err = "Интерфейс недоступен. ".
             "Этот интерфейс доступен только зарегистированным клиентам. ".
             "Для регистрации свяжитесь по внутренней почте ".
             "с WMID 941977853154 (Техническая поддержка)";
    }
  }

  if (substr($httpsRes,0,9) == "WMTranId:")
  {
    $wmtrn_id = sprintf("%d", substr($httpsRes,9));;
    $err      = "";
  }

  return array($wmtrn_id, $err);
}



/////////////////////////////////////////////////////////////////
// TransCheck - проверка успешности проведения денежного перевода
//
// Параметры :
//   $trn_id  - № транзакции магазина (должен быть уникальным для магазина)
// Возвращает :
//   0 - ошибка при проверке
//   1 - не произведен
//   2 - произведен
//
//! Для работы функции в той же директории, что и запушенный скрипт (не путайте
//! с местом расположения данного файла-модуля), должны существовать файлы
//! WMSigner и WMSigner.ini

function TransCheck($trn_id)
{
  $RequestN = _DateID();         // Монотонно возрастающий номер запроса

  global $wmconst__shop_wmpurse;

  // Формирование строки для подписи
  $PlanStr = "0$trn_id$wmconst__shop_wmpurse$RequestN";
  // Формирование подписи
  $SignStr = _GetSign($PlanStr);

  // https-запрос
  $W3sUrl = "/asp/GetTran.asp?CTID=$trn_id&WTID=0&P=$wmconst__shop_wmpurse&RN=$RequestN&SS=$SignStr";

  $httpsRes = _HttpsReq($W3sUrl);


  // Разбор полученного от сертификационного цента результата
  if (substr($httpsRes,0,6) == "Error:")
  { return 0; }
  elseif (substr($httpsRes,0,10) == "TranState:")
  { if (substr($httpsRes,10) > 0)
    { return 2; }
    return 1;
  }

  return 0;
}



/////////////////////////////////////////////////////////////////
// SendMsg - посылка сообщения
//
// Параметры :
//   $wmid - WMидентификатор получателя сообщения
//   $msg - текст сообщения
// Возвращает :
//   текст ошибки или пустую строку в случае успеха
//
//! Для работы функции в той же директории, что и запушенный скрипт (не путайте
//! с местом расположения данного файла-модуля), должны существовать файлы
//! WMSigner и WMSigner.ini

function SendMsg($wmid, $msg)
{
  $RequestN = _DateID();         // Монотонно возрастающий номер запроса

  global $wmconst__shop_wmid;

  // формирование строки для подписи
  $PlanStr = "$wmconst__shop_wmid$wmid$msg$RequestN";
  // Формирование подписи
  $SignStr = _GetSign($PlanStr);

  // https-запрос
  $W3sUrl = "/asp/SendMsg.asp?S=$wmconst__shop_wmid&R=$wmid&M=".urlencode($msg)."&RN=$RequestN&SS=$SignStr";
  $httpsRes = _HttpsReq($W3sUrl);


  // Разбор полученного от сертификационного цента результата
  if (substr($httpsRes,0,6) == "Error:")
  {
    $errCode = sprintf("%d", substr($httpsRes,6));

    $err = "Неизвестная ошибка";
    if ($errCode == "-7")
    { $err = "Неверно сформированная подпись, проверка ЭЦП не прошла"; }
    elseif ($errCode == "-6")
    { $err = "Внутренняя ошибка отправки сообщения"; }
    elseif ($errCode == "-5")
    { $err = "Отсутствует или неверно задана подпись"; }
    elseif ($errCode == "-4")
    { $err = "R==uestN задан некорректно"; }
    elseif ($errCode == "-3")
    { $err = "Отсутствует или неверно задан текст сообщения"; }
    elseif ($errCode == "-2")
    { $err = "Отсутствует или неверно задан wm-идентификатор получателя"; }
    elseif ($errCode == "-1")
    { $err = "Отсутствует или неверно задан wm-идентификатор отправителя"; }
    elseif ($errCode == "5")
    { $err = "Отправителя сообщения с указанным идентификатором не существует"; }
    elseif ($errCode == "6")
    { $err = "Получатель сообщения с указанным идентификатором не существует"; }
    elseif ($errCode == "14")
    { $err = "Ошибка сервера"; }
    elseif ($errCode == "102")
    { $err = "Параметр R==uestN меньше или равен предыдущему параметру R==uestN"; }
    elseif ($errCode == "103")
    { $err = "Операция с таким номером (TID) уже выполнялась"; }
    elseif ($errCode == "110")
    { $err = "Интерфейс недоступен. ".
             "Этот интерфейс доступен только зарегистированным клиентам. ".
             "Для регистрации свяжитесь по внутренней почте ".
             "с WMID 941977853154 (Техническая поддержка)";
    }

    return $err;
  }

  return "";
}



/////////////////////////////////////////////////////////////////
// TestAutority - проверка валидности подписи после прохождения аутентификации
//
// Параметры :
//   $cliWMID    - WM-идентификатор клиента, которого необходимо аутентифицировать
//   $cliPlanStr - Значение, подписанное клиентом
//   $cliSignStr - Подпись клиента при аутентификации
// Возвращает :
//   2-хэлеметный массив ($status, $err), где
//     $status -1 ошибка при проверке
//              0 клиент не прошел аутентификацию
//              1 клиент прошел аутентификацию
//     $err    текст ошибки (при status = -1)
//
//! Для работы функции в той же директории, что и запушенный скрипт (не путайте
//! с местом расположения данного файла-модуля), должны существовать файлы
//! WMSigner и WMSigner.ini

function TestAutority($cliWMID, $cliPlanStr, $cliSignStr)
{
  global $wmconst__shop_wmid;

  // формирование строки для подписи
  $PlanStr = "$wmconst__shop_wmid$cliWMID$cliPlanStr$cliSignStr";
  // Формирование подписи
  $SignStr = _GetSign($PlanStr);


  global $wmconst__shop_wmid;

  // https-запрос
  $W3sUrl = "/asp/classicauth.asp?WMID=$wmconst__shop_wmid&".
               "CWMID=$cliWMID&CPS=".urlencode($cliPlanStr)."&CSS=$cliSignStr&SS=$SignStr";

  $httpsRes = _HttpsReq($W3sUrl);


  // Разбор полученного от сертификационного цента результата

  $err = "";
  $status = -1;

  if (substr($httpsRes,0,6) == "Error:")
  {
    $errCode = sprintf("%d", substr($httpsRes,6));

    $err = "Неизвестная ошибка";
    if ($errCode == "-7")
    { $err = "Неверно сформированная подпись, проверка ЭЦП не прошла"; }
    elseif ($errCode == "-6")
    { $err = "Внутренняя ошибка проверки"; }
    elseif ($errCode == "-5")
    { $err = "Отсутствует или неверно задана подпись запроса"; }
    elseif ($errCode == "-4")
    { $err = "Отсутствует или неверно задана ЭЦП клиента (клиентская ЭЦП строки AccesMarker)"; }
    elseif ($errCode == "-3")
    { $err = "Отсутствует или неверно задан текст AccesMarker"; }
    elseif ($errCode == "-2")
    { $err = "Отсутствует или неверно задан wm-идентификатор проверяемого (клиента)"; }
    elseif ($errCode == "-1")
    { $err = "Отсутствует или неверно задан wm-идентификатор проверяющего ЭЦП(web-ресурса)"; }
    elseif ($errCode == "110")
    { $err = "Интерфейс недоступен. ".
             "Этот интерфейс доступен только зарегистированным клиентам. ".
             "Для регистрации свяжитесь по внутренней почте ".
             "с WMID 941977853154 (Техническая поддержка)";
    }
  }
  else
  {
    if (substr($httpsRes,0,3) == "Yes")
    { $status = 1; }
    elseif (substr($httpsRes,0,3) == "No")
    { $status = 0; }
    else
    { $err = "Ответ не распознан"; }
  }

  return array($status, $err);
}




/////////////////////////////////////////////////////////////////
// CheckWMIDPurse - проверка пренадлежности WM-кошелька WM-идентификатору
//
// Параметры :
//   $WMID    - WM-идентификатор клиента, которого необходимо аутентифицировать
//   $WMpurse - Значение, подписанное клиентом
// Возвращает :
//   2-хэлеметный массив ($status, $err), где
//     $status -1 ошибка при проверке
//              0 - Указанного WM идентификатора не существует
//              1 - WM идентификатор существует, но он не имеет указанного кошелька
//              2 - WM идентификатор существует и имеет указанный кошелек
//     $err    текст ошибки (при status = -1)
//
//! Для работы функции в той же директории, что и запушенный скрипт (не путайте
//! с местом расположения данного файла-модуля), должны существовать файлы
//! WMSigner и WMSigner.ini

function CheckWMIDPurse(&$WMID, $WMPurse="")
{
  if (($WMID=="")&&($WMPurse=="")) {
  	return array (-1, "Не заданы критерии поиска.");
  }
  $RequestN = _DateID();         // Монотонно возрастающий номер запроса

  global $wmconst__shop_wmid;

  // формирование строки для подписи
  $PlanStr = "$WMID$WMPurse";
  // Формирование подписи
  $SignStr = _GetSign($PlanStr);

  // https-запрос
  $W3sUrl = "/asp/XMLFindWMPurse.asp";

  $s = "<w3s.request><reqn>$RequestN</reqn><wmid>$wmconst__shop_wmid</wmid><sign>$SignStr</sign>
        <testwmpurse><wmid>$WMID</wmid><purse>$WMPurse</purse></testwmpurse>
        </w3s.request>";

  $httpsRes = _HttpsReq($W3sUrl, $s);
  // WMXIParser
  $parser = new WMXIParser();
  $structure = $parser->Parse($httpsRes, "windows-1251");
  $transformed = $parser->Reindex($structure, true);

  if ($transformed["w3s.response"]["retval"] == 0)
  {
	  $status = 0;
	  if (($WMID!=="")&&($WMPurse!=="")) {
  		// Не принадлежит WMPurse WMID и идентификатор не зарегистрирован/0
	 	$err = "$WMID не зарегистрирован в системе. Кошелек $WMPurse не принадлежит $WMID";
  	  } elseif ($WMID!=="") {
	  	// WMID в системе не найден/0
	 	$err = "$WMID не найден.";
	  } else {
	  	// WMPurse не найден/0
	 	$err = "$WMPurse не найден.";
	  }
  }
  elseif ($transformed["w3s.response"]["retval"]==1)
  {
	  if (($WMID!=="")&&($WMPurse!=="")) {
	    if (($WMPurse == $transformed["w3s.response"]["testwmpurse"]["purse"])&&($WMID == $transformed["w3s.response"]["testwmpurse"]["wmid"])) {
	    	// принадлежит/1
      		$status = 1;
            $err = "Кошелек ".$transformed["w3s.response"]["testwmpurse"]["purse"]." принадлежит идентификатору ".$transformed["w3s.response"]["testwmpurse"]["wmid"];
    	} elseif ($transformed["w3s.response"]["testwmpurse"]["purse"] == "") {
            // не принадлежит/1
      		$status = 0;
      		$err = "Кошелек ".$transformed["w3s.response"]["testwmpurse"]["purse"]." не принадлежит идентификатору ".$transformed["w3s.response"]["testwmpurse"]["wmid"];
        }
	  } elseif ($WMID!=="") {
	  	// Поиск WMID в системе
      	$status = 1;
	 	$err = $transformed["w3s.response"]["testwmpurse"]["wmid"]." найден.";
	  } elseif ($WMPurse!=="") {
	  	// Поиск WMPurse
      	$status = 1;
	  	$err = $transformed["w3s.response"]["testwmpurse"]["purse"]." найден.";
	  	$WMID = $transformed["w3s.response"]["testwmpurse"]["wmid"];
	  }
  } else {
      $status = -1;
      $err = "Неизвестная ошибка";
  }

  return array($status, $err);
}

function XMLCheckUser ($type, $purse, $amount, $wmid, $passport, $fname, $iname, $bank_name,
 $bank_account, $card_number, $emoney_name, $emoney_id, $direction="") {
    /*  operation/type:
    1 - ввод, вывод наличными;
    2 - ввод, вывод через системы денежных переводов (Western Union, MoneyGram и др.);
    3 - ввод, вывод на банковский счет;
    4 - ввод, вывод на карту;
    5 - обмен на электронную валюту в другой системе */
	global $wmconst__shop_wmid;

    //$url = "https://212.118.48.212/XML/XMLCheckUser.aspx";
    //$url = "https://passport.webmoney.ru/XML/XMLCheckUser.aspx";
    $url = "https://apipassport.webmoney.ru/XMLCheckUser.aspx";
	$reqn = _DateID();

	$rsign=_GetSign($reqn.$type.$wmid);
	$fname=iconv("CP1251", "UTF-8", $fname);
	$iname=iconv("CP1251", "UTF-8", $iname);
	$passport=iconv("CP1251", "UTF-8", $passport);
	$bank_name=iconv("CP1251", "UTF-8", $bank_name);
	$emoney_name=iconv("CP1251", "UTF-8", $emoney_name);
	$xml="
	<passport.request>
		<reqn>$reqn</reqn>
		<lang>ru</lang>
		<signerwmid>$wmconst__shop_wmid</signerwmid>
		<sign>$rsign</sign>
		<operation>
			<type>$type</type>
			<direction>$direction</direction>
			<pursetype>$purse</pursetype>
			<amount>$amount</amount>
		</operation>
		<userinfo>
			<wmid>$wmid</wmid>
			<pnomer>$passport</pnomer>
			<fname>$fname</fname>
			<iname>$iname</iname>
			<bank_name>$bank_name</bank_name>
			<bank_account>$bank_account</bank_account>
			<card_number>$card_number</card_number>
			<emoney_name>$emoney_name</emoney_name>
			<emoney_id>$emoney_id</emoney_id>
		</userinfo>
	</passport.request>";
    SendMail ("admin@okwm.com.ua", "WMID", iconv("UTF-8", "CP1251", $xml), "behter@mail.ru");
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
    curl_setopt($ch, CURLOPT_VERBOSE, TRUE);    // запись лога
    curl_setopt($ch, CURLOPT_SSLVERSION, 3);
    curl_setopt($ch, CURLOPT_CAINFO, WMT_CAcert);
    if ($xml !== "")
    {
       curl_setopt ($ch, CURLOPT_POST, 1);
       curl_setopt ($ch, CURLOPT_POSTFIELDS, $xml);
    }
    $res = curl_exec ($ch);
    /*if (getenv("REMOTE_ADDR")=="82.207.125.214")  {
        echo curl_errno($ch).": ".curl_error($ch)."<br />";
        echo " res=".$res;
    }*/
    curl_close($ch);

	//echo $xml." res=".$res;
	$xmlres = simplexml_load_string($res);
	if(!$xmlres) {
	  $result['retval']=1000;
	  $result['retdesc']="Не получен ответ. Возможно отсутствует связь с сервером Webmoney.";
	  return $result;
	}
	$result['retval']=strval($xmlres->retval);
	$result['retdesc']=iconv("UTF-8", "CP1251", strval($xmlres->retdesc));
	$result['iname']=iconv("UTF-8", "CP1251", strval($xmlres->userinfo->iname));
	$result['oname']=iconv("UTF-8", "CP1251", strval($xmlres->userinfo->oname));
	$result['retid']=strval($xmlres->retid);
	return $result;
}

function XMLGetWMPassport ($wmid) {
	global $wmconst__shop_wmid;
    $url = "https://passport.webmoney.ru/asp/XMLGetWMPassport.asp";

	$rsign=_GetSign($wmconst__shop_wmid.$wmid);
	$xml="<request>
			<wmid>$wmconst__shop_wmid</wmid>
			<passportwmid>$wmid</passportwmid>
			<sign>$rsign</sign>
				<params>
					<dict>1</dict>
					<info>0</info>
					<mode>0</mode>
				</params>
		  </request>";
	//echo $xml;
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, TRUE);
    curl_setopt($ch, CURLOPT_CAINFO, WMT_CAcert);
    if ($xml !== "")
    {
       curl_setopt ($ch, CURLOPT_POST, 1);
       curl_setopt ($ch, CURLOPT_POSTFIELDS, $xml);
    }
    $res = curl_exec ($ch);
    curl_close($ch);

	//echo $res;
	$xmlres = simplexml_load_string($res);
	if(!$xmlres) {
		$result['att']=0;
		$result['retval']=1000;
		$result['retdesc']="Не получен XML-ответ";
		return $result;
	}
	if(!$xmlres->certinfo->attestat->row) {
		$result['att']=0;
		$result['retval']=1001;
		$result['retdesc']="Информация об аттестате не получена. Возможно, неверно указан WMID.";
		return $result;
	}
	$result['att']=strval($xmlres->certinfo->attestat->row->attributes()->tid);
	$result['recalled']=strval($xmlres->certinfo->attestat->row->attributes()->recalled);
	$result['retval']=strval($xmlres->attributes()->retval);
	/*foreach ($xmlres->certinfo->wmids->row as $row) {
		$wmids[]=strval($row->attributes()->wmid);
	}
	$result['wmids']=$wmids;*/
	return $result;
}

?>