<?php
#<script language="PHP">
# Ukash Voucher Redemption
# www.okwm.com.ua Behter Y. 2010
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/uk.inc");

        $echo_flag = true;
        // ������� ������ ������ ��������� � ���� "mes"
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

   // ������� ���� ��� ��������������� ���������
   echo <<<EOT
        <div id="mes" style="width:500;height:800;color:black;padding-top:20;">�������� ������� Ukash.</div>
EOT;
   flush();
   // �������� ������� Ukash
   $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID' AND Payment_Currency='UKSH' AND
           Autorization_Time='0' AND Payment_Status=0 AND Delivery_Status=0 AND Error_Pay=''";
   OpenSQL ($sql, $row, $res);
   if ($row == 1) {
      // ������ ���� � ����
      $row_rec = NULL;
      GetFieldValue ($res, $row_rec, "Contract_ID", $db_Contract_ID, $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Sum", $db_InSum , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Account", $db_Voucher , $IsNull);
      GetFieldValue ($res, $row_rec, "MAIL", $db_mail, $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Sum", $db_InSum , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Currency", $db_InMoney , $IsNull);
      $Contract_ID = round($db_Contract_ID*pi());
      $user_mail = base64_decode ($db_mail);
      list($vNumber, $vValue) = explode(":", $db_Voucher);

      sleep (3);
      do {
	     // ��������������� ���� ������������ �������� ������ (�������� ������� Ukash).
	     $sql = "UPDATE Contract SET
	                Payment_Status = 2
	             WHERE
	                (Autorization_Time = '0') AND
	                (Delivery_Status = 0) AND
	                (Payment_ID = '$PaymentID')";
	     ExecSQL ($sql, $row);
	     if ($row!=1) {
	        MessageToDiv ("��� �������� ������� Ukash ��������� ������. ��������� � ���������������.");
	        break;
	     } else {	        MessageToDiv ("�������� ������� Ukash ������. �������� ���������.");
	     }
	     $transID = substr($PaymentID,3,20);
         // Redemption Ukash Voucher
         $resp = Redemption($vNumber, $vValue, "EUR", $db_InSum, $transID);
         if (!$resp) {	        MessageToDiv ("��� �������� ������� Ukash ��������� ������. ��������� � ���������������.");
	        break;
         }
         $result = simplexml_load_string(html_entity_decode($resp));
         $result = $result->UKashTransaction;

         if ($result->txCode == 0) {            // Accepted
            // Redemption successful
            $sql = "UPDATE Contract SET
                      Autorization_Time = NOW(),
                      ORDER_ID = '".$result->ukashTransactionId."',
                      Payment_Status = '1'
                    WHERE
                      Payment_ID = '$PaymentID'";
            ExecSQL ($sql, $row);
            if ($row) {
               // �������� �������, ��� ������ �������
               $message = "����� $db_InSum EUR ������� �������!<br>";
               if ((string) $result->changeIssueVoucherNumber !== "") {                   $message = "����� �������: ".$result->changeIssueVoucherNumber."<br />";
                   $message.= "�����: ".$result->changeIssueAmount." ".$result->changeIssueVoucherCurr."<br />";
                   $message.= "������������ ��: ".$result->changeIssueExpiryDate."<br />";
               }
               $message.= "��� ���������� ��������� �������� ������� ������ &quot;����������&quot;.<br />";
               $key = EvalHash("$PaymentID::");
               $GetParam = "?PaymentID=$PaymentID&key=$key";
               echo <<<EOT

               <iframe src="robot.php$GetParam" name="ROBOT" frameborder="NO" width="500" border="0" scrolling="NO" onLoad="window.status='������';">�������� ������</iframe>
EOT;
               MessageToDiv ($message);
               // ���������� ��������� ������
               $msg = "������ ������ $Contract_ID �������.\r\n";
               $msg.= "$db_InSum Ukash EUR - �����, �������� � �������\r\n";
               $msg.= $result->ukashTransactionId." - Ukash Transaction Id\r\n";
               if ((string) $result->changeIssueVoucherNumber !== "") {
                   $msg.= "����� �������: ".$result->changeIssueVoucherNumber."\r\n";
                   $msg.= "�����: ".$result->changeIssueAmount." ".$result->changeIssueVoucherCurr."\r\n";
                   $msg.= "������������ ��: ".$result->changeIssueExpiryDate."\r\n";
               }
               // �������� ������, ��� ������ ������ �������, ������ ���������.
               $m_title = $Contract_ID.". ������ Ukash ������.";
               $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
               $res_mail = SendMail ($from, $m_title, $msg);
               if (!$res_mail)
                  logger ($res_mail, "res_mail=$res_mail ������ ������ $PaymentID ($db_InSum Ukash EUR) ��������, ����� �� ������������.");
               // �������� �����������, ��� ������ �������.
               $msg = "������������!\r\n";
               $msg.= "������ Ukash ������ �� ����� $db_InSum EUR.\r\n\r\n";
               if ((string) $result->changeIssueVoucherNumber !== "") {
                   $msg.= "���������� ����� �� ����� ��������� �������.\r\n";
                   $msg.= "����� �������: ".$result->changeIssueVoucherNumber."\r\n";
                   $msg.= "�����: ".$result->changeIssueAmount." ".$result->changeIssueVoucherCurr."\r\n";
                   $msg.= "������������ ��: ".$result->changeIssueExpiryDate."\r\n";
               }
               $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� www.okwm.com.ua\r\n";
               $title = "������ $db_InSum $db_InMoney �������.";
               $res_mail = SendMail ($from, $title, $msg, $user_mail);

               // �������� ����������� ����� WMZ ��� WME � ����� � �����
               //SetGoodAmount ($db_InSum, $db_InMoney);
               break;
            } else {
               // ������ ��� � ����
               $msg = "������ ������ $Contract_ID �������, �� �� �������� � ����.\n\r";
               $msg.= "������ $PaymentID\r\n";
               $msg.= $result->ukashTransactionId." - ����� ��������� Ukash\r\n";
               if ((string) $result->changeIssueVoucherNumber !== "") {
                   $msg.= "���������� ����� �� ����� ��������� �������.\r\n";
                   $msg.= "����� �������: ".$result->changeIssueVoucherNumber."\r\n";
                   $msg.= "�����: ".$result->changeIssueAmount." ".$result->changeIssueVoucherCurr."\r\n";
                   $msg.= "������������ ��: ".$result->changeIssueExpiryDate."\r\n";
               }
               // �������� ������, ��� ������ ������, ������ ��� � ����.
               $m_title = $Contract_ID.". ������ $db_InMoney �������, ������ ��� � ����!";
               $res_mail = SendMail ($from, $m_title, $msg);
               if (!$res_mail)
                   logger ($res_mail, "res_mail=$res_mail ������ $db_InMoney ��������, ����� �� ������������.");
            }
            break;
         } elseif ($result->txCode == 1) {
            // Declined
            // Redemption unsuccessful
            MessageToDiv ("������ �� ��������. ����� ������� Ukash: Declined.");
            $sql = "UPDATE Contract SET
                      Payment_Status = '-1',
                      Error_Pay = 'Declined'
                    WHERE
                      Payment_ID = '$PaymentID'";
            ExecSQL ($sql, $row);
            if ($row) {
               // ���������� ��������� ������
               $msg = "������ �� ������ (Decline).\r\n";
               $msg.= "$db_InSum Ukash EUR - ����� ������� \r\n";
               $msg.= "$vNumber - ����� ������� \r\n";
               $msg.= "$vValue - ������� \r\n";
               // �������� ������, ��� ������ �� ������, ���� ������.
               $m_title = $Contract_ID.". ������ Ukash �� ������.";
               $res_mail = SendMail ($from, $m_title, $msg);
               if (!$res_mail)
                  logger ($res_mail, "res_mail=$res_mail ������ ������ $PaymentID ($db_InSum Ukash) �� ��������, ����� �� ������������.");
            }
            break;
         } elseif ($result->txCode == 99) {
            // Failed
            // An error occurred during the processing of the transaction hence the system
            // could not successfully complete the redemption of the voucher.
            MessageToDiv ("������ ��������� �� ����� ��������� �������.<br />������� �� ������ ������� ��������� ��������.<br />".$result->errDescription);
            $sql = "UPDATE Contract SET
                      Payment_Status = '-1',
                      Error_Pay = '".$result->errDescription."'
                    WHERE
                      Payment_ID = '$PaymentID'";
            ExecSQL ($sql, $row);
            if ($row) {
               // ���������� ��������� ������
               $msg = "������ ��� �������� �������.\r\n";
               $msg.= "errCode: ".$result->errDescription.", errDescription:".$result->errDescription."\r\n";
               $msg.= "$db_InSum Ukash EUR - ����� ������� \r\n";
               $msg.= "$vNumber - ����� ������� \r\n";
               $msg.= "$vValue - ������� \r\n";
               // �������� ������, ��� ������ �� ������
               $m_title = $Contract_ID.". ������ Ukash �� ������.";
               $res_mail = SendMail ($from, $m_title, $msg);
               if (!$res_mail)
                  logger ($res_mail, "res_mail=$res_mail ������ ������ $PaymentID ($db_InSum Ukash EUR) �� ��������, ����� �� ������������.");
               // ��������� ������� �� ������
               $msg = "������������!\r\n";
               $msg.= "��� �������� ������� Ukash ��������� ������.\r\n";
               $msg.= "������ Ukash ������ �������� ������:\r\n";
               $msg.= "errCode - ".$result->errDescription.", errDescription - ".$result->errDescription."\r\n";
               $msg.= "$db_InSum Ukash EUR - ����� ������� \r\n";
               $msg.= "$vNumber - ����� ������� \r\n";
               $msg.= "$vValue - ������� \r\n";
               $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� www.okwm.com.ua\r\n";
               // �������� ������, ��� ������ �� ������, ���� ������.
               $m_title = $Contract_ID.". ������ Ukash �� ������.";
               $res_mail = SendMail ($from, $m_title, $msg);
               $title = $Contract_ID.". ������ $db_InSum Ukash EUR �� �������!";
               $res_mail = SendMail ($from, $title, $msg, $user_mail);
            }
            break;
         } else {
            // ����������� ��� txCode
            MessageToDiv ("����������� ��� ��������!<br>��������� � ���������������.");
            $sql = "UPDATE Contract SET
                      Payment_Status = '-1'
                    WHERE
                      Payment_ID = '$PaymentID'";
            ExecSQL ($sql, $row);
            if ($row) {
               // ���������� ��������� ������
               $msg = "������ $Contract_ID.\r\n";
               $msg.= "������ ��� �������� ������� Ukash.\r\n";
               $msg.= "$db_InSum Ukash - ����� ������� \r\n";
               $msg.= "������ ����� �������:\r\n";
               $msg.= "$resp\r\n";
               // �������� ������, ��� ������ ������ �������, ������ ���������.
               $m_title = $Contract_ID.". ����������� ����� ������� Ukash ��� �������� �������.";
               $res_mail = SendMail ($from, $m_title, $msg);
               if (!$res_mail)
                  logger ($res_mail, "res_mail=$res_mail ����������� ����� ������� Ukash ��� �������� ������� Ukash, ����� �� ������������.");
            }
            break;
         }
      } while (1);
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
      // $row != 1 (������ �������� ��� ���������!)
	   $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID'";
	   OpenSQL ($sql, $row, $res);
	   if ($row == 1) {
	      // ������ ���� � ����
	      $row_rec = NULL;
	      GetFieldValue ($res, $row_rec, "Autorization_Time", $db_Autorization_Time , $IsNull);
	      GetFieldValue ($res, $row_rec, "Delivery_Status", $db_Delivery_Status , $IsNull);
	      GetFieldValue ($res, $row_rec, "Payment_Status", $db_Payment_Status , $IsNull);
	      // �� ����������� �� �������� �����?
	      if (($db_Autorization_Time != "0")&&($db_Payment_Status=="1")) {
	         if ($db_Delivery_Status == "1") {
	            // ����� ��������!
	            MessageToDiv ("������ ���� �������. ����� ��������.");
	         } elseif ($db_Delivery_Status == "2") {
	            // ������ �������. ����� �����������.
	            MessageToDiv ("������ ���� �������. ����� �����������.");
	         } elseif ($db_Delivery_Status == "0") {
	            // ������ �������. ����� �� ��������.
                // ������ �������� ��������� �������
                include ("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/payment.asp");
	         } else {
	            // ������ ��� �������� ����� (-1)
	            MessageToDiv ("������. ��������� � ���������������");
	         }
	      } elseif ($db_Payment_Status == "2") {
	         // ����� ��� �����������
	         MessageToDiv ("������ �����������.");
	      } elseif ($db_Payment_Status == "-1") {
	         MessageToDiv ("������ ������. ��������� � ���������������.");
	      }
	   }
   }

</script>