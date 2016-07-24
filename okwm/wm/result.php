<?php
#--------------------------------------------------------------------
# OKWM.com.ua Webmoney Transfer order payment module.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2005.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
# Requires /lib/database.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm.inc");

   //$post = print_r($HTTP_POST_VARS, true);
   //$res = @SendMail ("admin@okwm.com.ua", "ACCESS FROM IP " . getenv('REMOTE_ADDR') . " - " . date("Y-m-d H:i:s"), "����������� ������ /wm/result.php.\r\n������ � IP=".getenv('REMOTE_ADDR')."\r\n$post", "behter@mail.ru");


   $LMI_PREREQUEST            = $HTTP_POST_VARS['LMI_PREREQUEST'];
   $LMI_PAYEE_PURSE           = $HTTP_POST_VARS['LMI_PAYEE_PURSE'];
   $LMI_PAYMENT_AMOUNT        = $HTTP_POST_VARS['LMI_PAYMENT_AMOUNT'];
   $LMI_PAYMENT_NO            = $HTTP_POST_VARS['LMI_PAYMENT_NO'];
   $LMI_MODE                  = $HTTP_POST_VARS['LMI_MODE'];
   $LMI_PAYER_PURSE           = $HTTP_POST_VARS['LMI_PAYER_PURSE'];
   $LMI_PAYER_WM              = $HTTP_POST_VARS['LMI_PAYER_WM'];
   $LMI_HASH                  = $HTTP_POST_VARS['LMI_HASH'];
   $PAYMENTID                 = $HTTP_POST_VARS['PAYMENTID'];
   $KEY                       = $HTTP_POST_VARS['KEY'];

   if (!HashOk("$PAYMENTID::", $KEY)) {
      // ������� � ������� ���������
      $msg = "�������� ��������� ������! ������� ($KEY) ������������.\n\r";
      $msg.= "/wm/result.php\r\n";
      $msg.= "PAYMENTID=".$PAYMENTID."\r\n";
      $msg.= "KEY=".$KEY."\r\n";
      $title = "������������� ������ ����� Webmoney Merchant.";
      $from = SERVER_ADMIN_MAIL;
      $res_mail = SendMail ($from, $title, $msg);
      exit;
   }

   $wmz_account = $wmconst__shop_wmzpurse;
   $wme_account = $wmconst__shop_wmepurse;
   $wmr_account = $wmconst__shop_wmrpurse;
   $wmu_account = $wmconst__shop_wmupurse;
   $http = DOMAIN_HTTP;

   if ((!empty($LMI_PREREQUEST)) AND ($LMI_PREREQUEST == "1")) {
      do {
            // ��������������� ������ ������� ��������������� ����� ��� �����������
            if (($LMI_PAYEE_PURSE != $wmz_account)&&
                ($LMI_PAYEE_PURSE != $wme_account)&&
                ($LMI_PAYEE_PURSE != $wmr_account)&&
                ($LMI_PAYEE_PURSE != $wmu_account)) {
                  // ���� � ��������� Webmoney �� ����������� ��������!
                  $msg_err = "���� ���������� ������� �� ����������� $http!";
                  break;
            }
            if ($LMI_MODE != "0") {
                  // ������ ��������. ������� �� ����������.
                  $msg_err = "������ ����������� � �������� ������! ������� �� �������.";
                  break;
            }
            $sql = "SELECT * FROM Contract
                    WHERE Payment_ID = '$PAYMENTID' AND Payment_Status='0'";
            OpenSQL ($sql, $row, $res);
            if ($row != 1) {
                  // ������ ����������� ��� �� ���������
                  $msg_err = "������ �� ������ ��� ������ ��� ��������! SQL - $sql";
                  break;
            } else {
                  // ������ ���� � ����
                  $row_rec = NULL;
                  GetFieldValue ($res, $row_rec, "Payment_Sum", $InSum, $IsNull);
                  GetFieldValue ($res, $row_rec, "Payment_Currency", $Payment_Currency, $IsNull);
                  GetFieldValue ($res, $row_rec, "Contract_ID", $Contract_ID, $IsNull);
                  GetFieldValue ($res, $row_rec, "wmid", $WMid, $IsNull);
                  if ($LMI_PAYER_WM!=$WMid) {                      // � ������� ���������� X11 �������� ����� ���������� ������ WMID                      // ������ ���������� �� �������� �������� ����������
                      $msg_err = "������ ������������ ����� Webmoney Merchant. ������ � WMID $LMI_PAYER_WM, � ������ ���������� WMID $WMid.";
                      break;
                  }
            }
            if (round($Contract_ID*pi()) != $LMI_PAYMENT_NO) {
                  // ����� ������ �������. ������������� ������
                  $msg_err = "����� ������ �� ��������� � ������� � ��������� ��������� ������! ".round($Contract_ID*pi())." != $LMI_PAYMENT_NO";
                  break;
            }
            if ($LMI_PAYMENT_AMOUNT != $InSum) {
                  // ����� � ������� ��������
                  $msg_err = "����� ������� ��������!";
                  break;
            }
            if (substr($LMI_PAYEE_PURSE, 0, 1) != substr($Payment_Currency, 2, 1)) {
                  // ������ ������� ��������
                  $msg_err = "������ ������� ��������! �������=$LMI_PAYEE_PURSE, ������ � ������=$Payment_Currency";
                  break;
            }
      } while (0);
      if (empty($msg_err)) {
            // ������ ���. ������ �����������
            echo "YES";
            //$res_mail_prerequest = @SendMail ("admin@okwm.com.ua", "YES ���������� - " . date("Y-m-d H:i:s"), "������ /wm/result.php.\r\n" , "behter@mail.ru");
            exit;
      } else {
            // ���������� ��������� ��� ��������������
            $msg = "������ ����� Webmoney Merchant �� ��������!\r\n$msg_err\r\n";
            $msg.= "������, ��������� �������� Webmoney Merchant � ��������������� �������:\r\n";
            $msg.= "LMI_PAYEE_PURSE = $LMI_PAYEE_PURSE (������ ���� ���� $wmz_account, $wme_account ��� $wmr_account)\r\n";
            $msg.= "LMI_PAYMENT_NO = $LMI_PAYMENT_NO \r\n";
            $msg.= "LMI_PAYMENT_AMOUNT = $LMI_PAYMENT_AMOUNT (������ ���� $InSum)\r\n";
            $msg.= "LMI_MODE = $LMI_MODE (0: ������ ��������; 1: ������ ��������) \r\n";
            $msg.= "LMI_PAYER_WM = $LMI_PAYER_WM - WMid ����������\r\n";
            $msg.= "����� ������ $LMI_PAYMENT_NO \r\n";
            $title = "��������������� ������ ������� ����� Webmoney Merchant. ".$msg_err;
            $from = SERVER_ADMIN_MAIL;
            $res_mail = SendMail ($from, $title, $msg);
            if (!empty ($res_mail))
               logger ($res_mail, "��������������� ������ ������� �� ������ ($LMI_PAYMENT_NO), ����� �� ������������.");
            echo "Error!";
            exit;
      }
   }

   $LMI_SYS_INVS_NO           = $HTTP_POST_VARS['LMI_SYS_INVS_NO'];
   $LMI_SYS_TRANS_NO          = $HTTP_POST_VARS['LMI_SYS_TRANS_NO'];
   $LMI_SYS_TRANS_DATE        = $HTTP_POST_VARS['LMI_SYS_TRANS_DATE'];

   // �������� ������������� � �������������� �������
   $TesterWMID = $wmconst__shop_wmid;    // WMid OKWM.com.ua (lib/wmconst.inc)
   $ClientWMID = "967909998006";         // ������������� ������ Web Merchant Interface
   $APassphraseHash = WM_APASSPHR;       // Secret_Key (lib/config.asp)
   $AccessMarker = "$LMI_PAYEE_PURSE$LMI_PAYMENT_AMOUNT$LMI_PAYMENT_NO$LMI_MODE$LMI_SYS_INVS_NO$LMI_SYS_TRANS_NO$LMI_SYS_TRANS_DATE$APassphraseHash$LMI_PAYER_PURSE$LMI_PAYER_WM";
   $ClientSignStr = $LMI_HASH;           // ���������� �������

   // ����� ��������� ������� ������ wm
   list($status, $err) = TestAutority($ClientWMID, $AccessMarker, $ClientSignStr);

   if ($status ==  1) {
      // ������� ������� ����� ����������� ��������������
      $sql = "SELECT * FROM Contract
              WHERE Payment_ID = '$PAYMENTID' AND Payment_Status='0'";
      OpenSQL ($sql, $row, $res);
      if ($row != 1) {
         // ������ �� ������� � ���� ��� �� ����� 1-�
         // ���������� ��������� ��������������
         $msg = "������ ������ ����� Webmoney Merchant � �������� $LMI_PAYER_PURSE � ������� $LMI_PAYMENT_AMOUNT!\r\n";
         $msg.= "������, ��������� ��������� �������� Webmoney:\r\n";
         $msg.= "WMid ���������� = $LMI_PAYER_WM \r\n";
         $msg.= "������� ���������� = $LMI_PAYER_PURSE \r\n";
         $msg.= "LMI_PAYMENT_NO = $LMI_PAYMENT_NO (����� ������)\r\n";
         $msg.= "LMI_PAYMENT_AMOUNT = $LMI_PAYMENT_AMOUNT \r\n";
         $msg.= "LMI_MODE = $LMI_MODE (0-��������, 1-��������) \r\n";
         $msg.= "LMI_PAYEE_PURSE = $LMI_PAYEE_PURSE (����������) \r\n";
         $msg.= "LMI_SYS_TRANS_NO = $LMI_SYS_TRANS_NO (����� ������� � ���� Webmoney) \r\n";
         $msg.= "LMI_HASH = $LMI_HASH (�������) \r\n";
         $msg.= "LMI_SYS_TRANS_DATE = $LMI_SYS_TRANS_DATE \r\n";
         $msg.= "LMI_SECRET_KEY = $LMI_SECRET_KEY (������ ���� ������) \r\n";
         $msg.= "������� ������� = $KEY \r\n";
         if ($row == 0) {
            $title = "������ ������ ����� Webmoney Merchant! ������ � ���� ���.";
            $from = SERVER_ADMIN_MAIL;
            $res_mail = SendMail ($from, $title, $msg);
            if (!empty ($res_mail))
               logger ($res_mail, "������ ������ ����� Webmoney Merchant $LMI_SYS_TRANS_NO (������ $LMI_PAYMENT_NO), ������ � ���� ���, ����� �� ������������.");
         } else {
            $title = "������ ������ ����� Webmoney Merchant! ���������� ����� ������ � ���� $row.";
            $from = SERVER_ADMIN_MAIL;
            $res_mail = SendMail ($from, $title, $msg);
            if (!empty ($res_mail))
               logger ($res_mail, "������ ������ ����� Webmoney Merchant $LMI_SYS_TRANS_NO (������ $LMI_PAYMENT_NO), ������ � ���� ������ 1-��, ����� �� ������������.");
         }
      } else {
         // ������ ������� � ����
         $row_rec = NULL;
         GetFieldValue ($res, $row_rec, "Contract_ID",      $Contract_ID, $IsNull);
         GetFieldValue ($res, $row_rec, "Contract_Terms",   $Contract_Terms, $IsNull);
         GetFieldValue ($res, $row_rec, "Payment_Sum",      $Payment_Sum, $IsNull);
         GetFieldValue ($res, $row_rec, "Payment_Currency", $Payment_Currency, $IsNull);
         GetFieldValue ($res, $row_rec, "Payment_Status",   $Payment_Status, $IsNull);
         GetFieldValue ($res, $row_rec, "MAIL",             $db_mail, $IsNull);
         $user_mail = base64_decode ($db_mail);
         $Contract_ID_pi = round($Contract_ID*pi());
         switch ($Payment_Currency) {
         case "WMZ":
            $purse = $wmconst__shop_wmzpurse;
            break;
         case "WME":
            $purse = $wmconst__shop_wmepurse;
            break;
         case "WMR":
            $purse = $wmconst__shop_wmrpurse;
            break;
         case "WMU":
            $purse = $wmconst__shop_wmupurse;
            break;
         }
         // �������� �����, ������ (WMZ, WMR, WME, WMU), ������� ���������� � ����� ������ (0-����, 1-����)
         if (($LMI_PAYMENT_AMOUNT == $Payment_Sum)&&                              // �����
             (substr($LMI_PAYEE_PURSE,0,1)==substr($Payment_Currency,2,1))&&      // ��� ��������
             ($LMI_PAYEE_PURSE == $purse)&&                                       // ������� ��������
             ($LMI_MODE == 0)&&                                                   // ����� �������
             ($Payment_Status == "0")&&                                           // ���������� ������
             ($Contract_ID_pi == $LMI_PAYMENT_NO))                                // ����� ��������� ������ �� �������
         {
             // ������ ������� �����. ������ ������� �� ������.
             $Autorization_Time = str_replace(":","", str_replace(" ","", $LMI_SYS_TRANS_DATE));
             $Contract_Terms = "from $LMI_PAYER_PURSE\r\n".$Contract_Terms;
             $ORDER_ID = "$LMI_SYS_TRANS_NO";
             $sql = "UPDATE Contract SET
                        Contract_Terms = '$Contract_Terms',
                        Autorization_Time = '$Autorization_Time',
                        wmid = '$LMI_PAYER_WM',
                        ORDER_ID = '$ORDER_ID',
                        Payment_Status = 1,
                        Payment_Account = '$LMI_PAYER_PURSE'
                     WHERE
                        Contract_ID = $Contract_ID AND Payment_ID = '$PAYMENTID'";

             ExecSQL ($sql, $row);
             if (!$row) {
                // �������� ������, ��� ������ ������, ������ �� ��������� � ����.
                $err = mysql_error ();
                $msg = "������ $LMI_PAYMENT_NO ��������, �� ������ �� �������� � ����!!!\r\n";
                $msg.= "SQL=$sql \r\n";
                $msg.= "������: $err\r\n";
                $msg.= "������, ��������� Webmoney Merchant: \r\n";
                $msg.= "����� ������ $LMI_PAYMENT_AMOUNT.\r\n";
                $msg.= "������� ���������� $LMI_PAYER_PURSE\r\n";
                $msg.= "��������� �� ������ $LMI_SYS_TRANS_NO.\r\n";
                $msg.= "���� ������ $Autorization_Time ($LMI_SYS_TRANS_DATE)\r\n";
                $title = "$LMI_PAYMENT_NO. ������ Webmoney Merchant �� �������� � ����.";
                $from  = SERVER_ADMIN_MAIL;
                $res_mail = @SendMail ($from, $title, $msg);
                if (!empty ($res_mail)) {
                        // ���������� � ������� �� �������� � ����!
                        $err = mysql_errno ();
                        logger ('FATAL', "������ $LMI_PAYMENT_NO, ������ $LMI_PAYMENT_AMOUNT $Payment_Currency �� ��������, ����� �� ������������".$err, __FILE__, __LINE__);
                }
             } else {
                // �������� ������, ��� ������ ������, ������ ���������.
                $msg = "������ $LMI_PAYMENT_NO ��������.\r\n";
                $msg.= "��������� �� ������ $LMI_SYS_TRANS_NO.\r\n";
                $msg.= "���� ������ $LMI_SYS_TRANS_DATE\r\n";
                $title = "������ $LMI_PAYMENT_NO. ������� $LMI_PAYMENT_AMOUNT $Payment_Currency";
                $from  = "OKWM.com.ua<".SERVER_ADMIN_MAIL.">";
                $res_mail = @SendMail ($from, $title, $msg);
                if (!empty ($res_mail)&&!$res_mail)
                   logger ($res_mail, "Zayavka $LMI_PAYMENT_NO. $LMI_PAYMENT_AMOUNT $Payment_Currency received. Mail not sending.");
                // �������� �����������, ��� ������ �������.
                $msg = "������������!\r\n";
                $msg.= "�������� $LMI_PAYMENT_AMOUNT $Payment_Currency.\r\n";
                $msg.= "��������� �� ������ $LMI_SYS_TRANS_NO.\r\n";
                $msg.= "���� ������ $LMI_SYS_TRANS_DATE\r\n\r\n";
                $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� $http\r\n";
                $title = "������ $Payment_Sum $Payment_Currency �������.";
                $from  = SERVER_ADMIN_MAIL;
                $res_mail = @SendMail ($from, $title, $msg, $user_mail);

                // �������� ����������� ����� WM � ����� � �����
                SetGoodAmount ($Payment_Sum, $Payment_Currency);
             }
         } else {
             // ������ � ��������� �� ������ �� ��������� � ������� � ������
             $msg = "������ $LMI_PAYMENT_NO. ������ ������ �������.\r\n";
             $msg.= "����� ������ �� ��������� � ������� � ��������� ��������� ������! $Contract_ID_pi != $LMI_PAYMENT_NO";
             $msg.= "����� $LMI_PAYMENT_AMOUNT == $Payment_Sum\r\n";
             $msg.= "��� �������� ".substr($LMI_PAYEE_PURSE,0,1)."==".substr($Payment_Currency,2,1)."\r\n";
             $msg.= "������� �������� $LMI_PAYEE_PURSE == $purse\r\n";
             $msg.= "����� ������� $LMI_MODE (0-����, 1-����)\r\n";
             $msg.= "����� ������ $LMI_PAYMENT_NO == $Contract_ID)\r\n";
             $msg.= "������ ������ $Payment_Status (0-����������, 1-��� ��������)\r\n";
             $title = "������ ����� Webmoney Merchant ����������� �� ���������!";
             $from  = SERVER_ADMIN_MAIL;
             $res_mail = SendMail ($from, $title, $msg);
             if (!empty ($res_mail))
                logger ($res_mail, "������ ������ ����� Webmoney Merchant �� ��������� � ������� $LMI_PAYMENT_NO, ����� �� ������������.");
         }
      }
   } else {
      // ������� Webmoney Merchant �� �������
      $msg = "������� WEBMONEY MERCHANT � ��������� ������������!\r\n";
      $msg.= "������ $LMI_PAYMENT_NO.\r\n";
      $msg.= "������: ";
      if ($status ==  -1)
      { $msg.= "$err \r\n\r\n"; }
      elseif ($status ==  0)
      { $msg.= "�������������� ������ �� Webmoney Merchant �� �����������. \r\n\r\n"; }
      else
      { $msg.= "���������� ������ ������� �������� ������ �� Webmoney Merchant. \r\n\r\n"; }

      $title = "������ ����� Webmoney Merchant ����������� �� ���������!";
      $from  = SERVER_ADMIN_MAIL;
      $res_mail = SendMail ($from, $title, $msg);
      if (!empty ($res_mail))
         logger ($res_mail, "������������� ������� ����� Webmoney Merchant. ������� � ��������� �� ����������, ����� �� ������������.");
   }
   //$res = @SendMail ("admin@okwm.com.ua", "ACCESS FROM IP ". getenv('REMOTE_ADDR') ." - ". date("Y-m-d H:i:s"), "END /wm/result.php", "behter@mail.ru");
?>