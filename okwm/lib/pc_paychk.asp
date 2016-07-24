<script language="PHP">
// ***********************************************************
// ***   Проверка оплаты заявки И.Деньгами или Я.Деньгами  ***
// ***********************************************************
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");

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
        <div id="mes" style="width:750;height=100;color=black"></div>
EOT;
   flush();
   // проверка оплаты PayCash Яндекс.Денег
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
      GetFieldValue ($res, $row_rec, "ORDER_ID", $db_ORDER_ID, $IsNull);                    // Batch
      GetFieldValue ($res, $row_rec, "Contract_ID", $db_Contract_ID, $IsNull);              // Номер заявки
      GetFieldValue ($res, $row_rec, "Autorization_Time", $db_Autorization_Time , $IsNull); // Врема авторизации платежа
      GetFieldValue ($res, $row_rec, "Delivery_Status", $db_Delivery_Status , $IsNull);     // Статус доставки ответного платежа
      GetFieldValue ($res, $row_rec, "Payment_Status", $db_Payment_Status , $IsNull);       // Статус оплаты
      GetFieldValue ($res, $row_rec, "Payment_Sum", $db_InSum , $IsNull);                   // Сумма оплаты
      GetFieldValue ($res, $row_rec, "Payment_Currency", $db_InMoney , $IsNull);            // Валюта оплаты
      if ($db_InMoney != "YAD") {
         MessageToDiv ("Заявка оплачивается не Яндекс.Деньгими!");
         exit;
      }
      // не оплачивался ли контракт ранее?
      if ($db_Autorization_Time != "0") {
         if ($db_Delivery_Status == "1") {
            // Обмен завершен!
            MessageToDiv ("Оплата уже была принята. Обмен завершен.");
            exit;
         } elseif ($db_Delivery_Status == "0") {
            // Оплата принята. Обмен не завершен.
            if ($db_Payment_Status == "2") {
               // Обмен уже совершается
               MessageToDiv ("Оплата получена. Обмен совершается.");
               exit;
            } elseif ($db_Payment_Status == "0") {
               MessageToDiv ("Оплата не получена. Обмен не выполнен.");
               exit;
            } elseif ($db_Payment_Status == "-1") {
               MessageToDiv ("Ошибка. Свяжитесь с администратором.");
               exit;
            }
         } else {
            // Ошибка при доставке денег (-1)
            MessageToDiv ("Ошибка. Свяжитесь с администратором");
            exit;
         }
      }
      // оплаты PayCash еще не было
      if (($db_ORDER_ID != "")&&($db_Autorization_Time != "0")) {
         // Сообщаем клиенту, что оплата плучена
         MessageToDiv ("Оплата принята успешно!<br>Ожидайте перевода.");

         // Скрипт перевода ответного платежа
         include ("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/payment.asp");
         break;
      } else {
         // Есть пустые данные! (wmid, purse, № счета WM, № счета OKWM)
         MessageToDiv ("Ошибка проверки оплаты!");
      }
   } else {
      // $row != 1 (Заявка отсутствует в базе!)
      MessageToDiv ("Ошибка проверки оплаты!");
   }

</script>