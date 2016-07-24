<?php
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");

   // Не сохранять в Temporary Internet Files
   header("Cache-Control: no-store, no-cache, must-revalidate");  // HTTP/1.1
   header("Cache-Control: post-check=0, pre-check=0", false);
   header("Pragma: no-cache");                          // HTTP/1.0
   // Заголовок фрейма robot.php
   echo <<<EOT
<html>

<head>
   <title></title>
   <meta http-equiv="Content-Type" content="html/text; charset=windows-1251">
   <link rel="stylesheet" type="text/css" href="/styles/frame.css">
</head>

<body>
<table width="100%" height="150" cellpadding="0" cellspacing="0">
<tr>
   <td class="frame" style="padding-top: 10px; padding-right: 0px; padding-bottom: 0px; padding-left: 10px;">
EOT;

if (!isset($HTTP_POST_VARS['Cont'])) {
   // Получаем POST-переменные
   $PaymentID = SetUserVariable ("PaymentID", 0, 0);
   $key = SetUserVariable ("key", 0, 0);
   // Проверка подписи
   if (!HashOk("$PaymentID::", $key)) {
      HTMLError("Ошибка передачи данных.");
      exit;
   }
   echo <<<EOT
   <form enctype="multipart/form-data" method="post" name="payment" action="${HTTP_SERVER_VARS['PHP_SELF']}">
      <input type="hidden" name="PaymentID" value="$PaymentID">
      <input type="hidden" name="key" value="$key">
      После оплаты нажмите &quot;Продолжить&quot;<br>
      <input type="submit" name="Cont" value="Продолжить">
   </form>
EOT;
} else {
   // Получаем POST-переменные
   $PaymentID = SetUserVariable ("PaymentID", 0, 0);
   $key = SetUserVariable ("key", 0, 0);
   // Проверка подписи переменных
   if (!HashOk("$PaymentID::", $key)) {
      HTMLError("Ошибка передачи данных.");
      exit;
   }
   // Выбираем заявку из базы для определения входящей валюты
   $sql = "SELECT * FROM Contract INNER JOIN goods ON (goods.GOODS_ID = Contract.GOOD_ID) WHERE Payment_ID = '$PaymentID'";
   OpenSQL ($sql, $row, $res);
   if ($row != 1) {
      // Ошибка выборки заявки
      HTMLError("Ошибка передачи данных.");
      exit;
   }

   // Вставить проверку отметок оплаты и выплаты!
   GetFieldValue ($res, $row_rec, "Payment_Status", $Payment_Status, $IsNull);
   GetFieldValue ($res, $row_rec, "Autorization_Time", $Autorization_Time, $IsNull);
   GetFieldValue ($res, $row_rec, "Delivery_Status", $Delivery_Status, $IsNull);
   GetFieldValue ($res, $row_rec, "GOODS_NAME", $OutMoney, $IsNull);
   GetFieldValue ($res, $row_rec, "GOOD_AMOUNT", $OutSum, $IsNull);
   GetFieldValue ($res, $row_rec, "ORDER_ID_OUT", $Pay_ID, $IsNull);
   GetFieldValue ($res, $row_rec, "Contract_ID", $Contract_ID, $IsNull);
   GetFieldValue ($res, $row_rec, "Purse_To", $Purse_To, $IsNull);
   GetFieldValue ($res, $row_rec, "MAIL", $encode_email, $IsNull);
   $Contract_ID = round($Contract_ID*pi());
   $user_mail = base64_decode($encode_email);

   if ($Delivery_Status == "1") {       // Выплата произведена
       HTMLError("Ваша заявка выполнена. Обмен завершен.");
   } elseif ($Delivery_Status == "-1") {       // Ошибка при выплате
       HTMLError("При выплате произвошла ошибка. Обратитесь в <a href=\"/contacts.asp\" target=\"_BLANK\">поддержку</a>.");
   } elseif (($Payment_Status == "1") && ($Autorization_Time!="0") && ($Delivery_Status == "2") && ($OutMoney == "P24UA")) {       // Оплата получена, платеж на обработке
       // Проверка статуса транзакции
       if ($Pay_ID!="") {           // Вывод на Приват24
           require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/matrix_api.asp");
           $p24 = new matrix();
           $p24->pay_id = $Pay_ID;
           $status = $p24->checkStatus();
           if ($status[0]) {               HTMLError("Ваша заявка выполнена. Обмен завершен.<br />");
               HTMLError("Дата проведения платежа: ".$status[2]."<br />");
               HTMLError("Номер квитанции: ".$Pay_ID);
               $sql = "UPDATE Contract SET
                         Delivery_Status = 1
                       WHERE
                         Payment_ID = '$PaymentID'";
               ExecSQL ($sql, $row);
               // Отнять оплаченную сумму из суммы в Банке
               SetGoodAmount (-$OutSum, $OutMoney);
               $msg = "Здравствуйте!\r\n";
               $msg.= "Ваш перевод проведен на карту приватбанка.\r\n\r\n";
               $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
               $title = "Выплата на карту приватбанка произведена.";
               $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
               $res_mail = SendMail ($from, $title, $msg, $user_mail);
               // сообщить admin, что выплата приват24 произведена.
               $title = $Contract_ID.". ".$title;
               $msg = "Заявка $Contract_ID выполнена.\r\n";
               $msg.= "$OutSum грн отправлено на карту приватбанка.\r\n\r\n";
               $msg.= "Номер квитанции: $Pay_ID\r\n";
               $res_mail = SendMail ($from, $title, $msg);
               include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
           } else if ($status[1] == 120) {
               // Платеж находится в обработке
               HTMLError ($status[2]." Платеж еще в обработке.");
           } elseif ($status[1] == 130) {
               // Платеж отменен
               $err = $p24->getErrMessage();
               $sql = "UPDATE Contract SET
                           Delivery_Status = -1,
                           Error_Pay = '$err'
                         WHERE
                           Payment_ID = '$PaymentID'";
               ExecSQL ($sql, $row);
               HTMLError ("Ошибка при переводе средств на карту приватбанка $Purse_To. ".$err);

               // Отправить сообщение клиенту о завершении обмена
               $msg = "Здравствуйте!\r\n";
               $msg.= "Платеж на Вашу карту был отменен банком.\r\n\r\n";
               $msg.= "Для выяснения причин отказа обратитесь в отделения банка.\r\n\r\n";
               $msg.= "По вопросу возврата платежа обратитесь в поддержку.\r\n";
               $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
               $title = "Платеж $OutSum грн на карту приватбанка ОТМЕНЕН.";
               $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
               $res_mail = SendMail ($from, $title, $msg, $user_mail);
               // Отправить сообщение администратору
               $title = $Contract_ID.". Выплата на приват24 завершилась ошибкой.";
               $msg = "Заявка $Contract_ID не выполнена.\r\n$\r\n\r\n";
               $msg.= "При проведении оплаты на карту приват24 $Purse_To возникла ошибка - $err.\r\n";
               $msg.= "Номер платежа $Pay_ID.\r\n";
               $msg.= "Свяжитесь с поддержкой Матрикс. \r\n";
               $res_mail = SendMail ($from, $title, $msg);
           }
       } else {           HTMLError ("Ваш обмен в обработке. При длительной задержке обратитесь в <a href=\"/contacts.asp\" target=\"_BLANK\">поддержку</a>.");
       }
   } else {
       // заявка найдена в базе
       GetFieldValue ($res, $row_rec, "Payment_Currency", $InMoney , $IsNull);
       if (($InMoney == "WMZ")||($InMoney == "WME")||($InMoney == "WMR")||($InMoney == "WMU")) {
          // Проверка оплаты Webmoney
          require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm_invchk.asp");
       } elseif ($InMoney == "YAD") {
          require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/pc_paychk.asp");
       } else {
          HTMLError("Оплата производится наличными в офисе. Адрес, по которому производится оплата, указан на странице &quot;<a href=\"/contacts.asp\" target=\"_BLANK\">Контакты</a>&quot;");
       }
   }
   echo <<<EOT
   </td>
</tr>
</table>
</body>
</html>
EOT;
}

?>