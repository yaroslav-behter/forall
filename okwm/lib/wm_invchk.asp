<script language="PHP">
// *****************************************
// ***   Проверка оплаты счета Webmoney  ***
// *****************************************
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm.inc");

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

   $check_point = 5; // количество проверок оплаты счета
   $check_sec   = 8; // временная задержка между проверками


   // выводим слой для вспомогательных сообщений
   echo <<<EOT
        <div id="mes" style="width:500;height=100;color=black">Проверка оплаты счета.</div>
EOT;
   flush();
   // проверка оплаты счета WM
   $PaymentID = SetUserVariable ("PaymentID", 0, 0);
   $key = SetUserVariable ("key", 0, 0);
   // Проверка целостности данных
   if (!HashOk("$PaymentID::", $key)) {
      MessageToDiv ("Ошибка проверки счета! Сообщите пожалуйста об ошибке администратору!<br>");
      exit;
   }
   $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID'";
   OpenSQL ($sql, $row, $res);
   if ($row == 1) {
      // заявка есть в базе
      $row_rec = NULL;
      GetFieldValue ($res, $row_rec, "ORDER_ID", $db_ORDER_ID, $IsNull);
      GetFieldValue ($res, $row_rec, "Contract_ID", $db_Contract_ID, $IsNull);
      GetFieldValue ($res, $row_rec, "wmid", $db_wmid, $IsNull);
      GetFieldValue ($res, $row_rec, "Autorization_Time", $db_Autorization_Time , $IsNull);
      GetFieldValue ($res, $row_rec, "Delivery_Status", $db_Delivery_Status , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Status", $db_Payment_Status , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Sum", $db_InSum , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Currency", $db_InMoney , $IsNull);
      GetFieldValue ($res, $row_rec, "MAIL", $db_mail, $IsNull);
      $Contract_ID = round($db_Contract_ID*pi());
      $user_mail = base64_decode ($db_mail);
      $wminv_id = $db_ORDER_ID;
      $wmid = $db_wmid;
      $inv_id = round($db_Contract_ID*pi());
      if ($db_InMoney == "WMZ") {
         $purse = "Z";
      } elseif ($db_InMoney == "WME") {
         $purse = "E";
      } elseif ($db_InMoney == "WMR") {
         $purse = "R";
      } elseif ($db_InMoney == "WMU") {
         $purse = "U";
      } else {
        MessageToDiv ("Заявка оплачивается не Webmoney!");
        exit;
      }
      // не оплачивался ли контракт ранее?
      if (($db_Autorization_Time != "0")&&($db_Payment_Status=="1")) {
         if ($db_Delivery_Status == "1") {
            // Обмен завершен!
            MessageToDiv ("Оплата была принята. Обмен завершен.");
            exit;
         } elseif ($db_Delivery_Status == "2") {
            // Оплата принята. Обмен завершается.
            MessageToDiv ("Оплата была принята. Обмен завершается.");
            exit;
         } elseif ($db_Delivery_Status == "0") {
            // Оплата принята. Обмен не завершен.
            MessageToDiv ("Оплата принята. Ожидайте перевода.");
            include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/payment.asp");
            exit;
         } else {
            // Ошибка при доставке денег (-1)
            MessageToDiv ("Ошибка. Свяжитесь с администратором");
            exit;
         }
      } elseif ($db_Payment_Status == "2") {
         // Обмен уже совершается
         MessageToDiv ("Оплата проверяется.");
         exit;
      } elseif ($db_Payment_Status == "-1") {
         MessageToDiv ("Ошибка оплаты. Свяжитесь с администратором.");
         exit;
      }

      sleep (5);
      // Устанавливаем флаг произведения оплаты.
      $sql = "UPDATE Contract SET
                Payment_Status = 2
              WHERE
                (ORDER_ID = '$db_ORDER_ID') AND
                (Delivery_Status = $db_Delivery_Status) AND
                (Payment_ID = '$PaymentID')";
      ExecSQL ($sql, $row);
      if ($row!=1) {
         MessageToDiv ("Ошибка проверки оплаты. Свяжитесь с администратором.");
         exit;
      }
      // оплаты WM еще не было
      if (($wmid != "")&&($wminv_id != "")&&($inv_id != "")&&($purse != "")) {
         $j = 0;
         do {
            $inv_state = InvCheck($inv_id, $wmid, $wminv_id, $purse);
            //   состояние счета $inv_state:
            //     -2 - ошибка проверки состояния
            //     -1 - удален
            //      0 - ждет оплаты
            //      1 - оплачен, но деньги не получены по причине наличия протекции сделки
            //      2 - оплачен
            if ($inv_state == 2) {
               $sql = "UPDATE Contract SET
                         Autorization_Time = NOW(),
                         ORDER_ID = '$wminv_id',
                         Payment_Status = '1',
                         Payment_Account = '$wmid'
                       WHERE
                         Payment_ID = '$PaymentID'";
               ExecSQL ($sql, $row);
               if ($row) {
                  // Сообщаем клиенту, что оплата плучена
                  MessageToDiv ("Оплата принята успешно!<br>Ожидайте перевода.");
                  // отправляем сообщение админу
                  $msg = "Оплата заявки $inv_id принята.\r\n";
                  $msg.= "$db_InSum $db_InMoney - сумма платежа \r\n";
                  $msg.= "$wminv_id - номер квитанции \r\n";
                  $msg.= "$wmid - идентификатор плательщика \r\n";
                  // сообщить админу, что оплата прошла успешно, данные сохранены.
                  $m_title = $Contract_ID.". Оплата $db_InMoney принята.";
                  $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                  $res_mail = SendMail ($from, $m_title, $msg);
                  if (!$res_mail)
                     logger ($res_mail, "res_mail=$res_mail Оплата заявки $PaymentID ($db_InSum $db_InMoney) получена, почта не отправляется.");
                  // сообщить плательщику, что оплата принята.
                  $msg = "Здравствуйте!\r\n";
                  $msg.= "Получено $db_InSum $db_InMoney.\r\n\r\n";
                  $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
                  $title = "Оплата $db_InSum $db_InMoney принята.";
                  $res_mail = SendMail ($from, $title, $msg, $user_mail);

                  // Добавить поступившую сумму WMZ или WME к сумме в Банке
                  SetGoodAmount ($db_InSum, $db_InMoney);

                  // Скрипт перевода ответного платежа
                  include ("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/payment.asp");
                  break;
               } else {
                  // заявки нет в базе
                  $msg = "Оплата заявки $inv_id принята, но не занесена в базу.\n\r";
                  $msg.= "Заявка $PaymentID\r\n";
                  $msg.= "$wminv_id - номер квитанции \r\n";
                  $msg.= "$wmid - WMid плательщика \r\n";
                  // сообщить админу, что оплата прошла, заявки нет в базе.
                  $m_title = $Contract_ID.". Оплата $db_InMoney принята, заявки нет в базе!";
                  $res_mail = SendMail ($from, $m_title, $msg);
                  if (!$res_mail)
                      logger ($res_mail, "res_mail=$res_mail Оплата $db_InMoney получена, почта не отправляется.");
               }
               break;
            } elseif ($inv_state == 1) {
               // оплата поступила, но счет оплачен с протекцией
               // Сообщаем клиенту, что оплата плучена с протекцией
               MessageToDiv ("Оплата принята успешно!<br>Сообщите код протекции администратору.");
               break;
            } elseif ($inv_state == 0) {
               // Счет ожидает оплаты
               // Сообщаем клиенту, что оплата еще не поступила
               MessageToDiv ($check_point-$j." Оплата еще не поступила!<br>Ожидаем оплаты.");
            } elseif ($inv_state == -1) {
               // Счет удален
               // Сообщаем клиенту, что счет удален
               MessageToDiv ("Оплата не принята!<br>Вы отказались от оплаты.");
               $sql = "UPDATE Contract SET
                         Payment_Status = '-1'
                       WHERE
                         Payment_ID = '$PaymentID'";
               ExecSQL ($sql, $row);
               if ($row) {
                  // отправляем сообщение админу
                  $msg = "Отказ от заявки $inv_id.\r\n";
                  $msg.= "$db_InSum $db_InMoney - сумма платежа \r\n";
                  $msg.= "$wmid - идентификатор плательщика \r\n";
                  // сообщить админу, что оплата не прошла, счет удален.
                  $m_title = $Contract_ID.". Оплата $db_InMoney не принята.";
                  $res_mail = SendMail ($from, $m_title, $msg);
                  if (!$res_mail)
                     logger ($res_mail, "res_mail=$res_mail Оплата заявки $PaymentID ($db_InSum $db_InMoney) не получена, почта не отправляется.");
               }
               break;
            } else if ($inv_state == -2) {
               // Ошибка проверки счета
               MessageToDiv ("Ошибка проверки оплаты!<br>Свяжитесь с администратором.");
               $sql = "UPDATE Contract SET
                         Payment_Status = '-1'
                       WHERE
                         Payment_ID = '$PaymentID'";
               ExecSQL ($sql, $row);
               if ($row) {
                  // отправляем сообщение админу
                  $msg = "Ошибка проверки оплаты счета заявки $inv_id.\r\n";
                  $msg.= "$db_InSum $db_InMoney - сумма платежа \r\n";
                  $msg.= "$wmid - идентификатор плательщика \r\n";
                  // сообщить админу, что оплата прошла успешно, данные сохранены.
                  $m_title = $Contract_ID.". Оплата $db_InMoney не принята. Оплата счета не проверена.";
                  $res_mail = SendMail ($from, $m_title, $msg);
                  if (!$res_mail)
                     logger ($res_mail, "res_mail=$res_mail Оплата заявки $PaymentID ($db_InSum $db_InMoney) проверена, почта не отправляется.");
               }
               break;
            }

            // задержка N сек.
            sleep($check_sec);
            if (connection_aborted()) {
               // Прекращаем вывод сообщений
               $echo_flag = false;
            }
            $j++;
         } while ($j < $check_point);
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
        // Есть пустые данные! (wmid, purse, № счета WM, № счета OKWM)
        MessageToDiv ("Ошибка проверки оплаты!");
      }
   } else {
      // $row != 1 (Заявка отсутствует в базе!)
      MessageToDiv ("Ошибка проверки оплаты!");
   }

</script>