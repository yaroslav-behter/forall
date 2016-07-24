<?php
#<script language="PHP">
# Ukash Voucher Redemption
# www.okwm.com.ua Behter Y. 2010
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/uk.inc");

        $echo_flag = true;
        // функция вывода текста сообщения в слой "mes"
        function MessageToDiv ($str) {
         global $echo_flag;
         if ($echo_flag) {
             echo <<<EOT
             <script language="JavaScript">
              mes_obj = document.getElementById? document.getElementById("mes") : document.all.mes;
              mes_obj.innerHTML = "$str";
             </script >
EOT;
             flush();
         }
        }

   // выводим слой для вспомогательных сообщений
   echo <<<EOT
        <div id="mes" style="width:500;height:800;color:black;padding-top:20;">Списание ваучера Ukash.</div>
EOT;
   flush();
   // проверка ваучера Ukash
   $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID' AND Payment_Currency='UKSH' AND
           Autorization_Time='0' AND Payment_Status=0 AND Delivery_Status=0 AND Error_Pay=''";
   OpenSQL ($sql, $row, $res);
   if ($row == 1) {
      // заявка есть в базе
      $row_rec = NULL;
      GetFieldValue ($res, $row_rec, "Contract_ID", $db_Contract_ID, $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Sum", $db_InSum , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Account", $db_Voucher , $IsNull);
      GetFieldValue ($res, $row_rec, "MAIL", $db_mail, $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Sum", $db_InSum , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Currency", $db_InMoney , $IsNull);
      $Contract_ID = round($db_Contract_ID*pi());
      $user_mail = base64_decode ($db_mail);
      list($vNumber, $vValue) = explode(":", $db_Voucher);

      sleep (3);
      do {
	     // Устанавливается флаг произведения проверки оплаты (проверка ваучера Ukash).
	     $sql = "UPDATE Contract SET
	                Payment_Status = 2
	             WHERE
	                (Autorization_Time = '0') AND
	                (Delivery_Status = 0) AND
	                (Payment_ID = '$PaymentID')";
	     ExecSQL ($sql, $row);
	     if ($row!=1) {
	        MessageToDiv ("При списании ваучера Ukash произошла ошибка. Свяжитесь с администратором.");
	        break;
	     } else {	        MessageToDiv ("Проверка ваучера Ukash начата. Ожидайте результат.");
	     }
	     $transID = substr($PaymentID,3,20);
         // Redemption Ukash Voucher
         $resp = Redemption($vNumber, $vValue, "EUR", $db_InSum, $transID);
         if (!$resp) {	        MessageToDiv ("При списании ваучера Ukash произошла ошибка. Свяжитесь с администратором.");
	        break;
         }
         $result = simplexml_load_string(html_entity_decode($resp));
         $result = $result->UKashTransaction;

         if ($result->txCode == 0) {            // Accepted
            // Redemption successful
            $sql = "UPDATE Contract SET
                      Autorization_Time = NOW(),
                      ORDER_ID = '".$result->ukashTransactionId."',
                      Payment_Status = '1'
                    WHERE
                      Payment_ID = '$PaymentID'";
            ExecSQL ($sql, $row);
            if ($row) {
               // Сообщаем клиенту, что оплата плучена
               $message = "Сумма $db_InSum EUR списана успешно!<br>";
               if ((string) $result->changeIssueVoucherNumber !== "") {                   $message = "Номер ваучера: ".$result->changeIssueVoucherNumber."<br />";
                   $message.= "Сумма: ".$result->changeIssueAmount." ".$result->changeIssueVoucherCurr."<br />";
                   $message.= "Действителен до: ".$result->changeIssueExpiryDate."<br />";
               }
               $message.= "Для выполнения обратного перевода нажмите кнопку &quot;Продолжить&quot;.<br />";
               $key = EvalHash("$PaymentID::");
               $GetParam = "?PaymentID=$PaymentID&key=$key";
               echo <<<EOT

               <iframe src="robot.php$GetParam" name="ROBOT" frameborder="NO" width="500" border="0" scrolling="NO" onLoad="window.status='Готово';">Проверка оплаты</iframe>
EOT;
               MessageToDiv ($message);
               // отправляем сообщение админу
               $msg = "Оплата заявки $Contract_ID принята.\r\n";
               $msg.= "$db_InSum Ukash EUR - сумма, списаная с ваучера\r\n";
               $msg.= $result->ukashTransactionId." - Ukash Transaction Id\r\n";
               if ((string) $result->changeIssueVoucherNumber !== "") {
                   $msg.= "Номер ваучера: ".$result->changeIssueVoucherNumber."\r\n";
                   $msg.= "Сумма: ".$result->changeIssueAmount." ".$result->changeIssueVoucherCurr."\r\n";
                   $msg.= "Действителен до: ".$result->changeIssueExpiryDate."\r\n";
               }
               // сообщить админу, что оплата прошла успешно, данные сохранены.
               $m_title = $Contract_ID.". Ваучер Ukash списан.";
               $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
               $res_mail = SendMail ($from, $m_title, $msg);
               if (!$res_mail)
                  logger ($res_mail, "res_mail=$res_mail Оплата заявки $PaymentID ($db_InSum Ukash EUR) получена, почта не отправляется.");
               // сообщить плательщику, что оплата принята.
               $msg = "Здравствуйте!\r\n";
               $msg.= "Ваучер Ukash списан на сумму $db_InSum EUR.\r\n\r\n";
               if ((string) $result->changeIssueVoucherNumber !== "") {
                   $msg.= "Оставшаяся сумма во вновь созданном ваучере.\r\n";
                   $msg.= "Номер ваучера: ".$result->changeIssueVoucherNumber."\r\n";
                   $msg.= "Сумма: ".$result->changeIssueAmount." ".$result->changeIssueVoucherCurr."\r\n";
                   $msg.= "Действителен до: ".$result->changeIssueExpiryDate."\r\n";
               }
               $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
               $title = "Оплата $db_InSum $db_InMoney принята.";
               $res_mail = SendMail ($from, $title, $msg, $user_mail);

               // Добавить поступившую сумму WMZ или WME к сумме в Банке
               //SetGoodAmount ($db_InSum, $db_InMoney);
               break;
            } else {
               // заявки нет в базе
               $msg = "Оплата заявки $Contract_ID принята, но не занесена в базу.\n\r";
               $msg.= "Заявка $PaymentID\r\n";
               $msg.= $result->ukashTransactionId." - номер квитанции Ukash\r\n";
               if ((string) $result->changeIssueVoucherNumber !== "") {
                   $msg.= "Оставшаяся сумма во вновь созданном ваучере.\r\n";
                   $msg.= "Номер ваучера: ".$result->changeIssueVoucherNumber."\r\n";
                   $msg.= "Сумма: ".$result->changeIssueAmount." ".$result->changeIssueVoucherCurr."\r\n";
                   $msg.= "Действителен до: ".$result->changeIssueExpiryDate."\r\n";
               }
               // сообщить админу, что оплата прошла, заявки нет в базе.
               $m_title = $Contract_ID.". Оплата $db_InMoney принята, заявки нет в базе!";
               $res_mail = SendMail ($from, $m_title, $msg);
               if (!$res_mail)
                   logger ($res_mail, "res_mail=$res_mail Оплата $db_InMoney получена, почта не отправляется.");
            }
            break;
         } elseif ($result->txCode == 1) {
            // Declined
            // Redemption unsuccessful
            MessageToDiv ("Ваучер не выкуплен. Ответ сервера Ukash: Declined.");
            $sql = "UPDATE Contract SET
                      Payment_Status = '-1',
                      Error_Pay = 'Declined'
                    WHERE
                      Payment_ID = '$PaymentID'";
            ExecSQL ($sql, $row);
            if ($row) {
               // отправляем сообщение админу
               $msg = "Ваучер не списан (Decline).\r\n";
               $msg.= "$db_InSum Ukash EUR - сумма платежа \r\n";
               $msg.= "$vNumber - номер ваучера \r\n";
               $msg.= "$vValue - номинал \r\n";
               // сообщить админу, что оплата не прошла, счет удален.
               $m_title = $Contract_ID.". Ваучер Ukash не списан.";
               $res_mail = SendMail ($from, $m_title, $msg);
               if (!$res_mail)
                  logger ($res_mail, "res_mail=$res_mail Оплата заявки $PaymentID ($db_InSum Ukash) не получена, почта не отправляется.");
            }
            break;
         } elseif ($result->txCode == 99) {
            // Failed
            // An error occurred during the processing of the transaction hence the system
            // could not successfully complete the redemption of the voucher.
            MessageToDiv ("Ошибка произошла во время обработки ваучера.<br />Система не смогла успешно закончить списание.<br />".$result->errDescription);
            $sql = "UPDATE Contract SET
                      Payment_Status = '-1',
                      Error_Pay = '".$result->errDescription."'
                    WHERE
                      Payment_ID = '$PaymentID'";
            ExecSQL ($sql, $row);
            if ($row) {
               // отправляем сообщение админу
               $msg = "Ошибка при списании ваучера.\r\n";
               $msg.= "errCode: ".$result->errDescription.", errDescription:".$result->errDescription."\r\n";
               $msg.= "$db_InSum Ukash EUR - сумма платежа \r\n";
               $msg.= "$vNumber - номер ваучера \r\n";
               $msg.= "$vValue - номинал \r\n";
               // сообщить админу, что ваучер не принят
               $m_title = $Contract_ID.". Ваучер Ukash не списан.";
               $res_mail = SendMail ($from, $m_title, $msg);
               if (!$res_mail)
                  logger ($res_mail, "res_mail=$res_mail Оплата заявки $PaymentID ($db_InSum Ukash EUR) не получена, почта не отправляется.");
               // Сообщение клиенту об ошибке
               $msg = "Здравствуйте!\r\n";
               $msg.= "При списании ваучера Ukash произошла ошибка.\r\n";
               $msg.= "Сервер Ukash вернул описание ошибки:\r\n";
               $msg.= "errCode - ".$result->errDescription.", errDescription - ".$result->errDescription."\r\n";
               $msg.= "$db_InSum Ukash EUR - сумма платежа \r\n";
               $msg.= "$vNumber - номер ваучера \r\n";
               $msg.= "$vValue - номинал \r\n";
               $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
               // сообщить админу, что оплата не прошла, счет удален.
               $m_title = $Contract_ID.". Ваучер Ukash не принят.";
               $res_mail = SendMail ($from, $m_title, $msg);
               $title = $Contract_ID.". Оплата $db_InSum Ukash EUR не принята!";
               $res_mail = SendMail ($from, $title, $msg, $user_mail);
            }
            break;
         } else {
            // Неизвестный код txCode
            MessageToDiv ("Неизвестный код возврата!<br>Свяжитесь с администратором.");
            $sql = "UPDATE Contract SET
                      Payment_Status = '-1'
                    WHERE
                      Payment_ID = '$PaymentID'";
            ExecSQL ($sql, $row);
            if ($row) {
               // отправляем сообщение админу
               $msg = "Заявки $Contract_ID.\r\n";
               $msg.= "Ошибка при списании ваучера Ukash.\r\n";
               $msg.= "$db_InSum Ukash - сумма платежа \r\n";
               $msg.= "Полный ответ сервера:\r\n";
               $msg.= "$resp\r\n";
               // сообщить админу, что оплата прошла успешно, данные сохранены.
               $m_title = $Contract_ID.". Неизвестный ответ сервера Ukash при списании ваучера.";
               $res_mail = SendMail ($from, $m_title, $msg);
               if (!$res_mail)
                  logger ($res_mail, "res_mail=$res_mail Неизвестный ответ сервера Ukash при списании ваучера Ukash, почта не отправляется.");
            }
            break;
         }
      } while (1);
      $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID' AND Payment_Status = 2";
      OpenSQL ($sql, $row, $res);
      if ($row == 1) {
            $sql = "UPDATE Contract SET
                      Payment_Status = '0'
                    WHERE
                      Payment_ID = '$PaymentID'";
            ExecSQL ($sql, $row);
      }
   } else {
      // $row != 1 (Заявка возможно уже выполнена!)
	   $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID'";
	   OpenSQL ($sql, $row, $res);
	   if ($row == 1) {
	      // заявка есть в базе
	      $row_rec = NULL;
	      GetFieldValue ($res, $row_rec, "Autorization_Time", $db_Autorization_Time , $IsNull);
	      GetFieldValue ($res, $row_rec, "Delivery_Status", $db_Delivery_Status , $IsNull);
	      GetFieldValue ($res, $row_rec, "Payment_Status", $db_Payment_Status , $IsNull);
	      // не оплачивался ли контракт ранее?
	      if (($db_Autorization_Time != "0")&&($db_Payment_Status=="1")) {
	         if ($db_Delivery_Status == "1") {
	            // Обмен завершен!
	            MessageToDiv ("Оплата была принята. Обмен завершен.");
	         } elseif ($db_Delivery_Status == "2") {
	            // Оплата принята. Обмен завершается.
	            MessageToDiv ("Оплата была принята. Обмен завершается.");
	         } elseif ($db_Delivery_Status == "0") {
	            // Оплата принята. Обмен не завершен.
                // Скрипт перевода ответного платежа
                include ("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/payment.asp");
	         } else {
	            // Ошибка при доставке денег (-1)
	            MessageToDiv ("Ошибка. Свяжитесь с администратором");
	         }
	      } elseif ($db_Payment_Status == "2") {
	         // Обмен уже совершается
	         MessageToDiv ("Оплата проверяется.");
	      } elseif ($db_Payment_Status == "-1") {
	         MessageToDiv ("Ошибка оплаты. Свяжитесь с администратором.");
	      }
	   }
   }

</script>