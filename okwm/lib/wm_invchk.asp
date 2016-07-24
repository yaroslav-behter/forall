<script language="PHP">
// *****************************************
// ***   �������� ������ ����� Webmoney  ***
// *****************************************
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm.inc");

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

   $check_point = 5; // ���������� �������� ������ �����
   $check_sec   = 8; // ��������� �������� ����� ����������


   // ������� ���� ��� ��������������� ���������
   echo <<<EOT
        <div id="mes" style="width:500;height=100;color=black">�������� ������ �����.</div>
EOT;
   flush();
   // �������� ������ ����� WM
   $PaymentID = SetUserVariable ("PaymentID", 0, 0);
   $key = SetUserVariable ("key", 0, 0);
   // �������� ����������� ������
   if (!HashOk("$PaymentID::", $key)) {
      MessageToDiv ("������ �������� �����! �������� ���������� �� ������ ��������������!<br>");
      exit;
   }
   $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID'";
   OpenSQL ($sql, $row, $res);
   if ($row == 1) {
      // ������ ���� � ����
      $row_rec = NULL;
      GetFieldValue ($res, $row_rec, "ORDER_ID", $db_ORDER_ID, $IsNull);
      GetFieldValue ($res, $row_rec, "Contract_ID", $db_Contract_ID, $IsNull);
      GetFieldValue ($res, $row_rec, "wmid", $db_wmid, $IsNull);
      GetFieldValue ($res, $row_rec, "Autorization_Time", $db_Autorization_Time , $IsNull);
      GetFieldValue ($res, $row_rec, "Delivery_Status", $db_Delivery_Status , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Status", $db_Payment_Status , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Sum", $db_InSum , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Currency", $db_InMoney , $IsNull);
      GetFieldValue ($res, $row_rec, "MAIL", $db_mail, $IsNull);
      $Contract_ID = round($db_Contract_ID*pi());
      $user_mail = base64_decode ($db_mail);
      $wminv_id = $db_ORDER_ID;
      $wmid = $db_wmid;
      $inv_id = round($db_Contract_ID*pi());
      if ($db_InMoney == "WMZ") {
         $purse = "Z";
      } elseif ($db_InMoney == "WME") {
         $purse = "E";
      } elseif ($db_InMoney == "WMR") {
         $purse = "R";
      } elseif ($db_InMoney == "WMU") {
         $purse = "U";
      } else {
        MessageToDiv ("������ ������������ �� Webmoney!");
        exit;
      }
      // �� ����������� �� �������� �����?
      if (($db_Autorization_Time != "0")&&($db_Payment_Status=="1")) {
         if ($db_Delivery_Status == "1") {
            // ����� ��������!
            MessageToDiv ("������ ���� �������. ����� ��������.");
            exit;
         } elseif ($db_Delivery_Status == "2") {
            // ������ �������. ����� �����������.
            MessageToDiv ("������ ���� �������. ����� �����������.");
            exit;
         } elseif ($db_Delivery_Status == "0") {
            // ������ �������. ����� �� ��������.
            MessageToDiv ("������ �������. �������� ��������.");
            include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/payment.asp");
            exit;
         } else {
            // ������ ��� �������� ����� (-1)
            MessageToDiv ("������. ��������� � ���������������");
            exit;
         }
      } elseif ($db_Payment_Status == "2") {
         // ����� ��� �����������
         MessageToDiv ("������ �����������.");
         exit;
      } elseif ($db_Payment_Status == "-1") {
         MessageToDiv ("������ ������. ��������� � ���������������.");
         exit;
      }

      sleep (5);
      // ������������� ���� ������������ ������.
      $sql = "UPDATE Contract SET
                Payment_Status = 2
              WHERE
                (ORDER_ID = '$db_ORDER_ID') AND
                (Delivery_Status = $db_Delivery_Status) AND
                (Payment_ID = '$PaymentID')";
      ExecSQL ($sql, $row);
      if ($row!=1) {
         MessageToDiv ("������ �������� ������. ��������� � ���������������.");
         exit;
      }
      // ������ WM ��� �� ����
      if (($wmid != "")&&($wminv_id != "")&&($inv_id != "")&&($purse != "")) {
         $j = 0;
         do {
            $inv_state = InvCheck($inv_id, $wmid, $wminv_id, $purse);
            //   ��������� ����� $inv_state:
            //     -2 - ������ �������� ���������
            //     -1 - ������
            //      0 - ���� ������
            //      1 - �������, �� ������ �� �������� �� ������� ������� ��������� ������
            //      2 - �������
            if ($inv_state == 2) {
               $sql = "UPDATE Contract SET
                         Autorization_Time = NOW(),
                         ORDER_ID = '$wminv_id',
                         Payment_Status = '1',
                         Payment_Account = '$wmid'
                       WHERE
                         Payment_ID = '$PaymentID'";
               ExecSQL ($sql, $row);
               if ($row) {
                  // �������� �������, ��� ������ �������
                  MessageToDiv ("������ ������� �������!<br>�������� ��������.");
                  // ���������� ��������� ������
                  $msg = "������ ������ $inv_id �������.\r\n";
                  $msg.= "$db_InSum $db_InMoney - ����� ������� \r\n";
                  $msg.= "$wminv_id - ����� ��������� \r\n";
                  $msg.= "$wmid - ������������� ����������� \r\n";
                  // �������� ������, ��� ������ ������ �������, ������ ���������.
                  $m_title = $Contract_ID.". ������ $db_InMoney �������.";
                  $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                  $res_mail = SendMail ($from, $m_title, $msg);
                  if (!$res_mail)
                     logger ($res_mail, "res_mail=$res_mail ������ ������ $PaymentID ($db_InSum $db_InMoney) ��������, ����� �� ������������.");
                  // �������� �����������, ��� ������ �������.
                  $msg = "������������!\r\n";
                  $msg.= "�������� $db_InSum $db_InMoney.\r\n\r\n";
                  $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� www.okwm.com.ua\r\n";
                  $title = "������ $db_InSum $db_InMoney �������.";
                  $res_mail = SendMail ($from, $title, $msg, $user_mail);

                  // �������� ����������� ����� WMZ ��� WME � ����� � �����
                  SetGoodAmount ($db_InSum, $db_InMoney);

                  // ������ �������� ��������� �������
                  include ("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/payment.asp");
                  break;
               } else {
                  // ������ ��� � ����
                  $msg = "������ ������ $inv_id �������, �� �� �������� � ����.\n\r";
                  $msg.= "������ $PaymentID\r\n";
                  $msg.= "$wminv_id - ����� ��������� \r\n";
                  $msg.= "$wmid - WMid ����������� \r\n";
                  // �������� ������, ��� ������ ������, ������ ��� � ����.
                  $m_title = $Contract_ID.". ������ $db_InMoney �������, ������ ��� � ����!";
                  $res_mail = SendMail ($from, $m_title, $msg);
                  if (!$res_mail)
                      logger ($res_mail, "res_mail=$res_mail ������ $db_InMoney ��������, ����� �� ������������.");
               }
               break;
            } elseif ($inv_state == 1) {
               // ������ ���������, �� ���� ������� � ����������
               // �������� �������, ��� ������ ������� � ����������
               MessageToDiv ("������ ������� �������!<br>�������� ��� ��������� ��������������.");
               break;
            } elseif ($inv_state == 0) {
               // ���� ������� ������
               // �������� �������, ��� ������ ��� �� ���������
               MessageToDiv ($check_point-$j." ������ ��� �� ���������!<br>������� ������.");
            } elseif ($inv_state == -1) {
               // ���� ������
               // �������� �������, ��� ���� ������
               MessageToDiv ("������ �� �������!<br>�� ���������� �� ������.");
               $sql = "UPDATE Contract SET
                         Payment_Status = '-1'
                       WHERE
                         Payment_ID = '$PaymentID'";
               ExecSQL ($sql, $row);
               if ($row) {
                  // ���������� ��������� ������
                  $msg = "����� �� ������ $inv_id.\r\n";
                  $msg.= "$db_InSum $db_InMoney - ����� ������� \r\n";
                  $msg.= "$wmid - ������������� ����������� \r\n";
                  // �������� ������, ��� ������ �� ������, ���� ������.
                  $m_title = $Contract_ID.". ������ $db_InMoney �� �������.";
                  $res_mail = SendMail ($from, $m_title, $msg);
                  if (!$res_mail)
                     logger ($res_mail, "res_mail=$res_mail ������ ������ $PaymentID ($db_InSum $db_InMoney) �� ��������, ����� �� ������������.");
               }
               break;
            } else if ($inv_state == -2) {
               // ������ �������� �����
               MessageToDiv ("������ �������� ������!<br>��������� � ���������������.");
               $sql = "UPDATE Contract SET
                         Payment_Status = '-1'
                       WHERE
                         Payment_ID = '$PaymentID'";
               ExecSQL ($sql, $row);
               if ($row) {
                  // ���������� ��������� ������
                  $msg = "������ �������� ������ ����� ������ $inv_id.\r\n";
                  $msg.= "$db_InSum $db_InMoney - ����� ������� \r\n";
                  $msg.= "$wmid - ������������� ����������� \r\n";
                  // �������� ������, ��� ������ ������ �������, ������ ���������.
                  $m_title = $Contract_ID.". ������ $db_InMoney �� �������. ������ ����� �� ���������.";
                  $res_mail = SendMail ($from, $m_title, $msg);
                  if (!$res_mail)
                     logger ($res_mail, "res_mail=$res_mail ������ ������ $PaymentID ($db_InSum $db_InMoney) ���������, ����� �� ������������.");
               }
               break;
            }

            // �������� N ���.
            sleep($check_sec);
            if (connection_aborted()) {
               // ���������� ����� ���������
               $echo_flag = false;
            }
            $j++;
         } while ($j < $check_point);
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
        // ���� ������ ������! (wmid, purse, � ����� WM, � ����� OKWM)
        MessageToDiv ("������ �������� ������!");
      }
   } else {
      // $row != 1 (������ ����������� � ����!)
      MessageToDiv ("������ �������� ������!");
   }

</script>