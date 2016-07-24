<script language="PHP">
// *************************
// ***   Выписка счета   ***
// *************************
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm.inc");

   // Параметры запроса
   switch ($inmoney) {
      case "WMZ":
         $purse  = "Z";
         break;
      case "WME":
         $purse  = "E";
         break;
      case "WMR":
         $purse  = "R";
         break;
      case "WMU":
         $purse  = "U";
         break;
   }
   $summ   = $InSum;
   $inv_id = $ContractID;
   if (($outmoney == "NUAH")||($outmoney == "USD")||($outmoney == "EUR")) {
      // Получаем адрес представительства
      if ($city == "Киев") {         $addr = ADDR_Kiev;
         $protect = 0;
      } elseif ($city == "Днепропетровск")
         $addr = ADDR_Dnepr;
      else
         $addr = ADDR_Odessa;
      // Если вывод WMZ, WME, WMR или WMU, то срок протекции 3 дня.
      $protect = 3;
   } else {
      $addr = "Счет получателя: $Purse_To";
      // Если обмен WMZ, WME, WMR или WMU на эл.валюту, то счет без протекции.
      $protect = 0;
   }
   $adr    = str_replace("\\'", "'", str_replace("\\\"", "\"", $addr));

   // Запрос о повторном выписывании счета
   $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID' AND NOT (ORDER_ID = '0')";
   OpenSQL ($sql, $row, $res);
   if ($row == 1) {
      // Счет уже выписывался.
      // кодируем данные
      $key = EvalHash ("$PaymentID::");
      $GetParam = "?PaymentID=$PaymentID&key=$key";
      echo <<<EOT
         <b>Счет уже выписан. <a href="wmk:refresh" title="Обновление информации">Обновите</a> информацию в Webmoney Keeper.</b><br>
         <b><a href="wmk:display?window=Invoices_In&page=1&BringToFront=Y">Посмотреть входящие счета в Webmoney Keeper Classic</a>.</b><br>
         <iframe src="robot.php$GetParam" name="ROBOT" frameborder="NO" width=500 border="0" scrolling="NO" onLoad="window.status='Готово';">Проверка счета</iframe>
EOT;

   } else {
      // Счет еще не был выписан
      if (($purse == "")||($WMid == "")||
          ($summ == "")||($inv_id == "")) {
         // Ошибка передачи данных
         $wminvc_n = -1;
         $err = "Ошибка выписки счета!";
      } else {
         // Подготовка описания счета по требованиям от 14.01.2006 г.
         $dsc_str = "$ContractID.".chr(13);

         $dsc_str.= "$summ WM$purse => $OutSum $o. ";
         if (($outmoney == "NUAH")||($outmoney == "USD")||($outmoney == "EUR")) {
            // Обмен на наличные
            if (isset($city)) $dsc_str.= "$city ";
            $dsc_str.= "$lastname $firstname $midlename $passport.".chr(13);
         } elseif (($outmoney == "BFU")||($outmoney == "PSU")||($outmoney == "PCB")) {
            // Обмен на наличные
            $dsc_str.= "$lastname $firstname $midlename $passport.".chr(13);
            if ($outmoney == "BFU")
                $dsc_str.= "Betfair $Purse_To.".chr(13);
            if ($outmoney == "PSU")
                $dsc_str.= "Pokerstars $Purse_To.".chr(13);
            if ($outmoney == "PCB")
                $dsc_str.= "Южкомбанк $Purse_To.".chr(13);
         } elseif (($outmoney == "P24US")||($outmoney == "P24UA")) {
            // Вывод на Приватбанк
            $dsc_str.= "$lastname $firstname $midlename $passport.".chr(13);
            $dsc_str.= "Приватбанк $Purse_To.".chr(13);
         } else {
            // Автоматический обмен
            $dsc_str.= "Счет(кошелек) получателя $Purse_To ";
         }
         $dsc_str.= "www.okwm.com.ua";
         $dsc = str_replace("\\'", "'", str_replace("\\\"", "\"", $dsc_str));
         // Вызов сервисной функции модуля wm для выписки счета
         list($wminvc_n, $err) = InvCreate($WMid, $summ, $inv_id, $dsc, $adr, $purse, $protect);
      }
      // Вывод результата
      if ($wminvc_n>0)
      { // счет выписан успешно. номер счета $wminvc_n
        // Заносим в базу номер счета в системе WM и WMid плательщика
        $sql = "UPDATE Contract SET
                  ORDER_ID = '$wminvc_n'
                WHERE
                  Payment_ID = '$PaymentID'";
        ExecSQL ($sql, $row);

        // кодируем данные
        $key = EvalHash ("$PaymentID::");
        $GetParam = "?PaymentID=$PaymentID&key=$key";
        echo <<<EOT
              <b>Счет выписан успешно!</b>
              <table>
                <tr>
                  <td colspan="2">Ваш кошелек должен быть запущен.<br>
                  Вам выслан счет на оплату заявки.<br>
                  <a href="wmk:refresh" title="Обновление информации">Обновить</a> информацию в Webmoney Keeper Classic.
                  Список <a href="wmk:display?window=Invoices_In&page=1&BringToFront=Y"> входящих счетов</a> в Webmoney Keeper Classic.</td>
                </tr>
              </table>

         <iframe src="robot.php$GetParam" name="ROBOT" frameborder="NO" width=500 border="0" scrolling="NO" onLoad="window.status='Готово';">Проверка оплаты</iframe>
EOT;
      } else {
        // ошибка выписки счета. свяжитесь с админом или попробуйте позже.
        echo <<<EOT
              <b>Ошибка выписки счета!</b>
              <table>
                <tr>
                  <td colspan="2">Произошла ошибка при отправке Вам счета. Попробуйте еще раз, или свяжитесь с администратором.</td>
                </tr>
                <tr>
                  <td>Ошибка:</td>
                  <td>$err</td>
                </tr>
              </table>
EOT;
      }
   }

</script>