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
   $TITLE = "������ okwm.com.ua - �������, �������, ����� WMZ ������.������ ��������.������";
   $https = DOMAIN_HTTPS;

   // ������ ������� ������
   if (!empty($act)) {
      $PaymentID = "AU-".substr ($act, 0, 24);
      $key = substr ($act, 24, 32);
   } else {
      exit;
   }
   // �������� ����������� ������
   if (!HashOk("$PaymentID::", $key)) {
      echo "������ �������� �����! �������� ���������� �� ������ ��������������!<br>";
      exit;
   }

   // �������� ������
   $GetParam = "?PaymentID=$PaymentID&key=$key";

// Create HTML code
HTMLHead ($TITLE);
HTMLAfteHead_noBanner("���������� ������");

echo <<<EOT

<b>�������� �������� ������.</b><br />
<table align="left" width="100%">
  <tr>
    <td>
     ��������� ����������� ����� ������ �� ��� ����, ����� �� ������ "����������".<br>
    </td>
  </tr>
  <tr>
    <td>
     ����� �������� �������� ����� ���������� �����.<br>
     ���� ������ �� �������, �� ����� ������������� �� �����.
    </td>
  </tr>
</table>

<iframe src="robot.php$GetParam" name="ROBOT" frameborder="NO" width="800" border="0" scrolling="NO" onLoad="window.status='������';">�������� ������</iframe>

EOT;

HTMLAfteBody();
HTMLTail ();
?>