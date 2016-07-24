<?php

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");

/*
$p24 = new matrix();

$balance = $p24->getBalance();
if ($balance == 0) {
    echo $p24->getErrMessage();
} else {
    echo $balance;
}
exit;

$card = "4405885018995768";

var_dump($p24->checkStatus());
exit;

$check_result = $p24->checkCard($card);
if ($check_result[0]) {
    $answer = $p24->pay($card,1,"38282");
    echo $answer;
} else {    echo $p24->getErrMessage();
}
exit;
*/

// ======================================================================================= //

class matrix {    public $time_stamp;
    public $pay_id;

    private $gate;
    private $serviceID;
    private $secret;
    private $apiurl;
    private $errMessage;

    function __construct(){ // конструктор
        $this->gate = MATRIX_GATE;
        $this->serviceID = MATRIX_SERVICE_ID;
        $this->secret = MATRIX_SECRET;
	    $this->pay_id = $this->guid();
	}

    // return GUID xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    function guid(){
         if (function_exists('com_create_guid')){
             return trim(com_create_guid(), '{}');
         }else{
             mt_srand((double)microtime()*10000);//optional for php 4.2.0 and up.
             $charid = strtoupper(md5(uniqid(rand(), true)));
             $hyphen = chr(45);// "-"
             $uuid = substr($charid, 0, 8).$hyphen
                     .substr($charid, 8, 4).$hyphen
                     .substr($charid,12, 4).$hyphen
                     .substr($charid,16, 4).$hyphen
                     .substr($charid,20,12);
             return $uuid;
         }
    }

    function msoap($xml) { // транспортная ф-ция
        //$header = array();
        //$header[] = "Content-Type: text/xml";
        //$header[] = "\r\n";

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $this->apiurl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        //curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $xml);
        $rez = curl_exec($ch);
        curl_close($ch);
		return $rez;
	}

	// return balance on account
	function getBalance() {	    $ip = getenv('REMOTE_ADDR');	    $this->apiurl = "https://xml.enter-pin.ru/xml_gate_standart.php?ACT=8&GATE=".$this->gate."&SERVICE_ID=".$this->serviceID."&SIGN=a9f98f729e432fbc10c07ddc08cfae7b";
	    $sql_request = "INSERT INTO matrix_api (act, date, ip) VALUES (8, NOW(), '$ip')";
	    $this->loggedRequest($sql_request);
	    $id = mysql_insert_id();
	    $resp = $this->msoap("");
	    /*
	    <?xml version="1.0" encoding="UTF-8" ?>
	    <pay-response>
    	    <status_code>11</status_code>
            <time_stamp>14.05.2012 13:44:36</time_stamp>
            <balance>29317.49</balance>
        </pay-response>	    */
        $dom = new DomDocument('1.0','UTF-8');
        $dom->loadXML($resp);
        $xpath = new DOMXPath($dom);
        $q_time = '//pay-response/time_stamp';
        $time_stamp_dom = $xpath->query($q_time);
        $this->time_stamp = $time_stamp_dom->item(0)->nodeValue;
        $q_status = '//pay-response/status_code';
        $status_code_dom = $xpath->query($q_status);
        $status_code = $status_code_dom->item(0)->nodeValue;
        if ($status_code == "11") {
            $q_balance = '//pay-response/balance';
            $balance_dom = $xpath->query($q_balance);
            $balance = $balance_dom->item(0)->nodeValue;
        } else {            $balance = 0;
        }
        $this->setErrMessage($status_code);
   	    $sql_answer = "UPDATE matrix_api SET status_code='$status_code', balance='$balance', time_stamp='".$this->time_stamp."' WHERE id=$id";
   	    $this->loggedRequest($sql_answer);
        return $balance;
	}

    // return array(Yes/No, status_code, min_amount, max_amount)
	function checkCard($account) {
	    $ip = getenv('REMOTE_ADDR');
	    $sign_str = "1_".$account."_".$this->serviceID."_".$this->pay_id;
	    $this->apiurl = "https://xml.enter-pin.ru/xml_gate_standart.php?ACT=1&PAY_ACCOUNT=$account&GATE=".$this->gate."&SERVICE_ID=".$this->serviceID."&TRADE_POINT=okwm&PAY_ID=".$this->pay_id."&SIGN=".$this->calcSignature($sign_str);
	    //echo $this->apiurl."<br /><br />";
	    $sql_request = "INSERT INTO matrix_api (act, date, pay_account, pay_id) VALUES (1, NOW(), '$account', '".$this->pay_id."')";
	    $this->loggedRequest($sql_request);
	    $id = mysql_insert_id();

	    /*$resp = '<?xml version="1.0" encoding="UTF-8" ?>
	    <pay-response>
            <name></name>
            <account>4405885018995768</account>
            <service_id>40</service_id>
            <min_amount>1</min_amount>
            <max_amount>50000</max_amount>
            <status_code>-90</status_code>
            <time_stamp>15.05.2012 12:07:40</time_stamp>
        </pay-response>';*/
	    $resp = $this->msoap("");
        $dom = new DomDocument('1.0','UTF-8');
        $dom->loadXML($resp);
        $xpath = new DOMXPath($dom);
        $q_time = '//pay-response/time_stamp';
        $time_stamp_dom = $xpath->query($q_time);
        $this->time_stamp = $time_stamp_dom->item(0)->nodeValue;
        $q_status = '//pay-response/status_code';
        $status_code_dom = $xpath->query($q_status);
        $status_code = $status_code_dom->item(0)->nodeValue;
        if ($status_code == "21") {
            $q_account = '//pay-response/account';
            $account_dom = $xpath->query($q_account);
            $answ_account = $account_dom->item(0)->nodeValue;
            $q_max_amount = '//pay-response/max_amount';
            $max_amount_dom = $xpath->query($q_max_amount);
            $max_amount = $max_amount_dom->item(0)->nodeValue;
            $q_min_amount = '//pay-response/min_amount';
            $min_amount_dom = $xpath->query($q_min_amount);
            $min_amount = $min_amount_dom->item(0)->nodeValue;
            $resp_array = array(true, $status_code, $min_amount, $max_amount);
        } else {
            $resp_array = array(false, $status_code);
        }
        $this->setErrMessage($status_code);
   	    $sql_answer = "UPDATE matrix_api SET status_code='$status_code', time_stamp='".$this->time_stamp."', min_amount='$min_amount', max_amount='$max_amount' WHERE id=$id";
   	    $this->loggedRequest($sql_answer);
	    return $resp_array;
	}

    // return array(Yes/No, status_code, min_amount, max_amount)
	function pay($account, $amount, $receipt_num) {	    $act = 4; // PAY
	    $sign_str = $act."_".$account."_".$this->serviceID."_".$this->pay_id;
	    $this->apiurl = "https://xml.enter-pin.ru/xml_gate_standart.php?ACT=$act&PAY_ACCOUNT=$account&PAY_AMOUNT=$amount&RECEIPT_NUM=$receipt_num&GATE=".$this->gate."&SERVICE_ID=".$this->serviceID."&TRADE_POINT=okwm&PAY_ID=".$this->pay_id."&SIGN=".$this->calcSignature($sign_str);
	    //echo $this->apiurl."<br /><br />";
	    $ip = getenv('REMOTE_ADDR');
	    $sql_request = "INSERT INTO matrix_api (act, date, pay_account, pay_amount, pay_id, receipt_num, ip) VALUES ($act, NOW(), '$account', '$amount', '".$this->pay_id."', '$receipt_num', '$ip')";
	    $this->loggedRequest($sql_request);
	    $id = mysql_insert_id();

	    /*$resp = '<?xml version="1.0" encoding="UTF-8" ?><pay-response><pay_id>0626F50D-0D33-4820-9C84-D1951D8F0B4B</pay_id>
        <service_id>40</service_id>
        <amount>1</amount>
        <status_code>22</status_code>
        <time_stamp>15.05.2012 16:48:00</time_stamp>
        </pay-response>
        ';*/
	    $resp = $this->msoap("");
        $dom = new DomDocument('1.0','UTF-8');
        $dom->loadXML($resp);
        $xpath = new DOMXPath($dom);
        $q_time = '//pay-response/time_stamp';
        $time_stamp_dom = $xpath->query($q_time);
        $this->time_stamp = $time_stamp_dom->item(0)->nodeValue;
        $q_status = '//pay-response/status_code';
        $status_code_dom = $xpath->query($q_status);
        $status_code = $status_code_dom->item(0)->nodeValue;
        if ($status_code == "22") {
            $q_amount = '//pay-response/amount';
            $amount_dom = $xpath->query($q_amount);
            $answer_amount = $amount_dom->item(0)->nodeValue;
            $resp_array = array(true, $status_code);
        } else {
            $resp_array = array(false, $status_code);
        }
        $this->setErrMessage($status_code);
   	    $sql_answer = "UPDATE matrix_api SET status_code='$status_code', time_stamp='".$this->time_stamp."' WHERE id=$id";
   	    $this->loggedRequest($sql_answer);
	    return $resp_array;
	}

	function checkStatus() {
	    $act = 7; // STATUS
	    //$this->pay_id = "0626F50D-0D33-4820-9C84-D1951D8F0B4B";
	    $sign_str = $act."__".$this->serviceID."_".$this->pay_id;
	    $this->apiurl = "https://xml.enter-pin.ru/xml_gate_standart.php?ACT=$act&GATE=".$this->gate."&SERVICE_ID=".$this->serviceID."&PAY_ID=".$this->pay_id."&SIGN=".$this->calcSignature($sign_str);
	    //echo $this->apiurl."<br /><br />";
	    $ip = getenv('REMOTE_ADDR');
	    $sql_request = "INSERT INTO matrix_api (act, date, pay_id, ip) VALUES ($act, NOW(), '".$this->pay_id."', '$ip')";
	    $this->loggedRequest($sql_request);
	    $id = mysql_insert_id();

	    /*$resp = '<?xml version="1.0" encoding="UTF-8" ?>
	    <pay-response>
	    <status_code>11</status_code>
        <time_stamp>16.05.2012 11:20:55</time_stamp>
        <transaction>
           <pay_id>0626F50D-0D33-4820-9C84-D1951D8F0B4B</pay_id>
           <service_id>40</service_id>
           <amount>1</amount>
           <status>111</status>
           <time_stamp>15.05.2012 16:48:05</time_stamp>
        </transaction>
        </pay-response>
        ';*/
	    $resp = $this->msoap("");
	    if ($resp != "") {	        $resp_obj = simplexml_load_string($resp);
	        $this->time_stamp = $resp_obj->time_stamp;
	        $status_code = $resp_obj->status_code;
            if ($status_code == "11") {
                $ts = $resp_obj->transaction;
                $status = $ts->status;
                if (($status == "111")||($status == "130")) {                    // 111 - Платеж успешно выполнен
                    // 130 - Платеж отменен
                    $sql_answer = "UPDATE matrix_api SET status_code=$status_code, status='".$ts->status."', pay_amount=".$ts->amount.", time_stamp='".$ts->time_stamp."' WHERE id=$id";
                    $this->loggedRequest($sql_answer);
                    // Отметка статуса платежа
                    $sql_status = "UPDATE matrix_api SET status='".$ts->status."' WHERE act=4 AND pay_id='".$this->pay_id."'";
                    $this->loggedRequest($sql_status);
                    if ($status == "111") {                        $resp_array = array(true, $status, $ts->time_stamp);
                    } else {                        $resp_array = array(false, $status, $ts->time_stamp);
                    }
                } else if ($status == "120") {                    // Платеж находится в обработке
                    $sql_answer = "UPDATE matrix_api SET status_code=$status_code, status='".$ts->status."', time_stamp='".$ts->time_stamp."' WHERE id=$id";
                    $this->loggedRequest($sql_answer);
                    $resp_array = array(false, $status, $ts->time_stamp);
                } else {
                    $resp_array = array(false, $status);
                    $sql_answer = "UPDATE matrix_api SET status_code=$status_code, status='".$ts->status."', time_stamp='".$ts->time_stamp."' WHERE id=$id";
                    $this->loggedRequest($sql_answer);
                }
                $this->setErrMessage($status);
            } else {
                $sql_answer = "UPDATE matrix_api SET status_code=$status_code,  time_stamp='".$this->time_stamp."' WHERE id=$id";
                $this->loggedRequest($sql_answer);
                $this->setErrMessage($status_code);
                $resp_array = array(false, $status_code);
            }
        } else {            $resp_array = array(false, "Ответ не получен.");
            $this->errMessage = 'Ошибка проверки статуса операции. Получен пустой ответ.';
        }
	    return $resp_array;
	}

	// return Error Message
	function setErrMessage($status_code) {
		switch ($status_code) {		    case -101:
		        $this->errMessage = "Параметры запроса не корректны. Обратитесь к администратору.";
		    break;
		    case -100:
		        $this->errMessage = "В биллинговой системе найдено более одного платежа с данным номером.";
		    break;
		    case -90:
		        $this->errMessage = "Сервис недоступный.";
		    break;
		    case -42:
		        $this->errMessage = "Платеж на данную сумму невозможен для данного клиента.";
		    break;
		    case -41:
		        $this->errMessage = "Прием платежей для данного клиента невозможен.";
		    break;
		    case -40:
		        $this->errMessage = "Клиента не найдено.";
		    break;
		    case -10:
		        $this->errMessage = "Транзакцию не найдено.";
		    break;
		    case 11:
		        $this->errMessage = "Статус транзакции определен.";
		    break;
		    case 21:
		        $this->errMessage = "Платеж возможный.";
		    break;
		    case 22:
		        $this->errMessage = "Платеж принят банком в обработку.";
		    break;
		    case 111:
		        $this->errMessage = "Платеж успешно выполнен.";
		    break;
		    case 120:
		        $this->errMessage = "Платеж находится в обработке.";
		    break;
		    case 130:
		        $this->errMessage = "Платеж отменен.";
		    break;
		    default:
		        $this->errMessage = "Статус не определен.";
		}
	}

	// return Error Message
	function getErrMessage() {
		return $this->errMessage;
	}

    function loggedRequest($query) {        ExecSQL($query, $row);
        if (!$row) {            $this->errMessage = "Ошибка записи операции в базу данных: ".mysql_error();
        }
    }

	function calcSignature($data) { // расчёт сигнатуры
		return md5($data."_".$this->secret);
	}
}

?>