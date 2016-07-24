<?php

	require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
	require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
	require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");

    define('LOGS', "${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/logs/ym/");
    define('LOG_YM_FILE', LOGS.date("Ymd").'_yandex.txt');
    define('LOG_YM_RESULT_FILE', LOGS.date("Ymd").'_res_yandex.txt');
    define(SHOP_ID, "13395");
    define(SCID, "5790");
    define(CURRENCY_PAYCASH, "643");  // REAL RUB
    define(DEBUG, true);

    $conf_merchantEmail = "behter@mail.ru";
    $p = print_r($_POST, true);
    //$r = print_r($_REQUEST, true);
    //$s = print_r($_SERVER, true);
    $body = "REQUEST \n $r \n\n POST\n $p \n\nSERVER\n $s \n\n";
    $body.= "\n\n $customerNumber \n $shopSuccessURL \n $shopFailURL \n";
    @mail($conf_merchantEmail, 'From Yandex.Money request', $body);

    if (($HTTP_SERVER_VARS['REMOTE_ADDR']  != "213.186.119.13") || ($HTTP_SERVER_VARS['HTTP_USER_AGENT'] != "Allmoney")) {
        send_response_xml("checkOrderResponse", "100", "");
        exit;
    }

	$package = $_POST['pkcs7'];
	//$package = GetPKCS7();

	if (strlen($package)==0) {
        // Вывод ошибки входных данных
        send_response_xml("checkOrderResponse", "1000", "");
        die();
    } else {
        // Запись в лог входящего пакета для разрешения спорных вопросов
        error_log(date("Y.m.d H:i:s") . " INPUT YANDEX PKCS7 PACKAGE \n", 3, LOG_YM_FILE);
        error_log(" $package \n", 3, LOG_YM_FILE);
    }

	$req_xml_str = verify($package, YM_CAcert);
    error_log(date("Y.m.d H:i:s") . " XML: $req_xml_str \n", 3, LOG_YM_FILE);
    if (strlen($req_xml_str) == 0) exit; // Проверка подписи прошла с ошибкой. Результат см. в логах

    try {
        $req_xml = new SimpleXMLElement($req_xml_str);
    } catch (Exception $e) {
        // Вывод ошибки разбора XML
        send_response_xml("checkOrderResponse", "200", "");
        die();
    }

    $params = $req_xml->param;
    $check_keys = array('PaymentID', 'Key', 'ContractID', 'sumCurrency', 'scid');
    $param = array();
    foreach ($params as $p) {
        if (isset($p['key'])&&isset($p['val'])&&in_array($p['key'], $check_keys)) {
            $param[(string)$p['key']] = $p['val'];
        }
    }

    $request_type = $req_xml->getName();
    if  ($request_type == "checkOrderRequest") {
        // Проверяем полученые данные и даем разрешение принимать оплату
		$OK = true;
        $check_attr = $req_xml->attributes();
        if (DEBUG) {
            SendMail('OKWM <admin@okwm.com.ua>', '2. From Yandex.Money request', $request_type."\n\n".print_r($req_xml, true), $conf_merchantEmail);
        }

		// проверка оплаты PayCash Яндекс.Денег
		$PaymentID = substr($check_attr->customerNumber, 0, strpos($check_attr->customerNumber, '.'));
		$key = $param['Key'];

		//orderNumber
		// Проверка целостности данных
		if (!HashOk("$PaymentID::", $key)) {		    // Ошибка в номере заявки
		    send_response_xml("checkOrderResponse", "200", "");
		    exit;
		}
		$sql = "SELECT * FROM Contract WHERE Payment_ID = '$PaymentID'";
		OpenSQL ($sql, $row, $res);
	    if ($row == 1) {
		    // заявка есть в базе
		    GetFieldValue ($res, $row_rec, "Contract_ID", $db_Contract_ID, $IsNull);              // Номер заявки
		    GetFieldValue ($res, $row_rec, "Autorization_Time", $db_Autorization_Time , $IsNull); // Врема авторизации платежа
		    GetFieldValue ($res, $row_rec, "Delivery_Status", $db_Delivery_Status , $IsNull);     // Статус доставки ответного платежа
		    GetFieldValue ($res, $row_rec, "Payment_Status", $db_Payment_Status , $IsNull);       // Статус оплаты
		    GetFieldValue ($res, $row_rec, "Payment_Sum", $db_InSum , $IsNull);                   // Сумма оплаты
		    GetFieldValue ($res, $row_rec, "Payment_Currency", $db_InMoney , $IsNull);            // Валюта оплаты
		    GetFieldValue ($res, $row_rec, "Payment_Account", $db_Payment_Account , $IsNull);     // Валюта оплаты
		    $Contract_ID = round($db_Contract_ID*pi());
		    if ($db_InMoney != "YAD") {
		       $OK = false;
               error_log(date("Y.m.d H:i:s") . " Error! InMoney not Yandex.Money.\n", 3, LOG_YM_FILE);
		    }
		    // не оплачивался ли контракт ранее?
		    if (($db_Autorization_Time != "0")||($db_Payment_Status != "0")) {		       $OK = false;
               error_log(date("Y.m.d H:i:s") . " Error! db_Payment_Status!=0 or Autorization_Time!=0 ->($db_Payment_Status, $db_Autorization_Time).\n", 3, LOG_YM_FILE);
		    }
		    if (($check_attr->orderSumCurrencyPaycash != '643')
		    	||($check_attr->orderSumAmount != $db_InSum) || ($check_attr->paymentPayerCode != $db_Payment_Account)
		    	||($check_attr->shopId != SHOP_ID) || ($param['scid'] != SCID) || ($param['ContractID'] != $Contract_ID))
		    {				$OK = false;
				$verify_attr = $check_attr->orderSumAmount." != $db_InSum || ".$check_attr->paymentPayerCode." != $db_Payment_Account || ".
		    		$check_attr->shopId." != SHOP_ID || ".$param['csid']." != SCID || ".$param['ContractID']." != $Contract_ID";
                error_log(date("Y.m.d H:i:s") . " Error in Yandex.Money xml attributes (".print_r($check_attr, true).").\n", 3, LOG_YM_FILE);
                error_log(date("Y.m.d H:i:s") . " $verify_attr \n", 3, LOG_YM_FILE);
			}
	   	} else {	       $OK = false;
	   	}

        if (!$OK) {            // Отказ в приеме оплаты
            if (DEBUG) {
                SendMail('OKWM <admin@okwm.om.ua>', '3. From Yandex.Money request', "ERROR PAYMENT RECIVE.\n\n".print_r($check_attr, true), $conf_merchantEmail);
            }
            send_response_xml("checkOrderResponse", "100", $check_attr->invoiceId, "Error payment data.");
            die();
        } else {
            // Ошибок нет. Отправить подтверждение "Принять платеж".
            if (DEBUG) {
                SendMail('OKWM <admin@okwm.om.ua>', '4. From Yandex.Money request', "CONFIRM PAYMENT RECIVE.\n\n".print_r($check_attr, true), $conf_merchantEmail);
            }
            error_log(date("Y.m.d H:i:s") . " SEND confirmation accept payment.\n", 3, LOG_YM_FILE);
            send_response_xml("checkOrderResponse", "0", $check_attr->invoiceId);
            die();
        }
    } elseif  ($request_type == "paymentAvisoRequest") {
        // Сохраняем полученые данные и подтверждаем принятие оплаты
        $check_attr = $req_xml->attributes();
		$PaymentID = substr($check_attr->customerNumber, 0, strpos($check_attr->customerNumber, '.'));
		$sql = "SELECT Contract_ID, Payment_Status, Payment_Sum, Payment_Currency, MAIL FROM Contract WHERE Payment_ID = '$PaymentID'";
		OpenSQL ($sql, $row, $res);
	    if ($row == 1) {		    GetFieldValue ($res, $row_rec, "Contract_ID", $db_Contract_ID, $IsNull);              // Номер заявки
		    GetFieldValue ($res, $row_rec, "Payment_Status", $db_Payment_Status , $IsNull);       // Статус оплаты
		    GetFieldValue ($res, $row_rec, "Payment_Sum", $db_InSum , $IsNull);                   // Сумма оплаты
		    GetFieldValue ($res, $row_rec, "Payment_Currency", $db_InMoney , $IsNull);            // Валюта оплаты
		    GetFieldValue ($res, $row_rec, "MAIL", $db_mail, $IsNull);
		    $Contract_ID = round($db_Contract_ID*pi());
		    $user_mail = base64_decode ($db_mail);
		    if (($db_Payment_Status != 0)||($db_InSum!=$check_attr->orderSumAmount)||($db_InMoney!="YAD")) {		        error_log(date("Y.m.d H:i:s") . " RECIVE PAYMENT AVISO invoiceId: ".$check_attr->invoiceId.".\n", 3, LOG_YM_FILE);
		        error_log(date("Y.m.d H:i:s") . " db_Payment_Status=$db_Payment_Status\n$db_InSum!=".$check_attr->orderSumAmount."\n$db_InMoney!='YAD'\n", 3, LOG_YM_FILE);
		        SendMail('OKWM <admin@okwm.om.ua>', 'OKWM Yandex.Money request', "http://www.okwm.com.ua/ym/ym_status.php (149)\nПовторный запрос paymentAvisoRequest. PAYMENT RECIVED.\n\n".print_r($check_attr, true)."\n\n", $conf_merchantEmail);
		        send_response_xml("paymentAvisoResponse", "0", $check_attr->invoiceId, "");
			} else {
		        $sql = "UPDATE Contract SET Autorization_Time = NOW(), ORDER_ID = '".$check_attr->invoiceId."', Payment_Status = '1' WHERE Payment_ID = '$PaymentID'";
		        ExecSQL ($sql, $row);
		        if ($row) {
			        // Ошибок нет. Отправить подтверждение "Принять платеж".
			        if (DEBUG) {
			            SendMail('OKWM <admin@okwm.om.ua>', '5. From Yandex.Money request', "paymentAvisoRequest. PAYMENT RECIVED.\n\n".print_r($check_attr, true)."\n\n", $conf_merchantEmail);
			        }
			        error_log(date("Y.m.d H:i:s") . " SEND Payment Aviso Response.\n".$confirmed_msg."\n", 3, LOG_YM_FILE);
			        send_response_xml("paymentAvisoResponse", "0", $check_attr->invoiceId, "");
			    } else {			        // Ошибка записи принятия платежа.
			        if (DEBUG) {
			            SendMail('OKWM <admin@okwm.om.ua>', '6. From Yandex.Money request', "paymentAvisoRequest. PAYMENT RECIVED.\nError update payment status in DB.\n".print_r($check_attr, true)."\n\n", $conf_merchantEmail);
			        }
			        error_log(date("Y.m.d H:i:s") . " Error update DB about Payment Aviso!\n", 3, LOG_YM_FILE);
			        send_response_xml("paymentAvisoResponse", "1000", $check_attr->invoiceId, "Error update status payment.");
			    }
			    // SEND MAIL TO CLIENT AND ADMIN
                // отправляем сообщение админу
                $msg = "Оплата заявки $Contract_ID принята.\r\n";
                $msg.= "$db_InSum $db_InMoney - сумма платежа \r\n";
                $msg.= $check_attr->invoiceId." - номер квитанции \r\n";
                $msg.= $check_attr->paymentPayerCode." - идентификатор плательщика \r\n";
                $msg.= $check_attr->shopSumAmount." - поступило на счет \r\n";
                // сообщить админу, что оплата прошла успешно, данные сохранены.
                $m_title = $Contract_ID.". Оплата $db_InMoney принята.";
                $from  = $HTTP_SERVER_VARS ['SERVER_ADMIN'];
                $res_mail = SendMail ($from, $m_title, $msg);
                // сообщить плательщику, что оплата принята.
                $msg = "Здравствуйте!\r\n";
                $msg.= "От Вас получено $db_InSum Яндекс.Денег.\r\n\r\n";
                $msg.= "Спасибо, что воспользовались нашими услугами.\r\nС уважением,\r\nАдминистратор www.okwm.com.ua\r\n";
                $title = "Оплата $db_InSum Яндекс.Денег принята.";
                $res_mail = SendMail ($from, $title, $msg, $user_mail);

                // Добавить поступившую сумму ЯД к сумме в Банке
                SetGoodAmount ($check_attr->shopSumAmount, $db_InMoney);
			}
		} else {	        error_log(date("Y.m.d H:i:s") . " Order with PaymentID='".$PaymentID."' not found.\n", 3, LOG_YM_FILE);
	        send_response_xml("paymentAvisoResponse", "200", $check_attr->invoiceId, "Error customerNumber or other payment data.");
	    }
    } else {        if (DEBUG) {
            SendMail('OKWM <admin@okwm.com.ua>', '7. From Yandex.Money request', "ERROR XML PARSER.\n\n".$req_xml_str, $conf_merchantEmail);
        }
        error_log(date("Y.m.d H:i:s") . " FAIL XML DATA. \n", 3, LOG_YM_FILE);
        send_response_xml("checkOrderResponse", "200", $check_attr->invoiceId, "Error XML parse data.");
        die();
    }



	function send_response_xml($type_response, $code, $invoiceId, $Message) {
	      error_log(date("Y.m.d H:i:s") . " RESPONSE ($type_response) code=$code, invoiceId=$invoiceId  \n", 3, LOG_YM_RESULT_FILE);
	      if (strlen($Message)>0) {
	          $Message = ' Message="'.$Message.'"';
	      }
	      $out_xml_str = '<?xml version="1.0" encoding="UTF-8"?><'.$type_response.' performedDatetime ="'.date("Y-m-d\TH:i:s.000+02:00").'" code="'.$code.'" invoiceId="'.$invoiceId.'" shopId="'.SHOP_ID.'"'.$Message.'/>';
	      file_put_contents("php://output", $out_xml_str);
	}

    function verify($data, $certificate) {
        $descriptorspec = array(
            0 => array("pipe", "r"), // stdin is a pipe that the child will read from
            1 => array("pipe", "w"), // stdout is a pipe that the child will write to
            2 => array("pipe", "w")); // stderr is a file to write to

        $process = proc_open(
            'openssl smime -verify -inform PEM -nointern -certfile ' . $certificate . ' -CAfile ' . $certificate,
            $descriptorspec, $pipes);

        if (is_resource($process)) {
            // $pipes now looks like this:
            // 0 => writeable handle connected to child stdin
            // 1 => readable handle connected to child stdout

            fwrite($pipes[0], $data);
            fclose($pipes[0]);

            $content = stream_get_contents($pipes[1]);
            fclose($pipes[1]);
            $resCode = proc_close($process);

            if ($resCode != 0) {
                if ($resCode == 2 || $resCode == 4) {
                    error_log(date("Y.m.d H:i:s") . " Signature verification failed " . " \n", 3, LOG_YM_RESULT_FILE);
                    send_response_xml("checkOrderResponse", "1", "");
                } else {
                    error_log(date("Y.m.d H:i:s") . " (verify) OpenSSL call failed: " . $resCode . "\n" . $content. "\n", 3, LOG_YM_RESULT_FILE);
                    send_response_xml("checkOrderResponse", "200", "");
                }
                return;
            }
            return $content;
        }
    }



?>
