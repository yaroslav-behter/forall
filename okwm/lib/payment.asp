<?
// ******************************
// ***   ���������� ������    ***
// ******************************
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/verifysum.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm.inc");

   $AutoCurrency = array("WMZ", "WME", "WMR", "WMU", "UKSH", "YAD", "P24UA");
   // ������� ������
   $PaymentID = SetUserVariable ("PaymentID", 0, 0);
   $key = SetUserVariable ("key", 0, 0);
   // �������� ����������� ������
   if (!HashOk("$PaymentID::", $key)) {
      MessageToDiv ("������ �������� �����! �������� ���������� �� ������ ��������������!<br>");
      exit;
   }

   // ��������� �������
   sleep (5);
   mysql_query("LOCK TABLES contract, goods WRITE");
   $sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID'";
   OpenSQL ($sql, $row, $res);
   if ($row == 1) {
      // ������ ���� � ����
      $row_rec = NULL;
      GetFieldValue ($res, $row_rec, "ORDER_ID", $ORDER_ID, $IsNull);
      GetFieldValue ($res, $row_rec, "Contract_ID", $Contract_ID, $IsNull);
      GetFieldValue ($res, $row_rec, "Autorization_Time", $Autorization_Time , $IsNull);
      GetFieldValue ($res, $row_rec, "Delivery_Status", $Delivery_Status , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Status", $Payment_Status , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Sum", $InSum , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Currency", $InMoney , $IsNull);
      GetFieldValue ($res, $row_rec, "Payment_Account", $From_Account , $IsNull);
      GetFieldValue ($res, $row_rec, "Contract_Terms", $FullDescription , $IsNull);
      GetFieldValue ($res, $row_rec, "GOOD_AMOUNT", $OutSum , $IsNull);
      GetFieldValue ($res, $row_rec, "GOOD_ID", $OutMoneyID , $IsNull);
      GetFieldValue ($res, $row_rec, "Purse_To", $Purse_To , $IsNull);
      GetFieldValue ($res, $row_rec, "wmid", $wmid , $IsNull);
      GetFieldValue ($res, $row_rec, "MAIL", $encode_email , $IsNull);
      GetFieldValue ($res, $row_rec, "IP", $IP , $IsNull);
      $Contract_ID = round($Contract_ID*pi());
      $user_mail = base64_decode($encode_email);

      // ������� �� ��������?
      if (($Autorization_Time != "0")&&($ORDER_ID != "0")) {
         if ($Delivery_Status == "1") {
            // ����� ��������!
            MessageToDiv ("����� ��������.");
            exit;
         } elseif ($Delivery_Status == "-1") {
            MessageToDiv ("������. ��������� � ���������������.");
            exit;
         } elseif ($Delivery_Status == "2") {
            MessageToDiv ("������� ��� �����������.");
            exit;
         } elseif ($Delivery_Status == "0") {
            if ($Payment_Status == "2") {
                 // ������ �������. ����� �����������
                 MessageToDiv ("������ ��� �����������.");
                 exit;
            } elseif ($Payment_Status == "-1") {
                 MessageToDiv ("������ ������.<br>��������� � ���������������.");
                 exit;
            } elseif ($Payment_Status == "1") {
               sleep (3);
               // ������������� ���� ������������ ������.
               $sql = "UPDATE Contract SET
                         Delivery_Status = 2
                       WHERE
                         (ORDER_ID = '$ORDER_ID') AND
                         (Delivery_Status = $Delivery_Status) AND
                         (Payment_ID = '$PaymentID')";
               ExecSQL ($sql, $row);
               if ($row) {
                  // ���������� ���� ���������� �������� ������.
                  $sql = "SELECT * FROM goods WHERE  GOODS_ID = '$OutMoneyID'";
                  OpenSQL ($sql, $row, $res);
                  if ($row != 1) {
                     // ��� ���������� ������ ���������
                     MessageToDiv ("��������� ������ �� ������������.");
                     exit;
                  }
                  $row_rec = NULL;
                  GetFieldValue ($res, $row_rec, "GOODS_NAME", $OutMoney , $IsNull);
                  GetFieldValue ($res, $row_rec, "GOODS_AMOUNT", $SumInBank , $IsNull);
                  // �������� ����� ��� Betfair � Pokerstars
                  if (in_array($OutMoney, array("PSU","BFU"))) {
                       // ����� ������������ �� ��������. ������� � �����������������.
                       MessageToDiv ("�� ��������� ���� � ������� ������� Betfair ��� PokerStars.<br />".
                       				 "������ �������������� � 10-00 �� 18-00 �� ������<br />".
                       				 "� � 12-00 �� 14-00 �� ��������. ����������� - ��������.<br />".
                       				 "��������� � ��������������� ��� ���������� ������.");
                       exit;
                  } //������ �������, �������� ��������
                  if (in_array($OutMoney, array("GMU"))) {
                       // ����� ������������ �� ����� Globalmoney. ������� ������ �������������
                       MessageToDiv ("������ �������, �������� ��������.");
                       exit;
                  }
                  // �������� ����� ��� �������� (WMZ, WME, WMR, YAD)
                  if (!in_array($OutMoney, $AutoCurrency)) {
                       if (in_array($OutMoney, array("PCB","SBRF"))) {
                           // ����� �� ����/����� ����������
                           MessageToDiv ("��� ������ ������� <a href=\"".DOMAIN_HTTP."/banks.asp\">�� ���������� ����/�����</a>:<br />".
                                         "- �� �������, ���������� �� 16-00, ���������� ���������� � ������� 2 �����;<br />".
                                         "- ������, ���������� ����� 16-00, �������������� �� ��������� ���� �� 12-00.");
                           exit;
                       } elseif (in_array($OutMoney, array("P24US","P24UA"))) {
                           // ����� �� ����/����� �����������
                           MessageToDiv ("��� ���������� ������ ��������� � ���������������� ����� � ������� �����.<br />������ ��������������<br />� 11-00 �� 19-00�� ������<br />� � 12-00 �� 14-00 �� �������� ����.");
                           exit;
                       } else {
                           // ����� ������������ �� ��������. ������� � �����������������.
                           MessageToDiv ("����� ���������� � ����� ��� ������ �������.<br />��� ���� ���������� ����� ��������� ��������.");
                           exit;
                       }
                  }
                  // �������� ����� �� ����� � �����
                  if ($SumInBank < $OutSum) {
                       // ������ ������������ � ������ ������ ��� �������
                       MessageToDiv ("��������� � ��������������� ��� ���������� ������.");
                       exit;
                  }
                  // For hacker !!!
                  if ($InMoney == $OutMoney) {
                       // ������ ������������ � ������ ������ ��� �������
                       MessageToDiv ("��� ������ ��������� ������. ��������� � ���������������.");
                       exit;
                  }
                  // �������� �������� � ��������� ���� � ����������� �� ������ �����
                  if (!VerifySum ($InSum, $InMoney, $OutSum, $OutMoney, $NewInSum, $NewOutSum, "sell")) {
                       // ���� ����� ����������� ���������. ����� �� ���������.
                       MessageToDiv ("����� ������� ��������. �������� ��������� ���� ������.<br>��������� � ��������������� ��� ���������� ������.");
                       exit;
                  }
                  // ����������� ���� ������ (Webmoney, e-gold, PayCash)
                  if (($OutMoney == "WMZ")||($OutMoney == "WME")||($OutMoney == "WMR")||($OutMoney == "WMU")) {
                     // *********************************************
                     // ������� Webmoney
                     // *********************************************

                     $purse = substr($OutMoney, -1);
                     // ��������� �������
                     switch ($InMoney) {
                        case "WMZ":
                        case "WME":
                        case "WMR":
                        case "WMU":
                           $In_PaySys = "Webmoney";
                           $In_Currency = $InMoney;
                           break;
                        case "YAD":
                           $In_PaySys = "������.������";
                           $In_Currency = "���";
                           break;
                        case "UKSH":
                           $In_PaySys = "Ukash voucher";
                           $In_Currency = "EUR";
                           break;
                     }
                     $dsc_str = "������ � $In_PaySys, ����� $InSum $In_Currency, ����(�������) $From_Account.";
                     $dsc_str.= " ������� �� �����! www.okwm.com.ua";
                     $dsc = str_replace("\\'", "'", str_replace("\\\"", "\"", $dsc_str));
                     // ��������� ������� ����� � $OutSum
                     $OutSum = floatval($OutSum);
                     $trn_id = $Contract_ID."-".date("dmYHis", mktime());
                     // ����� ��������� ������� ������ wm
                     list($wmtrn_n, $err) = TransCreate($Purse_To, $OutSum, $Contract_ID+mktime(), $dsc, $purse);

                     // ����� ����������
                     if ($wmtrn_n>0) {
                          // ������������� ���� �������� � ��������� ������
                          $sql = "UPDATE Contract SET
                                    Delivery_Status = 1,
                                    ORDER_ID_OUT = '$wmtrn_n'
                                  WHERE
                                    Payment_ID = '$PaymentID'";
                          ExecSQL ($sql, $row);
                          MessageToDiv ("����� ������� ��������.");

                         // ������ ���������� ����� �� ����� � �����
                         SetGoodAmount (-round($OutSum + $OutSum * 0.008), $OutMoney);
                         // �������� �����������, ��� ������� �����������.
                         $msg = "������������!\r\n";
                         $msg.= "$OutSum $OutMoney ����������.\r\n\r\n";
                         $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� www.okwm.com.ua\r\n";
                         $title = "������� $OutSum $OutMoney �����������.";
                         $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                         $res_mail = SendMail ($from, $title, $msg, $user_mail);
                         // �������� admin, ��� ������� WMZ ��� WME �����������.
                         $title = $Contract_ID.". ".$title;
                         $msg = "������ $Contract_ID ���������.\r\n$OutSum $OutMoney ����������.\r\n\r\n";
                         $msg.= "����� ���������: $wmtrn_n\r\n";
                         $res_mail = SendMail ($from, $title, $msg);
                         include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
                     } else {
                          $sql = "UPDATE Contract SET
                                    Delivery_Status = -1,
                                    Error_Pay = '$err'
                                  WHERE
                                    Payment_ID = '$PaymentID'";
                          ExecSQL ($sql, $row);
                          MessageToDiv ("������ �������� : $err");
                          exit;
                     }
                  } elseif ($OutMoney == "YAD") {
                     // *********************************************
                     // �������� ������������ ����� ���������� ������ (41001 - PCUAH)
                     // *********************************************

                     //if (substr($Purse_To, 0, 5) != "41001") {
                     if (substr($Purse_To, 0, 5) != "41001") {
                           MessageToDiv ("����� �� ��������! ������ � ������ ����� ���������� ������.�����.<br>�� ������� $Purse_To.</br>����� ������ ���������� � 41001<br>��������� � ���������������.");
                           $sql = "UPDATE Contract SET
                                    Delivery_Status = -1,
                                    Error_Pay = '������������ ���� ���������� ������.�����'
                                   WHERE
                                    Payment_ID = '$PaymentID'";
                           ExecSQL ($sql, $row);
                           exit;
                     }

                     require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/pc/config.inc.php");
                     // ������� Yandex RUR
                     // ���������� ������� ����������:
                     $RequestParams["FunctionName"] = "RequestDirectPayment";
                     $RequestParams["UserID"] = "2403662437";
                     $RequestParams["PaymentSum"] = $OutSum;
                     $RequestParams["PaymentCurrencyCode"] = "643";
                     $RequestParams["AccountKey"] = $Purse_To;
                     switch ($InMoney) {
                        case "WMZ":
                        case "WME":
                        case "WMR":
                        case "WMU":
                           $In_PaySys = "Webmoney";
                           $In_Currency = $InMoney;
                           break;
                        case "PCB":
                           $In_PaySys = "��� �� ���������";
                           $In_Currency = "USD";
                           break;
                        case "UKSH":
                           $In_PaySys = "Ukash voucher";
                           $In_Currency = "EUR";
                           break;
                     }
                     $RequestParams["ShortDescription"] = "$InSum $In_Currency $In_PaySys=>$OutSum ������.�����";
                     $RequestParams["Destination"] = "����� �������� ����� \"OKWM\" ����������� ���������� ����� $Contract_ID\r\n";
                     $RequestParams["Destination"].= $FullDescription;
                     $RequestParams["PayerRegData"] = $PaymentID;
                     $RequestParams["InactivityPeriod"] = "60";
                     // �������������� �������
                     $RequestDP = $WA->RequestDirectPayment($RequestParams);

                     if ($RequestDP["ErrorCode"]!=1) {
                         // ������. ������ ���������� ������
                         $err = $RequestDP["ErrorCodeStr"];
                         MessageToDiv ("����� �� ��������.<br>��������� � ���������������.");
                         $sql = "UPDATE Contract SET
                                    Delivery_Status = -1,
                                    Error_Pay = '$err'
                                 WHERE
                                    Payment_ID = '$PaymentID'";
                         ExecSQL ($sql, $row);
                     } else {                         // ���������� ����� ���������� �������
                         $RequestParams["FunctionName"] = "ProcessPayment";
                         $RequestParams['PaymentTime'] = $RequestDP['PaymentTime'];
                         $RequestParams["OperationTimeOut"] = "5000";
                         $RequestParams["CancelFailedPayment"] = "0"; // �� ����������� ������ �������������� �������
                         $PPayment = $WA->ProcessPayment($RequestParams);

                         if ($PPayment["ErrorCode"] == 1) {
                             // �������� ��������� �������. ������ ������� ��������� � ���������� $PPayment["Status"]
                             $OrderID = $RequestDP['PaymentTime'];
                             if ($PPayment['Status'] == 4) {
                                 // ��������� ��������� ��������� ���������� �������
                                 $sql = "UPDATE Contract SET
                                           Delivery_Status = 1,
                                           ORDER_ID_OUT = '$OrderID'
                                         WHERE
                                           Payment_ID = '$PaymentID'";
                                 ExecSQL ($sql, $row);
                                 MessageToDiv ("����� ������� ��������.<br>��������� ������� �� ��� e-mail.<br>����� �������: $OrderID");
                                 // ������ ���������� ����� �� ����� � �����
                                 SetGoodAmount (-$OutSum, $OutMoney);
                                 // �������� �����������, ��� ������� �����������.
                                 $msg = "������������!\r\n";
                                 $msg.= "$OutSum ������.����� ����������.\r\n\r\n";
                                 $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� www.okwm.com.ua\r\n";
                                 $title = "������� $OutSum ������.����� �����������.";
                                 $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                                 $res_mail = SendMail ($from, $title, $msg, $user_mail);
                                 // �������� admin, ��� ������� ������.����� �����������.
                                 $title = $Contract_ID.". ".$title;
                                 $msg = "������ $Contract_ID ���������.\r\n$OutSum ������.����� ����������.\r\n\r\n";
                                 $msg.= "����� ���������: $OrderID\r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                                 include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
                             } else {                                 // ��������� ������ ���������� �������
                                 $err = $PPayment['Status']."-".$PPayment['StatusStr'];
                                 $sql = "UPDATE Contract SET
                                           Delivery_Status = -1,
                                           ORDER_ID_OUT = '$OrderID',
                                           Error_Pay = '$err'
                                         WHERE
                                           Payment_ID = '$PaymentID'";
                                 ExecSQL ($sql, $row);
                                 MessageToDiv ("����� �� ��������.<br>��� ���������� ������� �������� ������.<br>����� ������� $OrderID �������� ���������������.");
                                 // �������� admin, ��� ���������� ������.����� �� ������.
                                 $title = $Contract_ID.". ������� $OutSum ������.����� ����������� �������";
                                 $msg = "������ $Contract_ID �� ���������.\r\n$OutSum ������.����� �� ����������.\r\n\r\n";
                                 $msg.= "��� ���������� ������� �������� ������.\r\n";
                                 $msg.= "������ ������� - ${PPayment['Status']} (${PPayment['StatusStr']}).\r\n";
                                 $msg.= "����� �������: $OrderID\r\n";
                                 $msg.= "��������� ������ ������� ���� �������� ���.\r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                             }
                         } else {                             // �������� ������ ��� ��������� ��� ���������
                             // ��������� ������ ���������� �������
                             $err = $PPayment['ErrorCodeStr'];
                             $OrderID = $RequestDP['PaymentTime'];
                             $sql = "UPDATE Contract SET
                                       Delivery_Status = -1,
                                       ORDER_ID_OUT = '$OrderID',
                                       Error_Pay = '$err'
                                     WHERE
                                       Payment_ID = '$PaymentID'";
                             ExecSQL ($sql, $row);
                             MessageToDiv ("����� �� ��������.<br>��� ���������� ������� �������� ������.<br>����� ������� $OrderID �������� ���������������.");
                             // �������� admin, ��� ���������� ������.����� �� ������.
                             $title = $Contract_ID.". ������� $OutSum ������.����� ����������� �������";
                             $msg = "������ $Contract_ID �� ���������.\r\n$OutSum ������.����� �� ����������.\r\n\r\n";
                             $msg.= "��� ���������� ������� �������� ������ - $err.\r\n";
                             $msg.= "����� �������: $OrderID\r\n";
                             $msg.= "��������� ������ ������� ���� �������� ���.\r\n";
                             $res_mail = SendMail ($from, $title, $msg);
                         }
                     }
                  } elseif ($OutMoney == "UKSH") {                     // Issue UKASH Voucher EURO
                     $vNumber = "6337181631273230872"; // ����� Ukash  633718   code product - 163, ��������� �� �����������
                     $baseCurr = "EUR";
                     require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/uk.inc");
                     $resp = IssueVoucher($vNumber, $OutSum, $baseCurr);

                     if (!$resp) {
					    MessageToDiv ("��� ������ ��������� ������. ��������� � ���������������.");
                        exit;
					 }

					 $result = simplexml_load_string(html_entity_decode($resp));
					 $result = $result->UKashTransaction;
					 if ($result->txCode == 0){					      $ukshtrn_id = $result->ukashTransactionId;
					      // $result->transactionId;
					      // $result->txDescription
                          $sql = "UPDATE Contract SET
                                    Delivery_Status = 1,
                                    ORDER_ID_OUT = '$ukshtrn_id'
                                  WHERE
                                    Payment_ID = '$PaymentID'";
                          ExecSQL ($sql, $row);
						  $voucherIssueMessage.= "<table>";
						  $voucherIssueMessage.= "<tr><td rowspan=4><img src='img/ukash-logo.gif'></td><td>Issue Voucher Number:</td><td><b>{$result->IssuedVoucherNumber}</b></td></tr>";
						  $voucherIssueMessage.= "<tr><td>Issue Voucher Value:</td><td>{$result->IssuedAmount} {$result->IssuedVoucherCurr}</td></tr>";
						  $voucherIssueMessage.= "<tr><td>Issue Voucher Expiry Date:</td><td>{$result->IssuedExpiryDate}</td></tr>";
						  $voucherIssueMessage.= "<tr><td>Date:</td><td>".date('H:i d-m-Y')."</td></tr>";
						  $voucherIssueMessage.= "<tr><td colspan=3><small>������� � ������������ � ������������������� ��������� �����������. �������� <a target=_blank href=http://www.ukash.com>www.ukash.com</a></small></td></tr>";
						  $voucherIssueMessage.= "</table>";
                          MessageToDiv ($voucherIssueMessage);

                          // ������ ���������� ����� �� ����� � �����
                          SetGoodAmount (-$OutSum, $OutMoney);
                          // �������� �����������, ��� ������� �����������.
                          $msg = "������������!\r\n";
                          $msg.= "������ UKash ������ �������.\r\n";
                          $msg.= "Voucher Number: {$result->IssuedVoucherNumber}\r\n";
                          $msg.= "Voucher Value: {$result->IssuedAmount} {$result->IssuedVoucherCurr}\r\n";
                          $msg.= "Voucher Expiry Date: {$result->IssuedExpiryDate}\r\n\r\n";
                          $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� www.okwm.com.ua\r\n";
                          $title = "������ UKash $OutSum EURO ������.";
                          $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                          $res_mail = SendMail ($from, $title, $msg, $user_mail);
                          // Send Webmoney Message
                          $wmmsg = "Voucher Number: {$result->IssuedVoucherNumber}\r\n";
                          $wmmsg.= "Voucher Value: {$result->IssuedAmount} {$result->IssuedVoucherCurr}\r\n";
                          $wmmsg.= "Voucher Expiry Date: {$result->IssuedExpiryDate}\r\n\r\n";
                          SendMsg($wmid,$wmmsg);
                          // �������� admin, ��� ������� Ukash �����������.
                          $title = $Contract_ID.". ".$title;
                          $msg = "������ $Contract_ID ���������.\r\n������ UKash $OutSum EUR ������.\r\n\r\n";
                          $msg.= "����� ���������: $ukshtrn_id\r\n";
                          $res_mail = SendMail ($from, $title, $msg);
                          include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
					 } else {
					    if ($result->txCode == 1){					        $err = "Error issue: ".$result->txDescription."; ".$result->errDescription;
			            } else {			                $err = "Error issue: (code ".$result->errCode.") ".$result->errDescription;
			            }
                        $sql = "UPDATE Contract SET
                                    Delivery_Status = -1,
                                    Error_Pay = '$err'
                                  WHERE
                                    Payment_ID = '$PaymentID'";
                        ExecSQL ($sql, $row);
                        MessageToDiv ("������ ��� �������� ������� UKash. $err");
                        exit;
					 }
                  } elseif ($OutMoney == "P24UA") {                     require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/matrix_api.asp");
                     $p24 = new matrix();
                     $check_result = $p24->checkCard($Purse_To);
                     if (!$check_result[0]) {
                         // ������ �� ���� �� ������ ����, �.�. ����� �������� ����������� ��� ����� ����������� ������
                         // ����������� ������, ��� ����� ��������� ����� �������� �����������
                         $err = $p24->getErrMessage();
                         if (!$check_result[0]) {
                            $sql = "UPDATE Contract SET
                                        Delivery_Status = -1,
                                        Error_Pay = '$err'
                                      WHERE
                                        Payment_ID = '$PaymentID'";
                            ExecSQL ($sql, $row);
    					    MessageToDiv ("������ ��� �������� �������� $Purse_To. ".$err);
                            $title = $Contract_ID.". ������� $OutSum ���. �� ������24 ����������� �������.";
                            $msg = "������ $Contract_ID �� ���������.\r\n$OutSum ���. �� ����������.\r\n\r\n";
                            $msg.= "��� �������� ����� ������24 $Purse_To �������� ������ - $err.\r\n";
                            $msg.= "��� ������ ������ ��� �������� ������ �������.\r\n";
                            $msg.= "����������� ������� �������.\r\n";
                            $res_mail = SendMail ($from, $title, $msg);
                            exit;
    					 }
                     } else {                         $resp = $p24->pay($Purse_To, $OutSum, $PaymentID);
                         $OrderID = $p24->pay_id;
                         if ($resp[0]) {                             // ������ ������ � ���������
                             $sql = "UPDATE Contract SET
                                       ORDER_ID_OUT = '$OrderID'
                                     WHERE
                                       Payment_ID = '$PaymentID'";
                             ExecSQL ($sql, $row);
     					     MessageToDiv ("������ ������ � ���������.");
     					     sleep(2);
     					     $status = $p24->checkStatus();
     					     if ($status[0]) {     					         // ������ �������� �������
     					         MessageToDiv ("����� ������� ��������.<br>��������� ������� �� ��� e-mail.<br>����� �������: $OrderID");
                                 $sql = "UPDATE Contract SET
                                           Delivery_Status = 1,
                                           ORDER_ID_OUT = '$OrderID'
                                         WHERE
                                           Payment_ID = '$PaymentID'";
                                 ExecSQL ($sql, $row);
                                 // ������ ���������� ����� �� ����� � �����
                                 SetGoodAmount (-$OutSum, $OutMoney);
                                 // ��������� ��������� ������� � ���������� ������
                                 $msg = "������������!\r\n";
                                 $msg.= "$OutSum ������ ���������� �� ����� �����������.\r\n\r\n";
                                 $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� www.okwm.com.ua\r\n";
                                 $title = "������� $OutSum ��� �� ����� ����������� �����������.";
                                 $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                                 $res_mail = SendMail ($from, $title, $msg, $user_mail);
                                 // �������� admin, ��� ������� ������24 �����������.
                                 $title = $Contract_ID.". ".$title;
                                 $msg = "������ $Contract_ID ���������.\r\n$OutSum ��� ���������� �� ����� �����������.\r\n\r\n";
                                 $msg.= "����� ���������: $OrderID\r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                                 include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
                             } else if ($status[1] == 120) {                                 // ������ ��������� � ���������
                                 MessageToDiv ($status[2]." ������ ��� � ���������.");
                                 // ��������� ��������� ������� � ���������� ������
                                 $msg = "������������!\r\n";
                                 $msg.= "$OutSum ������ ���������� �� ����� �����������.\r\n\r\n";
                                 $msg.= "��� ������ ��������� � ���������.\r\n\r\n";
                                 $msg.= "��������� ��������� ������� �� ������ �� ������ http://www.okwm.com.ua/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::")."\r\n";
                                 $msg.= "�������, ��� ��������������� ������ ��������.\r\n� ���������,\r\n������������� www.okwm.com.ua\r\n";
                                 $title = "������ $OutSum ��� �� ����� ����������� � ���������.";
                                 $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                                 $res_mail = SendMail ($from, $title, $msg, $user_mail);
                                 // �������� admin, ��� ������� ������24 �����������.
                                 $title = $Contract_ID.". ".$title;
                                 $msg = "������ $Contract_ID ���������.\r\n$OutSum ��� ���������� �� ����� �����������.\r\n\r\n";
                                 $msg.= "����� �������: $OrderID\r\n";
                                 $msg.= "������ ��������� � ���������.\r\n\r\n";
                                 $msg.= "��������� ��������� ������� ����� �� ������ http://www.okwm.com.ua/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::")."\r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                                 include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
                             } elseif ($status[1] == 130) {                                 // ������ �������
                                 $err = $p24->getErrMessage();
                                 $sql = "UPDATE Contract SET
                                             Delivery_Status = -1,
                                             Error_Pay = '$err'
                                           WHERE
                                             Payment_ID = '$PaymentID'";
                                 ExecSQL ($sql, $row);
         					     MessageToDiv ("������ ��� �������� ������� �� ����� $Purse_To. ".$err);

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
                                 $title = $Contract_ID.". ������� $OutSum ���. �� ������24 ����������� �������.";
                                 $msg = "������ $Contract_ID �� ���������.\r\n$OutSum ���. �� ����������.\r\n\r\n";
                                 $msg.= "��� ���������� ������ �� ����� ������24 $Purse_To �������� ������ - $err.\r\n";
                                 $msg.= "����� ������� $OrderID.\r\n";
                                 $msg.= "��������� � ���������� �������. \r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                             } else {         					     // ��������� ��������� ��������������
                                 $err = $p24->getErrMessage();
                                 $sql = "UPDATE Contract SET
                                             Delivery_Status = -1,
                                             Error_Pay = '$err'
                                           WHERE
                                             Payment_ID = '$PaymentID'";
                                 ExecSQL ($sql, $row);
         					     MessageToDiv ("������ ��� �������� ������� �� ����� $Purse_To. ".$err);
                                 $title = $Contract_ID.". ������� $OutSum ���. �� ������24 ����������� ����������� ��������.";
                                 $msg = "������ $Contract_ID �� ���������.\r\n$OutSum ���. �� ����������.\r\n\r\n";
                                 $msg.= "��� ���������� ������ �� ����� ������24 $Purse_To �������� ������ - $err.\r\n";
                                 $msg.= "����� ������� $OrderID.\r\n";
                                 $msg.= "������ ".$status[1]." ???\r\n";
                                 $msg.= "��������� � ���������� �������. \r\n";
                                 $res_mail = SendMail ($from, $title, $msg);
                             }
                         } else {                             // ������
                             $err = $p24->getErrMessage();
                             $sql = "UPDATE Contract SET
                                         Delivery_Status = -1,
                                         Error_Pay = '$err'
                                       WHERE
                                         Payment_ID = '$PaymentID'";
                             ExecSQL ($sql, $row);
     					     MessageToDiv ("������ ��� �������� ������� �� ����� $Purse_To. ".$err);
                             // ��������� ��������� ��������������
                             $title = $Contract_ID.". ������� $OutSum ���. �� ������24 ����������� �������.";
                             $msg = "������ $Contract_ID �� ���������.\r\n$OutSum ���. �� ����������.\r\n\r\n";
                             $msg.= "��� ���������� ������ �� ����� ������24 $Purse_To �������� ������ - $err.\r\n";
                             $msg.= "����� ������� $OrderID.\r\n";
                             $msg.= "��������� � ���������� �������. \r\n";
                             $res_mail = SendMail ($from, $title, $msg);
                         }
                     }
                  }
               }
            } else {
               // ������ �� �������!
               MessageToDiv ("������ �������� �����������.");
               exit;
            }
         }
      } else {
         // ������ �� �������!
         MessageToDiv ("������ �� ��������.");
         exit;
      }
   } else {
      // ������ ��� � ����
      MessageToDiv ("����� ������ ���.");
   }
   // ������������ �������
   mysql_query("UNLOCK TABLES");

</script>