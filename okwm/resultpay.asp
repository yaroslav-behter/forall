<?php
#--------------------------------------------------------------------
# OKWM page for verify result of payment.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");

   foreach ($HTTP_GET_VARS as $fk => $fv) {
       $fv = addcslashes($fv, '"');
       eval("\$$fk = \"$fv\";");
   }
   $TITLE = "Сервис okwm.com.ua - покупка, продажа, обмен WMZ Яндекс.Деньги Интернет.Деньги";
   $https = DOMAIN_HTTPS;

   // Парсим входные данные
   if (!empty($act)) {
      $PaymentID = "AU-".substr ($act, 0, 24);
      $key = substr ($act, 24, 32);
   } else {
      exit;
   }
   // Проверка целостности данных
   if (!HashOk("$PaymentID::", $key)) {
      echo "Ошибка проверки счета! Сообщите пожалуйста об ошибке администратору!<br>";
      exit;
   }

   // кодируем данные
   $GetParam = "?PaymentID=$PaymentID&key=$key";

// Create HTML code
HTMLHead ($TITLE);
HTMLAfteHead_noBanner("Завершение обмена");

echo <<<EOT

<b>Страница проверки оплаты.</b><br />
<table align="left" width="100%">
  <tr>
    <td>
     Проверьте поступление Вашей оплаты на наш счет, нажав на кнопку "Продолжить".<br>
    </td>
  </tr>
  <tr>
    <td>
     После успешной проверки будет произведен обмен.<br>
     Если оплата не принята, то обмен осуществлятся не будет.
    </td>
  </tr>
</table>

<iframe src="robot.php$GetParam" name="ROBOT" frameborder="NO" width="800" border="0" scrolling="NO" onLoad="window.status='Готово';">Проверка оплаты</iframe>

EOT;

HTMLAfteBody();
HTMLTail ();
?>