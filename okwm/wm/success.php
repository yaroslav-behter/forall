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

   // ��������� HTML-��������
   $TITLE = base64_decode ($TITLE);
   $https = DOMAIN_HTTPS;

   // �������� ����������� ������
   if (!HashOk("$PAYMENTID::", $KEY)) {
      HTMLHead ("����� Webmoney � ������� OKWM.com.ua");
      HTMLAfteHead_noBanner("������������ ���� �� ��������");
      HTMLError("������ �������� ������ �� ��������! ��������� ���������� � ����������!<br>");
      HTMLAfteBody();
      HTMLTail ();
      exit;
   }

   // �������� ������
   $GetParam = "?PaymentID=$PAYMENTID&key=$KEY";

   // Create HTML code
   HTMLHead ("����� Webmoney � ������� OKWM.com.ua");
   HTMLAfteHead("���������� ������");

   echo <<<EOT

<iframe src="/robot.php$GetParam" name="ROBOT" frameborder="NO" width=500 border="0" scrolling="NO" onLoad="window.status='������';">�������� ������</iframe>

EOT;

HTMLAfteBody();
HTMLTail ();

?>