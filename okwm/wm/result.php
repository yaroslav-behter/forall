<?php
#--------------------------------------------------------------------
# OKWM.com.ua Webmoney Transfer order payment module.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2005.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
# Requires /lib/database.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm.inc");

   //$post = print_r($HTTP_POST_VARS, true);
   //$res = @SendMail ("admin@okwm.com.ua", "ACCESS FROM IP " . getenv('REMOTE_ADDR') . " - " . date("Y-m-d H:i:s"), "Выполняется скрипт /wm/result.php.\r\nЗапрос с IP=".getenv('REMOTE_ADDR')."\r\n$post", "behter@mail.ru");


   $LMI_PREREQUEST            = $HTTP_POST_VARS['LMI_PREREQUEST'];
   $LMI_PAYEE_PURSE           = $HTTP_POST_VARS['LMI_PAYEE_PURSE'];
   $LMI_PAYMENT_AMOUNT        = $HTTP_POST_VARS['LMI_PAYMENT_AMOUNT'];
   $LMI_PAYMENT_NO            = $HTTP_POST_VARS['LMI_PAYMENT_NO'];
   $LMI_MODE                  = $HTTP_POST_VARS['LMI_MODE'];
   $LMI_PAYER_PURSE           = $HTTP_POST_VARS['LMI_PAYER_PURSE'];
   $LMI_PAYER_WM              = $HTTP_POST_VARS['LMI_PAYER_WM'];
   $LMI_HASH                  = $HTTP_POST_VARS['LMI_HASH'];
   $PAYMENTID                 = $HTTP_POST_VARS['PAYMENTID'];
   $KEY                       = $HTTP_POST_VARS['KEY'];

   if (!HashOk("$PAYMENTID::", $KEY)) {
      // Подпись в платеже ошибочная
      $msg = "Переданы ошибочные данные! Подпись ($KEY) неправильная.\n\r";
      $msg.= "/wm/result.php\r\n";
      $msg.= "PAYMENTID=".$PAYMENTID."\r\n";
      $msg.= "KEY=".$KEY."\r\n";
      $title = "Подтверждение платеж через Webmoney Merchant.";
      $from = SERVER_ADMIN_MAIL;
      $res_mail = SendMail ($from, $title, $msg);
      exit;
   }

   $wmz_account = $wmconst__shop_wmzpurse;
   $wme_account = $wmconst__shop_wmepurse;
   $wmr_account = $wmconst__shop_wmrpurse;
   $wmu_account = $wmconst__shop_wmupurse;
   $http = DOMAIN_HTTP;

   if ((!empty($LMI_PREREQUEST)) AND ($LMI_PREREQUEST == "1")) {
      do {
            // Предварительный запрос платежа непосредственно перед его выполнением
            if (($LMI_PAYEE_PURSE != $wmz_account)&&
                ($LMI_PAYEE_PURSE != $wme_account)&&
                ($LMI_PAYEE_PURSE != $wmr_account)&&
                ($LMI_PAYEE_PURSE != $wmu_account)) {
                  // Счет в квитанции Webmoney не принадлежит магазину!
                  $msg_err = "Счет получателя платежа не принадлежит $http!";
                  break;
            }
            if ($LMI_MODE != "0") {
                  // Платеж тестовый. Перевод не выполнится.
                  $msg_err = "Платеж выполняется в тестовом режиме! Перевод не получен.";
                  break;
            }
            $sql = "SELECT * FROM Contract
                    WHERE Payment_ID = '$PAYMENTID' AND Payment_Status='0'";
            OpenSQL ($sql, $row, $res);
            if ($row != 1) {
                  // Заявка отсутствует или их несколько
                  $msg_err = "Заявка не найден или оплата уже отмечена! SQL - $sql";
                  break;
            } else {
                  // заявка есть в базе
                  $row_rec = NULL;
                  GetFieldValue ($res, $row_rec, "Payment_Sum", $InSum, $IsNull);
                  GetFieldValue ($res, $row_rec, "Payment_Currency", $Payment_Currency, $IsNull);
                  GetFieldValue ($res, $row_rec, "Contract_ID", $Contract_ID, $IsNull);
                  GetFieldValue ($res, $row_rec, "wmid", $WMid, $IsNull);
                  if ($LMI_PAYER_WM!=$WMid) {                      // С помощью интерфейса X11 обменный пункт определяет другие WMID                      // Заявку оплачивает не владелец кошелька получателя
                      $msg_err = "Заявка оплачивается через Webmoney Merchant. Оплата с WMID $LMI_PAYER_WM, в заявке получатель WMID $WMid.";
                      break;
                  }
            }
            if (round($Contract_ID*pi()) != $LMI_PAYMENT_NO) {
                  // Номер заявки изменен. Подставляется оплата
                  $msg_err = "Номер заявки не совпадает с номером в присланой мерчантом оплате! ".round($Contract_ID*pi())." != $LMI_PAYMENT_NO";
                  break;
            }
            if ($LMI_PAYMENT_AMOUNT != $InSum) {
                  // Сумма в платеже изменена
                  $msg_err = "Сумма платежа изменена!";
                  break;
            }
            if (substr($LMI_PAYEE_PURSE, 0, 1) != substr($Payment_Currency, 2, 1)) {
                  // Валюта платежа изменена
                  $msg_err = "Валюта платежа изменена! Кошелек=$LMI_PAYEE_PURSE, валюта в заявке=$Payment_Currency";
                  break;
            }
      } while (0);
      if (empty($msg_err)) {
            // Ошибок нет. Платеж принимается
            echo "YES";
            //$res_mail_prerequest = @SendMail ("admin@okwm.com.ua", "YES отправлено - " . date("Y-m-d H:i:s"), "Скрипт /wm/result.php.\r\n" , "behter@mail.ru");
            exit;
      } else {
            // подготовка сообщения для администратора
            $msg = "Оплата через Webmoney Merchant не получена!\r\n$msg_err\r\n";
            $msg.= "Данные, присланые сервером Webmoney Merchant в предварительном запросе:\r\n";
            $msg.= "LMI_PAYEE_PURSE = $LMI_PAYEE_PURSE (должен быть счет $wmz_account, $wme_account или $wmr_account)\r\n";
            $msg.= "LMI_PAYMENT_NO = $LMI_PAYMENT_NO \r\n";
            $msg.= "LMI_PAYMENT_AMOUNT = $LMI_PAYMENT_AMOUNT (должно быть $InSum)\r\n";
            $msg.= "LMI_MODE = $LMI_MODE (0: Платеж реальный; 1: Платеж тестовый) \r\n";
            $msg.= "LMI_PAYER_WM = $LMI_PAYER_WM - WMid покупателя\r\n";
            $msg.= "Номер заявки $LMI_PAYMENT_NO \r\n";
            $title = "Предварительный запрос платежа через Webmoney Merchant. ".$msg_err;
            $from = SERVER_ADMIN_MAIL;
            $res_mail = SendMail ($from, $title, $msg);
            if (!empty ($res_mail))
               logger ($res_mail, "Предварительный запрос платежа не прошел ($LMI_PAYMENT_NO), почта не отправляется.");
            echo "Error!";
            exit;
      }
   }

   $LMI_SYS_INVS_NO           = $HTTP_POST_VARS['LMI_SYS_INVS_NO'];
   $LMI_SYS_TRANS_NO          = $HTTP_POST_VARS['LMI_SYS_TRANS_NO'];
   $LMI_SYS_TRANS_DATE        = $HTTP_POST_VARS['LMI_SYS_TRANS_DATE'];

   // Проверка идентификации и аутентификации клиента
   $TesterWMID = $wmconst__shop_wmid;    // WMid OKWM.com.ua (lib/wmconst.inc)
   $ClientWMID = "967909998006";         // идентификатор кипера Web Merchant Interface
   $APassphraseHash = WM_APASSPHR;       // Secret_Key (lib/config.asp)
   $AccessMarker = "$LMI_PAYEE_PURSE$LMI_PAYMENT_AMOUNT$LMI_PAYMENT_NO$LMI_MODE$LMI_SYS_INVS_NO$LMI_SYS_TRANS_NO$LMI_SYS_TRANS_DATE$APassphraseHash$LMI_PAYER_PURSE$LMI_PAYER_WM";
   $ClientSignStr = $LMI_HASH;           // Полученная подпись

   // Вызов сервисной функции модуля wm
   list($status, $err) = TestAutority($ClientWMID, $AccessMarker, $ClientSignStr);

   if ($status ==  1) {
      // Подпись валидна после прохождения аутентификации
      $sql = "SELECT * FROM Contract
              WHERE Payment_ID = '$PAYMENTID' AND Payment_Status='0'";
      OpenSQL ($sql, $row, $res);
      if ($row != 1) {
         // Заявка не найдена в базе или их более 1-й
         // подготовка сообщения администратору
         $msg = "Пришла оплата через Webmoney Merchant с кошелька $LMI_PAYER_PURSE в размере $LMI_PAYMENT_AMOUNT!\r\n";
         $msg.= "Данные, присланые платежной системой Webmoney:\r\n";
         $msg.= "WMid покупателя = $LMI_PAYER_WM \r\n";
         $msg.= "Кошелек покупателя = $LMI_PAYER_PURSE \r\n";
         $msg.= "LMI_PAYMENT_NO = $LMI_PAYMENT_NO (номер заявки)\r\n";
         $msg.= "LMI_PAYMENT_AMOUNT = $LMI_PAYMENT_AMOUNT \r\n";
         $msg.= "LMI_MODE = $LMI_MODE (0-реальный, 1-тестовый) \r\n";
         $msg.= "LMI_PAYEE_PURSE = $LMI_PAYEE_PURSE (получатель) \r\n";
         $msg.= "LMI_SYS_TRANS_NO = $LMI_SYS_TRANS_NO (номер платежа в сист Webmoney) \r\n";
         $msg.= "LMI_HASH = $LMI_HASH (подпись) \r\n";
         $msg.= "LMI_SYS_TRANS_DATE = $LMI_SYS_TRANS_DATE \r\n";
         $msg.= "LMI_SECRET_KEY = $LMI_SECRET_KEY (должен быть пустой) \r\n";
         $msg.= "Подпись запроса = $KEY \r\n";
         if ($row == 0) {
            $title = "Прошла оплата через Webmoney Merchant! Заявки в базе нет.";
            $from = SERVER_ADMIN_MAIL;
            $res_mail = SendMail ($from, $title, $msg);
            if (!empty ($res_mail))
               logger ($res_mail, "Пришла оплата через Webmoney Merchant $LMI_SYS_TRANS_NO (заявка $LMI_PAYMENT_NO), заявок в базе нет, почта не отправляется.");
         } else {
            $title = "Пришла оплата через Webmoney Merchant! Количество таких заявок в базе $row.";
            $from = SERVER_ADMIN_MAIL;
            $res_mail = SendMail ($from, $title, $msg);
            if (!empty ($res_mail))
               logger ($res_mail, "Пришла оплата через Webmoney Merchant $LMI_SYS_TRANS_NO (заявка $LMI_PAYMENT_NO), заявок в базе больше 1-го, почта не отправляется.");
         }
      } else {
         // Заявка найдена в базе
         $row_rec = NULL;
         GetFieldValue ($res, $row_rec, "Contract_ID",      $Contract_ID, $IsNull);
         GetFieldValue ($res, $row_rec, "Contract_Terms",   $Contract_Terms, $IsNull);
         GetFieldValue ($res, $row_rec, "Payment_Sum",      $Payment_Sum, $IsNull);
         GetFieldValue ($res, $row_rec, "Payment_Currency", $Payment_Currency, $IsNull);
         GetFieldValue ($res, $row_rec, "Payment_Status",   $Payment_Status, $IsNull);
         GetFieldValue ($res, $row_rec, "MAIL",             $db_mail, $IsNull);
         $user_mail = base64_decode ($db_mail);
         $Contract_ID_pi = round($Contract_ID*pi());
         switch ($Payment_Currency) {
         case "WMZ":
            $purse = $wmconst__shop_wmzpurse;
            break;
         case "WME":
            $purse = $wmconst__shop_wmepurse;
            break;
         case "WMR":
            $purse = $wmconst__shop_wmrpurse;
            break;
         case "WMU":
            $purse = $wmconst__shop_wmupurse;
            break;
         }
         // Проверка суммы, валюты (WMZ, WMR, WME, WMU), кошелек получателя и режим оплаты (0-реал, 1-тест)
         if (($LMI_PAYMENT_AMOUNT == $Payment_Sum)&&                              // Сумма
             (substr($LMI_PAYEE_PURSE,0,1)==substr($Payment_Currency,2,1))&&      // Тип кошелька
             ($LMI_PAYEE_PURSE == $purse)&&                                       // Кошелек продавца
             ($LMI_MODE == 0)&&                                                   // Режим платежа
             ($Payment_Status == "0")&&                                           // Предыдущая оплата
             ($Contract_ID_pi == $LMI_PAYMENT_NO))                                // Номер оплаченой заявки не изменен
         {
             // Оплата принята верно. Делаем отметку об оплате.
             $Autorization_Time = str_replace(":","", str_replace(" ","", $LMI_SYS_TRANS_DATE));
             $Contract_Terms = "from $LMI_PAYER_PURSE\r\n".$Contract_Terms;
             $ORDER_ID = "$LMI_SYS_TRANS_NO";
             $sql = "UPDATE Contract SET
                        Contract_Terms = '$Contract_Terms',
                        Autorization_Time = '$Autorization_Time',
                        wmid = '$LMI_PAYER_WM',
                        ORDER_ID = '$ORDER_ID',
                        Payment_Status = 1,
                        Payment_Account = '$LMI_PAYER_PURSE'
                     WHERE
                        Contract_ID = $Contract_ID AND Payment_ID = '$PAYMENTID'";

             ExecSQL ($sql, $row);
             if (!$row) {
                // сообщить админу, что оплата прошла, данные НЕ сохранены в базе.
                $err = mysql_error ();
                $msg = "Заявка $LMI_PAYMENT_NO оплачена, НО оплата не занесена в базу!!!\r\n";
                $msg.= "SQL=$sql \r\n";
                $msg.= "Ошибка: $err\r\n";
                $msg.= "Данные, присланые Webmoney Merchant: \r\n";
                $msg.= "Сумма оплаты $LMI_PAYMENT_AMOUNT.\r\n";
                $msg.= "Кошелек получателя $LMI_PAYER_PURSE\r\n";
                $msg.= "Квитанция об оплате $LMI_SYS_TRANS_NO.\r\n";
                $msg.= "Дата оплаты $Autorization_Time ($LMI_SYS_TRANS_DATE)\r\n";
                $title = "$LMI_PAYMENT_NO. Оплата Webmoney Merchant не занесена в базу.";
                $from  = SERVER_ADMIN_MAIL;
                $res_mail = @SendMail ($from, $title, $msg);
                if (!empty ($res_mail)) {
                        // информация о платеже не записана в базу!
                        $err = mysql_errno ();
                        logger ('FATAL', "Заявка $LMI_PAYMENT_NO, оплата $LMI_PAYMENT_AMOUNT $Payment_Currency не отмечена, почта не отправляется".$err, __FILE__, __LINE__);
                }
             } else {
                // сообщить админу, что оплата прошла, данные сохранены.
                $msg = "Заявка $LMI_PAYMENT_NO оплачена.\r\n";
                $msg.= "Квитанция об оплате $LMI_SYS_TRANS_NO.\r\n";
                $msg.= "Дата оплаты $LMI_SYS_TRANS_DATE\r\n";
                $title = "Заявка $LMI_PAYMENT_NO. Принято $LMI_PAYMENT_AMOUNT $Payment_Currency";
                $from  = "OKWM.com.ua<".SERVER_ADMIN_MAIL.">";
                $res_mail = @SendMail ($from, $title, $msg);
                if (!empty ($res_mail)&&!$res_mail)
                   logger ($res_mail, "Zayavka $LMI_PAYMENT_NO. $LMI_PAYMENT_AMOUNT $Payment_Currency received. Mail not sending.");
                // сообщить плательщику, что оплата принята.
                $msg = "Здравствуйте!\r\n";
                $msg.= "Получено $LMI_PAYMENT_AMOUNT $Payment_Currency.\r\n";
                $msg.= "Квитанция об оплате $LMI_SYS_TRANS_NO.\r\n";
                $msg.= "Дата оплаты $LMI_SYS_TRANS_DATE\r\n\r\n";
                $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистрация $http\r\n";
                $title = "Оплата $Payment_Sum $Payment_Currency принята.";
                $from  = SERVER_ADMIN_MAIL;
                $res_mail = @SendMail ($from, $title, $msg, $user_mail);

                // Добавить поступившую сумму WM к сумме в Банке
                SetGoodAmount ($Payment_Sum, $Payment_Currency);
             }
         } else {
             // Данные в квитанции об оплате не совпадают с данными в заявке
             $msg = "Заявка $LMI_PAYMENT_NO. Ошибка данных платежа.\r\n";
             $msg.= "Номер заявки не совпадает с номером в присланой мерчантом оплате! $Contract_ID_pi != $LMI_PAYMENT_NO";
             $msg.= "Сумма $LMI_PAYMENT_AMOUNT == $Payment_Sum\r\n";
             $msg.= "Тип кошелька ".substr($LMI_PAYEE_PURSE,0,1)."==".substr($Payment_Currency,2,1)."\r\n";
             $msg.= "Кошелек продавца $LMI_PAYEE_PURSE == $purse\r\n";
             $msg.= "Режим платежа $LMI_MODE (0-реал, 1-тест)\r\n";
             $msg.= "Номер заявки $LMI_PAYMENT_NO == $Contract_ID)\r\n";
             $msg.= "Статус оплаты $Payment_Status (0-неоплачено, 1-уже оплачено)\r\n";
             $title = "Оплата через Webmoney Merchant произведена не правильно!";
             $from  = SERVER_ADMIN_MAIL;
             $res_mail = SendMail ($from, $title, $msg);
             if (!empty ($res_mail))
                logger ($res_mail, "Данные оплаты через Webmoney Merchant не совпадают с заявкой $LMI_PAYMENT_NO, почта не отправляется.");
         }
      }
   } else {
      // Подпись Webmoney Merchant не валидна
      $msg = "ПОДПИСЬ WEBMONEY MERCHANT В КВИТАНЦИИ НЕПРАВИЛЬНАЯ!\r\n";
      $msg.= "Заявка $LMI_PAYMENT_NO.\r\n";
      $msg.= "Ошибка: ";
      if ($status ==  -1)
      { $msg.= "$err \r\n\r\n"; }
      elseif ($status ==  0)
      { $msg.= "Аутентификация ответа от Webmoney Merchant не произведена. \r\n\r\n"; }
      else
      { $msg.= "Внутренняя ошибка скрипта проверки ответа от Webmoney Merchant. \r\n\r\n"; }

      $title = "Оплата через Webmoney Merchant произведена не правильно!";
      $from  = SERVER_ADMIN_MAIL;
      $res_mail = SendMail ($from, $title, $msg);
      if (!empty ($res_mail))
         logger ($res_mail, "Подтверждение платежа через Webmoney Merchant. Подпись в квитанции не правильная, почта не отправляется.");
   }
   //$res = @SendMail ("admin@okwm.com.ua", "ACCESS FROM IP ". getenv('REMOTE_ADDR') ." - ". date("Y-m-d H:i:s"), "END /wm/result.php", "behter@mail.ru");
?>