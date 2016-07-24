<?
// ******************************
// ***   Совершение обмена    ***
// ******************************
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/verifysum.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm.inc");

   $AutoCurrency = array("WMZ", "WME", "WMR", "WMU", "UKSH", "YAD", "P24UA");
   // Входные данные
   $PaymentID = SetUserVariable ("PaymentID", 0, 0);
   $key = SetUserVariable ("key", 0, 0);
   // Проверка целостности данных
   if (!HashOk("$PaymentID::", $key)) {
      MessageToDiv ("Ошибка проверки счета! Сообщите пожалуйста об ошибке администратору!<br>");
      exit;
   }

   // Блокируем таблицу
   sleep (5);
   mysql_query("LOCK TABLES contract, goods WRITE");
   $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID'";
   OpenSQL ($sql, $row, $res);
   if ($row == 1) {
      // заявка есть в базе
      $row_rec = NULL;
      GetFieldValue ($res, $row_rec, "ORDER_ID", $ORDER_ID, $IsNull);
      GetFieldValue ($res, $row_rec, "Contract_ID", $Contract_ID, $IsNull);
      GetFieldValue ($res, $row_rec, "Autorization_Time", $Autorization_Time , $IsNull);
      GetFieldValue ($res, $row_rec, "Delivery_Status", $Delivery_Status , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Status", $Payment_Status , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Sum", $InSum , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Currency", $InMoney , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Account", $From_Account , $IsNull);
      GetFieldValue ($res, $row_rec, "Contract_Terms", $FullDescription , $IsNull);
      GetFieldValue ($res, $row_rec, "GOOD_AMOUNT", $OutSum , $IsNull);
      GetFieldValue ($res, $row_rec, "GOOD_ID", $OutMoneyID , $IsNull);
      GetFieldValue ($res, $row_rec, "Purse_To", $Purse_To , $IsNull);
      GetFieldValue ($res, $row_rec, "wmid", $wmid , $IsNull);
      GetFieldValue ($res, $row_rec, "MAIL", $encode_email , $IsNull);
      GetFieldValue ($res, $row_rec, "IP", $IP , $IsNull);
      $Contract_ID = round($Contract_ID*pi());
      $user_mail = base64_decode($encode_email);

      // Оплачен ли контракт?
      if (($Autorization_Time != "0")&&($ORDER_ID != "0")) {
         if ($Delivery_Status == "1") {
            // Обмен завершен!
            MessageToDiv ("Обмен завершен.");
            exit;
         } elseif ($Delivery_Status == "-1") {
            MessageToDiv ("Ошибка. Свяжитесь с администратором.");
            exit;
         } elseif ($Delivery_Status == "2") {
            MessageToDiv ("Перевод уже совершается.");
            exit;
         } elseif ($Delivery_Status == "0") {
            if ($Payment_Status == "2") {
                 // Оплата принята. Обмен совершается
                 MessageToDiv ("Оплата еще проверяется.");
                 exit;
            } elseif ($Payment_Status == "-1") {
                 MessageToDiv ("Ошибка оплаты.<br>Свяжитесь с администратором.");
                 exit;
            } elseif ($Payment_Status == "1") {
               sleep (3);
               // Устанавливаем флаг произведения оплаты.
               $sql = "UPDATE Contract SET
                         Delivery_Status = 2
                       WHERE
                         (ORDER_ID = '$ORDER_ID') AND
                         (Delivery_Status = $Delivery_Status) AND
                         (Payment_ID = '$PaymentID')";
               ExecSQL ($sql, $row);
               if ($row) {
                  // Установлен флаг совершения операции обмена.
                  $sql = "SELECT * FROM goods WHERE  GOODS_ID = '$OutMoneyID'";
                  OpenSQL ($sql, $row, $res);
                  if ($row != 1) {
                     // Код выдаваемой валюты ошибочный
                     MessageToDiv ("Выбранная валюта не обменивается.");
                     exit;
                  }
                  $row_rec = NULL;
                  GetFieldValue ($res, $row_rec, "GOODS_NAME", $OutMoney , $IsNull);
                  GetFieldValue ($res, $row_rec, "GOODS_AMOUNT", $SumInBank , $IsNull);
                  // Проверка валют для Betfair и Pokerstars
                  if (in_array($OutMoney, array("PSU","BFU"))) {
                       // Обмен производится на наличные. Выплата в представительстве.
                       MessageToDiv ("Вы поплняете счет в игровом сервисе Betfair или PokerStars.<br />".
                       				 "Заявки обрабатываются с 10-00 до 18-00 по будням<br />".
                       				 "и с 12-00 до 14-00 по субботам. Воскресенье - выходной.<br />".
                       				 "Свяжитесь с администратором для завершения обмена.");
                       exit;
                  } //Оплата принята, ожидайте перевода
                  if (in_array($OutMoney, array("GMU"))) {
                       // Обмен производится на карту Globalmoney. Перевод делает администратор
                       MessageToDiv ("Оплата принята, ожидайте перевода.");
                       exit;
                  }
                  // Проверка валют для автомата (WMZ, WME, WMR, YAD)
                  if (!in_array($OutMoney, $AutoCurrency)) {
                       if (in_array($OutMoney, array("PCB","SBRF"))) {
                           // обмен на счет/карту Южкомбанка
                           MessageToDiv ("При выводе средств <a href=\"".DOMAIN_HTTP."/banks.asp\">на банковский счет/карту</a>:<br />".
                                         "- по заявкам, оплаченным до 16-00, зачисление происходит в течение 2 часов;<br />".
                                         "- заявки, оплаченные после 16-00, обрабатываются на следующий день до 12-00.");
                           exit;
                       } elseif (in_array($OutMoney, array("P24US","P24UA"))) {
                           // обмен на счет/карту Приватбанка
                           MessageToDiv ("Для завершения заявки свяжитесь с администраторами сайта в рабочее время.<br />Заявки обрабатываются<br />с 11-00 до 19-00по будням<br />и с 12-00 до 14-00 по выходным дням.");
                           exit;
                       } else {
                           // Обмен производится на наличные. Выплата в представительстве.
                           MessageToDiv ("Обмен проводится в офисе при личной встрече.<br />При себе необходимо иметь указанный документ.");
                           exit;
                       }
                  }
                  // Проверка суммы на счету в банке
                  if ($SumInBank < $OutSum) {
                       // Валюта обменивается в ручном режиме при встрече
                       MessageToDiv ("Свяжитесь с администратором для завершения обмена.");
                       exit;
                  }
                  // For hacker !!!
                  if ($InMoney == $OutMoney) {
                       // Валюта обменивается в ручном режиме при встрече
                       MessageToDiv ("При обмене произошла ошибка. Свяжитесь с администратором.");
                       exit;
                  }
                  // Проверка входящей и исходящей сумм в зависимости от курсов валют
                  if (!VerifySum ($InSum, $InMoney, $OutSum, $OutMoney, $NewInSum, $NewOutSum, "sell")) {
                       // Курс валют существенно изменился. Суммы не актуальны.
                       MessageToDiv ("Сумма выплаты изменена. Возможно поменялся курс обмена.<br>Свяжитесь с администратором для завершения обмена.");
                       exit;
                  }
                  // Определение вида оплаты (Webmoney, e-gold, PayCash)
                  if (($OutMoney == "WMZ")||($OutMoney == "WME")||($OutMoney == "WMR")||($OutMoney == "WMU")) {
                     // *********************************************
                     // Перевод Webmoney
                     // *********************************************

                     $purse = substr($OutMoney, -1);
                     // Параметры запроса
                     switch ($InMoney) {
                        case "WMZ":
                        case "WME":
                        case "WMR":
                        case "WMU":
                           $In_PaySys = "Webmoney";
                           $In_Currency = $InMoney;
                           break;
                        case "YAD":
                           $In_PaySys = "Яндекс.Деньги";
                           $In_Currency = "руб";
                           break;
                        case "UKSH":
                           $In_PaySys = "Ukash voucher";
                           $In_Currency = "EUR";
                           break;
                     }
                     $dsc_str = "Оплата с $In_PaySys, сумма $InSum $In_Currency, счет(кошелек) $From_Account.";
                     $dsc_str.= " Спасибо за обмен! www.okwm.com.ua";
                     $dsc = str_replace("\\'", "'", str_replace("\\\"", "\"", $dsc_str));
                     // Отрезание крайних нулей в $OutSum
                     $OutSum = floatval($OutSum);
                     $trn_id = $Contract_ID."-".date("dmYHis", mktime());
                     // Вызов сервисной функции модуля wm
                     list($wmtrn_n, $err) = TransCreate($Purse_To, $OutSum, $Contract_ID+mktime(), $dsc, $purse);

                     // Вывод результата
                     if ($wmtrn_n>0) {
                          // Устанавливаем флаг операции в окончание обмена
                          $sql = "UPDATE Contract SET
                                    Delivery_Status = 1,
                                    ORDER_ID_OUT = '$wmtrn_n'
                                  WHERE
                                    Payment_ID = '$PaymentID'";
                          ExecSQL ($sql, $row);
                          MessageToDiv ("Обмен успешно завершен.");

                         // Отнять оплаченную сумму из суммы в Банке
                         SetGoodAmount (-round($OutSum + $OutSum * 0.008), $OutMoney);
                         // сообщить плательщику, что выплата произведена.
                         $msg = "Здравствуйте!\r\n";
                         $msg.= "$OutSum $OutMoney отправлено.\r\n\r\n";
                         $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
                         $title = "Выплата $OutSum $OutMoney произведена.";
                         $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                         $res_mail = SendMail ($from, $title, $msg, $user_mail);
                         // сообщить admin, что выплата WMZ или WME произведена.
                         $title = $Contract_ID.". ".$title;
                         $msg = "Заявка $Contract_ID выполнена.\r\n$OutSum $OutMoney отправлено.\r\n\r\n";
                         $msg.= "Номер квитанции: $wmtrn_n\r\n";
                         $res_mail = SendMail ($from, $title, $msg);
                         include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
                     } else {
                          $sql = "UPDATE Contract SET
                                    Delivery_Status = -1,
                                    Error_Pay = '$err'
                                  WHERE
                                    Payment_ID = '$PaymentID'";
                          ExecSQL ($sql, $row);
                          MessageToDiv ("Ошибка перевода : $err");
                          exit;
                     }
                  } elseif ($OutMoney == "YAD") {
                     // *********************************************
                     // Проверка соответствия счета получателя валюте (41001 - PCUAH)
                     // *********************************************

                     //if (substr($Purse_To, 0, 5) != "41001") {
                     if (substr($Purse_To, 0, 5) != "41001") {
                           MessageToDiv ("Обмен не завершен! Ошибка в номере счета получателя Яндекс.Денег.<br>Вы указали $Purse_To.</br>Номер должен начинаться с 41001<br>Свяжитесь с администратором.");
                           $sql = "UPDATE Contract SET
                                    Delivery_Status = -1,
                                    Error_Pay = 'Неправильный счет получателя Яндекс.Денег'
                                   WHERE
                                    Payment_ID = '$PaymentID'";
                           ExecSQL ($sql, $row);
                           exit;
                     }

                     require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/pc/config.inc.php");
                     // Перевод Yandex RUR
                     // Подготовка входных параметров:
                     $RequestParams["FunctionName"] = "RequestDirectPayment";
                     $RequestParams["UserID"] = "2403662437";
                     $RequestParams["PaymentSum"] = $OutSum;
                     $RequestParams["PaymentCurrencyCode"] = "643";
                     $RequestParams["AccountKey"] = $Purse_To;
                     switch ($InMoney) {
                        case "WMZ":
                        case "WME":
                        case "WMR":
                        case "WMU":
                           $In_PaySys = "Webmoney";
                           $In_Currency = $InMoney;
                           break;
                        case "PCB":
                           $In_PaySys = "ПАТ КБ Южкомбанк";
                           $In_Currency = "USD";
                           break;
                        case "UKSH":
                           $In_PaySys = "Ukash voucher";
                           $In_Currency = "EUR";
                           break;
                     }
                     $RequestParams["ShortDescription"] = "$InSum $In_Currency $In_PaySys=>$OutSum Яндекс.Денег";
                     $RequestParams["Destination"] = "Через обменный пункт \"OKWM\" произведена транзакция номер $Contract_ID\r\n";
                     $RequestParams["Destination"].= $FullDescription;
                     $RequestParams["PayerRegData"] = $PaymentID;
                     $RequestParams["InactivityPeriod"] = "60";
                     // Резервирование платежа
                     $RequestDP = $WA->RequestDirectPayment($RequestParams);

                     if ($RequestDP["ErrorCode"]!=1) {
                         // Ошибка. Разбор результата ошибки
                         $err = $RequestDP["ErrorCodeStr"];
                         MessageToDiv ("Обмен не завершен.<br>Свяжитесь с администратором.");
                         $sql = "UPDATE Contract SET
                                    Delivery_Status = -1,
                                    Error_Pay = '$err'
                                 WHERE
                                    Payment_ID = '$PaymentID'";
                         ExecSQL ($sql, $row);
                     } else {                         // Проведение ранее созданного платежа
                         $RequestParams["FunctionName"] = "ProcessPayment";
                         $RequestParams['PaymentTime'] = $RequestDP['PaymentTime'];
                         $RequestParams["OperationTimeOut"] = "5000";
                         $RequestParams["CancelFailedPayment"] = "0"; // Не производить отмену непроведенного платежа
                         $PPayment = $WA->ProcessPayment($RequestParams);

                         if ($PPayment["ErrorCode"] == 1) {
                             // Операция выполнена успешно. Статус платежа находится в переменной $PPayment["Status"]
                             $OrderID = $RequestDP['PaymentTime'];
                             if ($PPayment['Status'] == 4) {
                                 // Сохраняем результат успешного проведения платежа
                                 $sql = "UPDATE Contract SET
                                           Delivery_Status = 1,
                                           ORDER_ID_OUT = '$OrderID'
                                         WHERE
                                           Payment_ID = '$PaymentID'";
                                 ExecSQL ($sql, $row);
                                 MessageToDiv ("Обмен успешно завершен.<br>Квитанция выслана на Ваш e-mail.<br>Номер платежа: $OrderID");
                                 // Отнять оплаченную сумму из суммы в Банке
                                 SetGoodAmount (-$OutSum, $OutMoney);
                                 // сообщить плательщику, что выплата произведена.
                                 $msg = "Здравствуйте!\r\n";
                                 $msg.= "$OutSum Яндекс.Денег отправлено.\r\n\r\n";
                                 $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
                                 $title = "Выплата $OutSum Яндекс.Денег произведена.";
                                 $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                                 $res_mail = SendMail ($from, $title, $msg, $user_mail);
                                 // сообщить admin, что выплата Яндекс.Денег произведена.
                                 $title = $Contract_ID.". ".$title;
                                 $msg = "Заявка $Contract_ID выполнена.\r\n$OutSum Яндекс.Денег отправлено.\r\n\r\n";
                                 $msg.= "Номер квитанции: $OrderID\r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                                 include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
                             } else {                                 // Сохраняем ошибку проведения платежа
                                 $err = $PPayment['Status']."-".$PPayment['StatusStr'];
                                 $sql = "UPDATE Contract SET
                                           Delivery_Status = -1,
                                           ORDER_ID_OUT = '$OrderID',
                                           Error_Pay = '$err'
                                         WHERE
                                           Payment_ID = '$PaymentID'";
                                 ExecSQL ($sql, $row);
                                 MessageToDiv ("Обмен не завершен.<br>При проведении платежа возникла ошибка.<br>Номер платежа $OrderID сообщите адиминистратору.");
                                 // сообщить admin, что проведение Яндекс.Денег не прошло.
                                 $title = $Contract_ID.". Выплата $OutSum Яндекс.Денег завершилась ошибкой";
                                 $msg = "Заявка $Contract_ID не выполнена.\r\n$OutSum Яндекс.Денег не отправлено.\r\n\r\n";
                                 $msg.= "При проведении платежа возникла ошибка.\r\n";
                                 $msg.= "Статус платежа - ${PPayment['Status']} (${PPayment['StatusStr']}).\r\n";
                                 $msg.= "Номер платежа: $OrderID\r\n";
                                 $msg.= "Проверьте платеж вручную либо отмените его.\r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                             }
                         } else {                             // Отменить платеж или пробовать еще проводить
                             // Сохраняем ошибку проведения платежа
                             $err = $PPayment['ErrorCodeStr'];
                             $OrderID = $RequestDP['PaymentTime'];
                             $sql = "UPDATE Contract SET
                                       Delivery_Status = -1,
                                       ORDER_ID_OUT = '$OrderID',
                                       Error_Pay = '$err'
                                     WHERE
                                       Payment_ID = '$PaymentID'";
                             ExecSQL ($sql, $row);
                             MessageToDiv ("Обмен не завершен.<br>При проведении платежа возникла ошибка.<br>Номер платежа $OrderID сообщите адиминистратору.");
                             // сообщить admin, что проведение Яндекс.Денег не прошло.
                             $title = $Contract_ID.". Выплата $OutSum Яндекс.Денег завершилась ошибкой";
                             $msg = "Заявка $Contract_ID не выполнена.\r\n$OutSum Яндекс.Денег не отправлено.\r\n\r\n";
                             $msg.= "При проведении платежа возникла ошибка - $err.\r\n";
                             $msg.= "Номер платежа: $OrderID\r\n";
                             $msg.= "Проверьте платеж вручную либо отмените его.\r\n";
                             $res_mail = SendMail ($from, $title, $msg);
                         }
                     }
                  } elseif ($OutMoney == "UKSH") {                     // Issue UKASH Voucher EURO
                     $vNumber = "6337181631273230872"; // Выдал Ukash  633718   code product - 163, остальное не проверяется
                     $baseCurr = "EUR";
                     require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/uk.inc");
                     $resp = IssueVoucher($vNumber, $OutSum, $baseCurr);

                     if (!$resp) {
					    MessageToDiv ("При обмене произошла ошибка. Свяжитесь с администратором.");
                        exit;
					 }

					 $result = simplexml_load_string(html_entity_decode($resp));
					 $result = $result->UKashTransaction;
					 if ($result->txCode == 0){					      $ukshtrn_id = $result->ukashTransactionId;
					      // $result->transactionId;
					      // $result->txDescription
                          $sql = "UPDATE Contract SET
                                    Delivery_Status = 1,
                                    ORDER_ID_OUT = '$ukshtrn_id'
                                  WHERE
                                    Payment_ID = '$PaymentID'";
                          ExecSQL ($sql, $row);
						  $voucherIssueMessage.= "<table>";
						  $voucherIssueMessage.= "<tr><td rowspan=4><img src='img/ukash-logo.gif'></td><td>Issue Voucher Number:</td><td><b>{$result->IssuedVoucherNumber}</b></td></tr>";
						  $voucherIssueMessage.= "<tr><td>Issue Voucher Value:</td><td>{$result->IssuedAmount} {$result->IssuedVoucherCurr}</td></tr>";
						  $voucherIssueMessage.= "<tr><td>Issue Voucher Expiry Date:</td><td>{$result->IssuedExpiryDate}</td></tr>";
						  $voucherIssueMessage.= "<tr><td>Date:</td><td>".date('H:i d-m-Y')."</td></tr>";
						  $voucherIssueMessage.= "<tr><td colspan=3><small>Выпущен в соответствии с зарегистрированными условиями пользования. Смотрите <a target=_blank href=http://www.ukash.com>www.ukash.com</a></small></td></tr>";
						  $voucherIssueMessage.= "</table>";
                          MessageToDiv ($voucherIssueMessage);

                          // Отнять оплаченную сумму из суммы в Банке
                          SetGoodAmount (-$OutSum, $OutMoney);
                          // сообщить плательщику, что выплата произведена.
                          $msg = "Здравствуйте!\r\n";
                          $msg.= "Ваучер UKash создан успешно.\r\n";
                          $msg.= "Voucher Number: {$result->IssuedVoucherNumber}\r\n";
                          $msg.= "Voucher Value: {$result->IssuedAmount} {$result->IssuedVoucherCurr}\r\n";
                          $msg.= "Voucher Expiry Date: {$result->IssuedExpiryDate}\r\n\r\n";
                          $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
                          $title = "Ваучер UKash $OutSum EURO создан.";
                          $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                          $res_mail = SendMail ($from, $title, $msg, $user_mail);
                          // Send Webmoney Message
                          $wmmsg = "Voucher Number: {$result->IssuedVoucherNumber}\r\n";
                          $wmmsg.= "Voucher Value: {$result->IssuedAmount} {$result->IssuedVoucherCurr}\r\n";
                          $wmmsg.= "Voucher Expiry Date: {$result->IssuedExpiryDate}\r\n\r\n";
                          SendMsg($wmid,$wmmsg);
                          // сообщить admin, что выплата Ukash произведена.
                          $title = $Contract_ID.". ".$title;
                          $msg = "Заявка $Contract_ID выполнена.\r\nВаучер UKash $OutSum EUR создан.\r\n\r\n";
                          $msg.= "Номер квитанции: $ukshtrn_id\r\n";
                          $res_mail = SendMail ($from, $title, $msg);
                          include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
					 } else {
					    if ($result->txCode == 1){					        $err = "Error issue: ".$result->txDescription."; ".$result->errDescription;
			            } else {			                $err = "Error issue: (code ".$result->errCode.") ".$result->errDescription;
			            }
                        $sql = "UPDATE Contract SET
                                    Delivery_Status = -1,
                                    Error_Pay = '$err'
                                  WHERE
                                    Payment_ID = '$PaymentID'";
                        ExecSQL ($sql, $row);
                        MessageToDiv ("Ошибка при создании ваучера UKash. $err");
                        exit;
					 }
                  } elseif ($OutMoney == "P24UA") {                     require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/matrix_api.asp");
                     $p24 = new matrix();
                     $check_result = $p24->checkCard($Purse_To);
                     if (!$check_result[0]) {
                         // Ошибки по идее не должно быть, т.к. такая проверка проводилась уже перед оформлением заявки
                         // Проверяется потому, что перед переводом денег проверка обязательна
                         $err = $p24->getErrMessage();
                         if (!$check_result[0]) {
                            $sql = "UPDATE Contract SET
                                        Delivery_Status = -1,
                                        Error_Pay = '$err'
                                      WHERE
                                        Payment_ID = '$PaymentID'";
                            ExecSQL ($sql, $row);
    					    MessageToDiv ("Ошибка при проверке карточки $Purse_To. ".$err);
                            $title = $Contract_ID.". Выплата $OutSum грн. на приват24 завершилась ошибкой.";
                            $msg = "Заявка $Contract_ID не выполнена.\r\n$OutSum грн. не отправлено.\r\n\r\n";
                            $msg.= "При проверке карты приват24 $Purse_To возникла ошибка - $err.\r\n";
                            $msg.= "При приеме заявки эта проверка прошла успешно.\r\n";
                            $msg.= "Произведите перевод вручную.\r\n";
                            $res_mail = SendMail ($from, $title, $msg);
                            exit;
    					 }
                     } else {                         $resp = $p24->pay($Purse_To, $OutSum, $PaymentID);
                         $OrderID = $p24->pay_id;
                         if ($resp[0]) {                             // Платеж принят в обработку
                             $sql = "UPDATE Contract SET
                                       ORDER_ID_OUT = '$OrderID'
                                     WHERE
                                       Payment_ID = '$PaymentID'";
                             ExecSQL ($sql, $row);
     					     MessageToDiv ("Платеж принят в обработку.");
     					     sleep(2);
     					     $status = $p24->checkStatus();
     					     if ($status[0]) {     					         // Платеж выполнен успешно
     					         MessageToDiv ("Обмен успешно завершен.<br>Квитанция выслана на Ваш e-mail.<br>Номер платежа: $OrderID");
                                 $sql = "UPDATE Contract SET
                                           Delivery_Status = 1,
                                           ORDER_ID_OUT = '$OrderID'
                                         WHERE
                                           Payment_ID = '$PaymentID'";
                                 ExecSQL ($sql, $row);
                                 // Отнять оплаченную сумму из суммы в Банке
                                 SetGoodAmount (-$OutSum, $OutMoney);
                                 // Отправить сообщение клиенту о завершении обмена
                                 $msg = "Здравствуйте!\r\n";
                                 $msg.= "$OutSum гривен отправлено на карту приватбанка.\r\n\r\n";
                                 $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
                                 $title = "Выплата $OutSum грн на карту приватбанка произведена.";
                                 $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                                 $res_mail = SendMail ($from, $title, $msg, $user_mail);
                                 // сообщить admin, что выплата приват24 произведена.
                                 $title = $Contract_ID.". ".$title;
                                 $msg = "Заявка $Contract_ID выполнена.\r\n$OutSum грн отправлено на карту приватбанка.\r\n\r\n";
                                 $msg.= "Номер квитанции: $OrderID\r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                                 include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
                             } else if ($status[1] == 120) {                                 // Платеж находится в обработке
                                 MessageToDiv ($status[2]." Платеж еще в обработке.");
                                 // Отправить сообщение клиенту о завершении обмена
                                 $msg = "Здравствуйте!\r\n";
                                 $msg.= "$OutSum гривен отправлено на карту приватбанка.\r\n\r\n";
                                 $msg.= "Ваш платеж находится в обработке.\r\n\r\n";
                                 $msg.= "Проверить состояние платежа Вы можете по ссылке http://www.okwm.com.ua/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::")."\r\n";
                                 $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
                                 $title = "Платеж $OutSum грн на карту приватбанка в обработке.";
                                 $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                                 $res_mail = SendMail ($from, $title, $msg, $user_mail);
                                 // сообщить admin, что выплата приват24 произведена.
                                 $title = $Contract_ID.". ".$title;
                                 $msg = "Заявка $Contract_ID выполнена.\r\n$OutSum грн отправлено на карту приватбанка.\r\n\r\n";
                                 $msg.= "Номер платежа: $OrderID\r\n";
                                 $msg.= "Платеж находится в обработке.\r\n\r\n";
                                 $msg.= "Проверить состояние платежа можно по ссылке http://www.okwm.com.ua/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::")."\r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                                 include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
                             } elseif ($status[1] == 130) {                                 // Платеж отменен
                                 $err = $p24->getErrMessage();
                                 $sql = "UPDATE Contract SET
                                             Delivery_Status = -1,
                                             Error_Pay = '$err'
                                           WHERE
                                             Payment_ID = '$PaymentID'";
                                 ExecSQL ($sql, $row);
         					     MessageToDiv ("Ошибка при переводе средств на карту $Purse_To. ".$err);

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
                                 $title = $Contract_ID.". Выплата $OutSum грн. на приват24 завершилась ошибкой.";
                                 $msg = "Заявка $Contract_ID не выполнена.\r\n$OutSum грн. не отправлено.\r\n\r\n";
                                 $msg.= "При проведении оплаты на карту приват24 $Purse_To возникла ошибка - $err.\r\n";
                                 $msg.= "Номер платежа $OrderID.\r\n";
                                 $msg.= "Свяжитесь с поддержкой Матрикс. \r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                             } else {         					     // Отправить сообщение администратору
                                 $err = $p24->getErrMessage();
                                 $sql = "UPDATE Contract SET
                                             Delivery_Status = -1,
                                             Error_Pay = '$err'
                                           WHERE
                                             Payment_ID = '$PaymentID'";
                                 ExecSQL ($sql, $row);
         					     MessageToDiv ("Ошибка при переводе средств на карту $Purse_To. ".$err);
                                 $title = $Contract_ID.". Выплата $OutSum грн. на приват24 завершилась неизвестным статусом.";
                                 $msg = "Заявка $Contract_ID не выполнена.\r\n$OutSum грн. не отправлено.\r\n\r\n";
                                 $msg.= "При проведении оплаты на карту приват24 $Purse_To возникла ошибка - $err.\r\n";
                                 $msg.= "Номер платежа $OrderID.\r\n";
                                 $msg.= "Статус ".$status[1]." ???\r\n";
                                 $msg.= "Свяжитесь с поддержкой Матрикс. \r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                             }
                         } else {                             // Ошибка
                             $err = $p24->getErrMessage();
                             $sql = "UPDATE Contract SET
                                         Delivery_Status = -1,
                                         Error_Pay = '$err'
                                       WHERE
                                         Payment_ID = '$PaymentID'";
                             ExecSQL ($sql, $row);
     					     MessageToDiv ("Ошибка при переводе средств на карту $Purse_To. ".$err);
                             // Отправить сообщение администратору
                             $title = $Contract_ID.". Выплата $OutSum грн. на приват24 завершилась ошибкой.";
                             $msg = "Заявка $Contract_ID не выполнена.\r\n$OutSum грн. не отправлено.\r\n\r\n";
                             $msg.= "При проведении оплаты на карту приват24 $Purse_To возникла ошибка - $err.\r\n";
                             $msg.= "Номер платежа $OrderID.\r\n";
                             $msg.= "Свяжитесь с поддержкой Матрикс. \r\n";
                             $res_mail = SendMail ($from, $title, $msg);
                         }
                     }
                  }
               }
            } else {
               // Оплата не принята!
               MessageToDiv ("Оплата отмечена неправильно.");
               exit;
            }
         }
      } else {
         // Оплата не принята!
         MessageToDiv ("Оплата не получена.");
         exit;
      }
   } else {
      // Заявки нет в базе
      MessageToDiv ("Такой заявки нет.");
   }
   // Разблокируем таблицу
   mysql_query("UNLOCK TABLES");

</script>