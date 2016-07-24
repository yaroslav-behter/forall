<script language="PHP">
// *************************
// ***   ������� �����   ***
// *************************
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm.inc");

   // ��������� �������
   switch ($inmoney) {
      case "WMZ":
         $purse  = "Z";
         break;
      case "WME":
         $purse  = "E";
         break;
      case "WMR":
         $purse  = "R";
         break;
      case "WMU":
         $purse  = "U";
         break;
   }
   $summ   = $InSum;
   $inv_id = $ContractID;
   if (($outmoney == "NUAH")||($outmoney == "USD")||($outmoney == "EUR")) {
      // �������� ����� �����������������
      if ($city == "����") {         $addr = ADDR_Kiev;
         $protect = 0;
      } elseif ($city == "��������������")
         $addr = ADDR_Dnepr;
      else
         $addr = ADDR_Odessa;
      // ���� ����� WMZ, WME, WMR ��� WMU, �� ���� ��������� 3 ���.
      $protect = 3;
   } else {
      $addr = "���� ����������: $Purse_To";
      // ���� ����� WMZ, WME, WMR ��� WMU �� ��.������, �� ���� ��� ���������.
      $protect = 0;
   }
   $adr    = str_replace("\\'", "'", str_replace("\\\"", "\"", $addr));

   // ������ � ��������� ����������� �����
   $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID' AND NOT (ORDER_ID = '0')";
   OpenSQL ($sql, $row, $res);
   if ($row == 1) {
      // ���� ��� �����������.
      // �������� ������
      $key = EvalHash ("$PaymentID::");
      $GetParam = "?PaymentID=$PaymentID&key=$key";
      echo <<<EOT
         <b>���� ��� �������. <a href="wmk:refresh" title="���������� ����������">��������</a> ���������� � Webmoney Keeper.</b><br>
         <b><a href="wmk:display?window=Invoices_In&page=1&BringToFront=Y">���������� �������� ����� � Webmoney Keeper Classic</a>.</b><br>
         <iframe src="robot.php$GetParam" name="ROBOT" frameborder="NO" width=500 border="0" scrolling="NO" onLoad="window.status='������';">�������� �����</iframe>
EOT;

   } else {
      // ���� ��� �� ��� �������
      if (($purse == "")||($WMid == "")||
          ($summ == "")||($inv_id == "")) {
         // ������ �������� ������
         $wminvc_n = -1;
         $err = "������ ������� �����!";
      } else {
         // ���������� �������� ����� �� ����������� �� 14.01.2006 �.
         $dsc_str = "$ContractID.".chr(13);

         $dsc_str.= "$summ WM$purse => $OutSum $o. ";
         if (($outmoney == "NUAH")||($outmoney == "USD")||($outmoney == "EUR")) {
            // ����� �� ��������
            if (isset($city)) $dsc_str.= "$city ";
            $dsc_str.= "$lastname $firstname $midlename $passport.".chr(13);
         } elseif (($outmoney == "BFU")||($outmoney == "PSU")||($outmoney == "PCB")) {
            // ����� �� ��������
            $dsc_str.= "$lastname $firstname $midlename $passport.".chr(13);
            if ($outmoney == "BFU")
                $dsc_str.= "Betfair $Purse_To.".chr(13);
            if ($outmoney == "PSU")
                $dsc_str.= "Pokerstars $Purse_To.".chr(13);
            if ($outmoney == "PCB")
                $dsc_str.= "��������� $Purse_To.".chr(13);
         } elseif (($outmoney == "P24US")||($outmoney == "P24UA")) {
            // ����� �� ����������
            $dsc_str.= "$lastname $firstname $midlename $passport.".chr(13);
            $dsc_str.= "���������� $Purse_To.".chr(13);
         } else {
            // �������������� �����
            $dsc_str.= "����(�������) ���������� $Purse_To ";
         }
         $dsc_str.= "www.okwm.com.ua";
         $dsc = str_replace("\\'", "'", str_replace("\\\"", "\"", $dsc_str));
         // ����� ��������� ������� ������ wm ��� ������� �����
         list($wminvc_n, $err) = InvCreate($WMid, $summ, $inv_id, $dsc, $adr, $purse, $protect);
      }
      // ����� ����������
      if ($wminvc_n>0)
      { // ���� ������� �������. ����� ����� $wminvc_n
        // ������� � ���� ����� ����� � ������� WM � WMid �����������
        $sql = "UPDATE Contract SET
                  ORDER_ID = '$wminvc_n'
                WHERE
                  Payment_ID = '$PaymentID'";
        ExecSQL ($sql, $row);

        // �������� ������
        $key = EvalHash ("$PaymentID::");
        $GetParam = "?PaymentID=$PaymentID&key=$key";
        echo <<<EOT
              <b>���� ������� �������!</b>
              <table>
                <tr>
                  <td colspan="2">��� ������� ������ ���� �������.<br>
                  ��� ������ ���� �� ������ ������.<br>
                  <a href="wmk:refresh" title="���������� ����������">��������</a> ���������� � Webmoney Keeper Classic.
                  ������ <a href="wmk:display?window=Invoices_In&page=1&BringToFront=Y"> �������� ������</a> � Webmoney Keeper Classic.</td>
                </tr>
              </table>

         <iframe src="robot.php$GetParam" name="ROBOT" frameborder="NO" width=500 border="0" scrolling="NO" onLoad="window.status='������';">�������� ������</iframe>
EOT;
      } else {
        // ������ ������� �����. ��������� � ������� ��� ���������� �����.
        echo <<<EOT
              <b>������ ������� �����!</b>
              <table>
                <tr>
                  <td colspan="2">��������� ������ ��� �������� ��� �����. ���������� ��� ���, ��� ��������� � ���������������.</td>
                </tr>
                <tr>
                  <td>������:</td>
                  <td>$err</td>
                </tr>
              </table>
EOT;
      }
   }

</script>