<?php
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");

   // �� ��������� � Temporary Internet Files
   header("Cache-Control: no-store, no-cache, must-revalidate");  // HTTP/1.1
   header("Cache-Control: post-check=0, pre-check=0", false);
   header("Pragma: no-cache");                          // HTTP/1.0
   // ��������� ������ robot.php
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
   // �������� POST-����������
   $PaymentID = SetUserVariable ("PaymentID", 0, 0);
   $key = SetUserVariable ("key", 0, 0);
   // �������� �������
   if (!HashOk("$PaymentID::", $key)) {
      HTMLError("������ �������� ������.");
      exit;
   }
   echo <<<EOT
   <form enctype="multipart/form-data" method="post" name="payment" action="${HTTP_SERVER_VARS['PHP_SELF']}">
      <input type="hidden" name="PaymentID" value="$PaymentID">
      <input type="hidden" name="key" value="$key">
      ����� ������ ������� &quot;����������&quot;<br>
      <input type="submit" name="Cont" value="����������">
   </form>
EOT;
} else {
   // �������� POST-����������
   $PaymentID = SetUserVariable ("PaymentID", 0, 0);
   $key = SetUserVariable ("key", 0, 0);
   // �������� ������� ����������
   if (!HashOk("$PaymentID::", $key)) {
      HTMLError("������ �������� ������.");
      exit;
   }
   // �������� ������ �� ���� ��� ����������� �������� ������
   $sql = "SELECT * FROM Contract INNER JOIN goods ON (goods.GOODS_ID = Contract.GOOD_ID) WHERE Payment_ID = '$PaymentID'";
   OpenSQL ($sql, $row, $res);
   if ($row != 1) {
      // ������ ������� ������
      HTMLError("������ �������� ������.");
      exit;
   }

   // �������� �������� ������� ������ � �������!
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

   if ($Delivery_Status == "1") {       // ������� �����������
       HTMLError("���� ������ ���������. ����� ��������.");
   } elseif ($Delivery_Status == "-1") {       // ������ ��� �������
       HTMLError("��� ������� ���������� ������. ���������� � <a href=\"/contacts.asp\" target=\"_BLANK\">���������</a>.");
   } elseif (($Payment_Status == "1") && ($Autorization_Time!="0") && ($Delivery_Status == "2") && ($OutMoney == "P24UA")) {       // ������ ��������, ������ �� ���������
       // �������� ������� ����������
       if ($Pay_ID!="") {           // ����� �� ������24
           require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/matrix_api.asp");
           $p24 = new matrix();
           $p24->pay_id = $Pay_ID;
           $status = $p24->checkStatus();
           if ($status[0]) {               HTMLError("���� ������ ���������. ����� ��������.<br />");
               HTMLError("���� ���������� �������: ".$status[2]."<br />");
               HTMLError("����� ���������: ".$Pay_ID);
               $sql = "UPDATE Contract SET
                         Delivery_Status = 1
                       WHERE
                         Payment_ID = '$PaymentID'";
               ExecSQL ($sql, $row);
               // ������ ���������� ����� �� ����� � �����
               SetGoodAmount (-$OutSum, $OutMoney);
               $msg = "������������!\r\n";
               $msg.= "��� ������� �������� �� ����� �����������.\r\n\r\n";
               $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� www.okwm.com.ua\r\n";
               $title = "������� �� ����� ����������� �����������.";
               $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
               $res_mail = SendMail ($from, $title, $msg, $user_mail);
               // �������� admin, ��� ������� ������24 �����������.
               $title = $Contract_ID.". ".$title;
               $msg = "������ $Contract_ID ���������.\r\n";
               $msg.= "$OutSum ��� ���������� �� ����� �����������.\r\n\r\n";
               $msg.= "����� ���������: $Pay_ID\r\n";
               $res_mail = SendMail ($from, $title, $msg);
               include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
           } else if ($status[1] == 120) {
               // ������ ��������� � ���������
               HTMLError ($status[2]." ������ ��� � ���������.");
           } elseif ($status[1] == 130) {
               // ������ �������
               $err = $p24->getErrMessage();
               $sql = "UPDATE Contract SET
                           Delivery_Status = -1,
                           Error_Pay = '$err'
                         WHERE
                           Payment_ID = '$PaymentID'";
               ExecSQL ($sql, $row);
               HTMLError ("������ ��� �������� ������� �� ����� ����������� $Purse_To. ".$err);

               // ��������� ��������� ������� � ���������� ������
               $msg = "������������!\r\n";
               $msg.= "������ �� ���� ����� ��� ������� ������.\r\n\r\n";
               $msg.= "��� ��������� ������ ������ ���������� � ��������� �����.\r\n\r\n";
               $msg.= "�� ������� �������� ������� ���������� � ���������.\r\n";
               $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� www.okwm.com.ua\r\n";
               $title = "������ $OutSum ��� �� ����� ����������� �������.";
               $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
               $res_mail = SendMail ($from, $title, $msg, $user_mail);
               // ��������� ��������� ��������������
               $title = $Contract_ID.". ������� �� ������24 ����������� �������.";
               $msg = "������ $Contract_ID �� ���������.\r\n$\r\n\r\n";
               $msg.= "��� ���������� ������ �� ����� ������24 $Purse_To �������� ������ - $err.\r\n";
               $msg.= "����� ������� $Pay_ID.\r\n";
               $msg.= "��������� � ���������� �������. \r\n";
               $res_mail = SendMail ($from, $title, $msg);
           }
       } else {           HTMLError ("��� ����� � ���������. ��� ���������� �������� ���������� � <a href=\"/contacts.asp\" target=\"_BLANK\">���������</a>.");
       }
   } else {
       // ������ ������� � ����
       GetFieldValue ($res, $row_rec, "Payment_Currency", $InMoney , $IsNull);
       if (($InMoney == "WMZ")||($InMoney == "WME")||($InMoney == "WMR")||($InMoney == "WMU")) {
          // �������� ������ Webmoney
          require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm_invchk.asp");
       } elseif ($InMoney == "YAD") {
          require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/pc_paychk.asp");
       } else {
          HTMLError("������ ������������ ��������� � �����. �����, �� �������� ������������ ������, ������ �� �������� &quot;<a href=\"/contacts.asp\" target=\"_BLANK\">��������</a>&quot;");
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