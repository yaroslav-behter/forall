<script language="PHP">
// *****************************************
// ***   �������� ������ Z-PAYMENT       ***
// *****************************************
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");

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
        <div id="mes" style="width:1200;height=100;color=black">$msg109</div>
EOT;
   flush();
   // �������� ������ e-gold
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
      GetFieldValue ($res, $row_rec, "ORDER_ID", $db_ORDER_ID, $IsNull);                    // Batch
      GetFieldValue ($res, $row_rec, "Contract_ID", $db_Contract_ID, $IsNull);              // ����� ������
      GetFieldValue ($res, $row_rec, "Autorization_Time", $db_Autorization_Time , $IsNull); // ����� ����������� �������
      GetFieldValue ($res, $row_rec, "Delivery_Status", $db_Delivery_Status , $IsNull);     // ������ �������� ��������� �������
      GetFieldValue ($res, $row_rec, "Payment_Status", $db_Payment_Status , $IsNull);       // ������ ������
      GetFieldValue ($res, $row_rec, "Payment_Sum", $db_InSum , $IsNull);                   // ����� ������
      GetFieldValue ($res, $row_rec, "Payment_Currency", $db_InMoney , $IsNull);            // ������ ������
      if ($db_InMoney != "ZPT") {
         MessageToDiv ("������ ������������ �� Z-PAYMENT!");
         exit;
      }
      // �� ����������� �� �������� �����?
      if ($db_Autorization_Time != "0") {
         if ($db_Delivery_Status == "1") {
            // ����� ��������!
            MessageToDiv ("������ ��� �����������. ����� ��������.");
            exit;
         } elseif ($db_Delivery_Status == "0") {
            // ������ �������. ����� �� ��������.
            if ($db_Payment_Status == "2") {
               // ����� ��� �����������
               MessageToDiv ("������ ��������. ����� �����������.");
               exit;
            } elseif ($db_Payment_Status == "-1") {
               MessageToDiv ("������ ��� �������. ��������� � ���������������.");
               exit;
            }
         } else {
            // ������ ��� �������� ����� (-1)
            MessageToDiv ("������. ��������� � ���������������");
            exit;
         }
      }
      // ������ e-gold ��� �� ����
      if (($db_ORDER_ID != "")&&($db_Autorization_Time != "0")&&($PaymentID != "")) {
         // �������� �������, ��� ������ �������
         MessageToDiv ("������ ������� �������!<br>�������� ��������.");

         // ������ �������� ��������� �������
         include ("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/payment.asp");
         break;
      } else {
         // ���� ������ ������! (wmid, purse, � ����� WM, � ����� OKWM)
         MessageToDiv ("������ �������� ������!");
      }
   } else {
      // $row != 1 (������ ����������� � ����!)
      MessageToDiv ("������ �������� ������!");
   }

</script>