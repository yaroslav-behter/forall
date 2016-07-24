<?php
#--------------------------------------------------------------------
# OKWM.com.ua Webmoney Transfer result of payment page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");

   foreach ($HTTP_POST_VARS as $fk => $fv) {
       $fv = addcslashes($fv, '"');
       eval("\$$fk = \"$fv\";");
   }

   // Заголовок HTML-страницы
   $TITLE = base64_decode ($TITLE);
   $https = DOMAIN_HTTPS;

   // Проверка целостности данных
   if (!HashOk("$PAYMENTID::", $KEY)) {
      HTMLHead ("Обмен Webmoney в сервисе OKWM.com.ua");
      HTMLAfteHead_noBanner("Неправильный вход на страницу");
      HTMLError("Ошибка передачи данных на страницу! Свяжитесь пожалуйста с поддержкой!<br>");
      HTMLAfteBody();
      HTMLTail ();
      exit;
   }

   // кодируем данные
   $GetParam = "?PaymentID=$PAYMENTID&key=$KEY";

   // Create HTML code
   HTMLHead ("Обмен Webmoney в сервисе OKWM.com.ua");
   HTMLAfteHead("Завершение обмена");

   echo <<<EOT

<iframe src="/robot.php$GetParam" name="ROBOT" frameborder="NO" width=500 border="0" scrolling="NO" onLoad="window.status='Готово';">Проверка оплаты</iframe>

EOT;

HTMLAfteBody();
HTMLTail ();

?>