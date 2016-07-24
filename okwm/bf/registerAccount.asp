<?php
   require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
   require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");

   $https = DOMAIN_HTTPS;
   global $HTTP_SERVER_VARS;
   //if (!isset ($HTTP_SERVER_VARS{'HTTPS'})) {
      // if without SSL, then redirect
      //header("Location: $https/bf");
      //exit;
   //}

   foreach ($HTTP_POST_VARS as $key => $value) {
      if (!is_array($value)) {
         $HTTP_POST_VARS[$key] = addslashes(trim($value));
      }
   }

   if (isset($HTTP_POST_VARS['sid'])) {
      $sid=trim($HTTP_POST_VARS["sid"]);
	  session_id($sid);
	  session_start();
   } else {      session_start();
      $sid = session_id();
   }

   //if (getenv("REMOTE_ADDR")=="193.201.98.4") phpinfo();

echo <<<EOT

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta http-equiv="content-type" charset="UTF-8">

	<link href="./css/global.css" rel="stylesheet" type="text/css" />
	<link href="./css/style.css" rel="stylesheet" type="text/css" />

	<script src="./js/prototype.js" type="text/javascript"></script>
	<script src="./js/dynalog.js" type="text/javascript"></script>
	<script src="./js/registration.js" type="text/javascript"></script>

	<title>Регистрация на бирже Betfair - агент OKWM.com.ua</title>

	<script>
	    document.domain = "okwm.com.ua";
		//Setting up the variables to be used by JavaScript
		startRegURL = "https://adfarm.mediaplex.com/ad/bk/6730-35338-3840-9?Reg1=1&mpuid=";

		//Set the Geo Located Country
		geoLocatedCountry = "UA";

		contentUrlAboutUsTC = "getWindow(1,'http://content.betfair.com/aboutus/?sWhichKey=Terms%20and%20Conditions',0,500,788);";
		contentUrlPrivatePolicy = "getWindow(31,'http://content.betfair.com/aboutus/?sWhichKey=Privacy%20Policy',0,500,788);";
	</script>
<script language="Javascript">
<!--
var newHomePageWindow = null;
function navigateHome() {
	if (window.opener && !window.opener.closed) {
		window.opener.focus();
	} else if (newHomePageWindow != null) {
		newHomePageWindow.focus();
	} else {
		var homeURL = "http://www.betfair.com";
		var promoCode = document.forms[0].promoReferEarnCode.value;
		if (promoCode != "") {
			homeURL+="?promotionCode=" + promoCode + "&reLoadWindow=false";
		}
		newHomePageWindow = window.open(homeURL, "newHomePage");
	}
}

function DisableFields() {

}

function EnableFields() {
	document.getElementById("title").disabled = false;
	document.getElementById("dateOfBirth.month").disabled = false;
	document.getElementById("userOptIn").disabled = false;
	document.getElementById("userOptOut").disabled = false;
	document.getElementById("countryOfResidenceList").disabled = false;
	document.getElementById("securityQuestionList").disabled = false;
	document.getElementById("currency").disabled = false;
	document.getElementById("promoCodeYes").disabled = false;
	document.getElementById("agreeTermsConditionsPrivacy1").disabled = false;
}
//-->
</script>

EOT;

   if (isset($HTTP_POST_VARS)&&(count($HTTP_POST_VARS)>0)) {   		$error = false;
		if (isset($HTTP_POST_VARS['title']))
			$title = $HTTP_POST_VARS['title'];
		else {
			$errorTitle = "Выберите титул.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['firstName'])&&(strlen($HTTP_POST_VARS['firstName'])>0)&&
		   (ereg("^[a-zA-Z]{2,50}\$", $HTTP_POST_VARS['firstName'])))
			$firstName = $HTTP_POST_VARS['firstName'];
		else {
			$errorFirstName = "Пожалуйста, введите свое имя (Латинскими буквами без пробелов).";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['surname'])&&(strlen($HTTP_POST_VARS['surname'])>0)&&
		   (ereg("^[a-zA-Z]{2,50}\$", $HTTP_POST_VARS['surname'])))
			$surname = $HTTP_POST_VARS['surname'];
		else {
			$errorSurname = "Введите свою фамилию (Латинскими буквами без пробелов).";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['dateOfBirth_year'])&&(strlen($HTTP_POST_VARS['dateOfBirth_year'])==4)&&
		    (ereg("^[0-9]{4}\$", $HTTP_POST_VARS['dateOfBirth_year'])))
			$dateOfBirth_year = $HTTP_POST_VARS['dateOfBirth_year'];
		else {
			$errorDateOfBirthYear = "Введите действительный год рождения.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['dateOfBirth_month'])&&(strlen($HTTP_POST_VARS['dateOfBirth_year'])==4)&&
		    (ereg("^[0-9]{2}\$", $HTTP_POST_VARS['dateOfBirth_month'])))
			$dateOfBirth_month = $HTTP_POST_VARS['dateOfBirth_month'];
		else {
			$errorDateOfBirthMonth = "Введите свой месяц рождения.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['dateOfBirth_day'])&&(ereg("^[0-9]{1,2}\$", $HTTP_POST_VARS['dateOfBirth_day'])))
			$dateOfBirth_day = $HTTP_POST_VARS['dateOfBirth_day'];
		else {
			$errorDateOfBirthDay = "Введите свой день рождения, 01-31.";
			$error = true;
		}

        // Проверка даты на 18 лет
		//$under18 = $HTTP_POST_VARS['under18'];
		if (isset($dateOfBirth_year)&&isset($dateOfBirth_month)&&isset($dateOfBirth_day)) {
			if (((time()-mktime(0,0,0,$dateOfBirth_month, $dateOfBirth_day, $dateOfBirth_year))/31536000)>18) {				$dateOfBirth = "$dateOfBirth_year-$dateOfBirth_month-$dateOfBirth_day";
			} else {
				$errorDateOfBirthYear = "Введите действительный год рождения.";
				$error = true;
			}
		}

		if (isset($HTTP_POST_VARS['contactNumber_number'])&&(strlen($HTTP_POST_VARS['contactNumber_number'])>0)&&
		   (ereg("^[0-9]{7,15}\$", $HTTP_POST_VARS['contactNumber_number'])))
			$contactNumber = $HTTP_POST_VARS['contactNumber_number'];
		else {
			$errorContactNumber = "Пожалуйста, вводите номер телефона без пробелов.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['emailAddress'])&&(strlen($HTTP_POST_VARS['emailAddress'])>0)&&
		   (ereg("^[@.a-zA-Z0-9_-]{6,50}\$", $HTTP_POST_VARS['emailAddress'])))
			$emailAddress = $HTTP_POST_VARS['emailAddress'];
		else {
			$errorEmailAddress = "Введите ваш email.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['confirmEmailAddress'])&&(strlen($HTTP_POST_VARS['confirmEmailAddress'])>0)&&
		   (ereg("^[@.a-zA-Z0-9_-]{6,50}\$", $HTTP_POST_VARS['confirmEmailAddress'])))
			$confirmEmailAddress = $HTTP_POST_VARS['confirmEmailAddress'];
		else {
			$errorConfirmEmailAddress = "Введите ваш email.";
			$error = true;
		}

		if (!isset($errorConfirmEmailAddress)&&($emailAddress != $confirmEmailAddress)) {
			$errorEmailConfirm = "Данный электронный адрес недействительный. Пожалуйста, попробуйте снова. ";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['communicationOptIn']))
			$communicationOptIn= ($HTTP_POST_VARS['communicationOptIn'])? 1 : 0;

		//$addressManualEntry = $HTTP_POST_VARS['addressManualEntry'];
		//countryOfResidenceList] => UA
		if (isset($HTTP_POST_VARS['countryOfResidence'])&&(strlen($HTTP_POST_VARS['countryOfResidence'])==2)&&
		   (ereg("^(UA|RU|BY|MD{1})\$", $HTTP_POST_VARS['countryOfResidence'])))
			$countryOfResidence = $HTTP_POST_VARS['countryOfResidence'];
		else {
			$errorCountryOfResidence = "Выберите страну.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['address_address1'])&&(strlen($HTTP_POST_VARS['address_address1'])>0)&&
		   (ereg("^[a-zA-Z0-9/,. \-]{2,100}\$", $HTTP_POST_VARS['address_address1']))) {
			$adress = $HTTP_POST_VARS['address_address1'];
		} else {
			$errorAdress = "Пожалуйста, введите Ваш домашний адрес латинскими буквами.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['address_town'])&&(strlen($HTTP_POST_VARS['address_town'])>0)&&
		   (ereg("^[a-zA-Z0-9/,. \]{2,50}\$", $HTTP_POST_VARS['address_town'])))
			$town = $HTTP_POST_VARS['address_town'];
		else {
			$errorTown = "Введите Ваш город.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['address_county'])&&
		   (ereg("^[a-zA-Z0-9/,. \]{2,50}\$", $HTTP_POST_VARS['address_county'])))
			$county = $HTTP_POST_VARS['address_county'];
		else
			$county = "";

		if (isset($HTTP_POST_VARS['address_zipCode'])&&
		   (ereg("^[0-9]{1,8}\$", $HTTP_POST_VARS['address_zipCode'])))
			$zipCode = $HTTP_POST_VARS['address_zipCode'];
		else
			$zipCode = "";

		if (isset($HTTP_POST_VARS['username'])&&(strlen($HTTP_POST_VARS['username'])>0)&&
		   (ereg("^[a-zA-Z0-9]{6,20}\$", $HTTP_POST_VARS['username']))) {
			$username = $HTTP_POST_VARS['username'];
			$sql = "SELECT username FROM betfair_users WHERE username='$username'";
			$row = OpenSQL ($sql, $rows, $res);
			if ($rows > 0) {
				$errorUsername = "Пользователь с таким именем уже существует. Попробуйте другое имя.";
				$error = true;
			}
		} else {
			$errorUsername = "Введите имя пользователя. ";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['password'])&&(strlen($HTTP_POST_VARS['password'])>=8)&&(strlen($HTTP_POST_VARS['password'])<=20)&&
		   (ereg("[a-zA-Z]+", $HTTP_POST_VARS['password'])&&ereg("[0-9]+", $HTTP_POST_VARS['password'])))
			$userpassword = $HTTP_POST_VARS['password'];
		else {
			$errorUserpassword = "Введите ваш пароль.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['confirmPassword'])&&(strlen($HTTP_POST_VARS['confirmPassword'])>=8)&&(strlen($HTTP_POST_VARS['confirmPassword'])<=20)&&
		   (ereg("[a-zA-Z]+", $HTTP_POST_VARS['confirmPassword'])&&ereg("[0-9]+", $HTTP_POST_VARS['confirmPassword'])))
			$confirmPassword = $HTTP_POST_VARS['confirmPassword'];
		else {
			$errorConfirmPassword = "Введите ваш пароль.";
			$error = true;
		}

		if (!isset($errorConfirmPassword)&&($confirmPassword!=$userpassword)) {			$errorPasswordConfirm = "Указанный пароль не действительный. Пожалуйста, попробуйте снова.
			Помните, пароль чувствителен к регистру.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['identificationQuestion1'])) {
			if ($HTTP_POST_VARS['identificationQuestion1'] == "invalid 1") {
				$errorSelectedSecurityQuestion1 = "Пожалуйста, выберите секретный вопрос 1.";
				$error = true;
			} else {
				$securityQuestion1 = $HTTP_POST_VARS['identificationQuestion1'];
			}
		} else {			$errorSelectedSecurityQuestion1 = "Пожалуйста, выберите секретный вопрос 1.";			$error = true;
		}

		if (isset($HTTP_POST_VARS['identificationAnswer1'])&&(strlen($HTTP_POST_VARS['identificationAnswer1'])>0)&&
		   (ereg("^[a-zA-Z ]{1,50}\$", $HTTP_POST_VARS['identificationAnswer1'])))
			$securityAnswer1 = $HTTP_POST_VARS['identificationAnswer1'];
		else {
			$errorSecurityAnswer1 = "Введите ответ.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['identificationQuestion2'])) {
			if ($HTTP_POST_VARS['identificationQuestion2'] == "invalid 1") {
				$errorSelectedSecurityQuestion2 = "Пожалуйста, выберите секретный вопрос 2.";
				$error = true;
			} else {
				$securityQuestion2 = $HTTP_POST_VARS['identificationQuestion2'];
			}
		} else {
			$errorSelectedSecurityQuestion2 = "Пожалуйста, выберите секретный вопрос 2.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['a2Day'])&&($HTTP_POST_VARS['a2Day']!="invalid 1")&&
		   ($HTTP_POST_VARS['a2Day']>=1)&&($HTTP_POST_VARS['a2Day']<=31))
			$a2Day = $HTTP_POST_VARS['a2Day'];
		else {
			$errorSecurityAnswer2 = "Выберите правильно дату.";
			$error_a2Day = true;
			$error = true;
		}

		if (isset($HTTP_POST_VARS['a2Month'])&&($HTTP_POST_VARS['a2Month']!="invalid 1")&&
		   ($HTTP_POST_VARS['a2Month']>=1)&&($HTTP_POST_VARS['a2Month']<=12))
			$a2Month = $HTTP_POST_VARS['a2Month'];
		else {
			$errorSecurityAnswer2 = "Выберите правильно дату.";
			$error_a2Month = true;
			$error = true;
		}

		if (isset($HTTP_POST_VARS['a2Year'])&&($HTTP_POST_VARS['a2Year']!="invalid 1")&&
		   ($HTTP_POST_VARS['a2Year']>=(date("Y", time())-100))&&($HTTP_POST_VARS['a2Year']<=date("Y", time())))
			$a2Year = $HTTP_POST_VARS['a2Year'];
		else {
			$errorSecurityAnswer2 = "Выберите правильно дату.";
			$error_a2Year = true;
			$error = true;
		}

		if (!isset($error_a2Year)&&!isset($error_a2Month)&&!isset($error_a2Day)) {			$securityAnswer2 = "$a2Year-$a2Month-$a2Day";
		}

		if (isset($HTTP_POST_VARS['currency'])&&(strlen($HTTP_POST_VARS['currency'])>0)&&
		   (ereg("^(USD|EUR{1})\$", $HTTP_POST_VARS['currency'])))
			$currency = $HTTP_POST_VARS['currency'];
		else {
			$errorCurrency = "Выберите валюту.";
			$error = true;
		}

		if (isset($HTTP_POST_VARS['turingTest'])&&(ereg("^[a-zA-Z0-9]{1,4}\$", $HTTP_POST_VARS['turingTest']))) {
			if (isset($HTTP_SESSION_VARS['code'])&&(strtolower($HTTP_POST_VARS['turingTest'])==$HTTP_SESSION_VARS['code']))
				$turingTest = $HTTP_POST_VARS['turingTest'];
			else {
				$errorTuringTest = "Пожалуйста, введите текст представленный на картинке.";
				$error = true;
			}
		} else {			$errorTuringTest = "Пожалуйста, введите текст представленный на картинке.";
			$error = true;
		}

		//agreeTermsConditionsPrivacy => true
		//_agreeTermsConditionsPrivacy => on )
		if (isset($HTTP_POST_VARS['agreeTermsConditionsPrivacy'])&&($HTTP_POST_VARS['agreeTermsConditionsPrivacy']=="true"))
			$agreeTermsConditionsPrivacy = $HTTP_POST_VARS['agreeTermsConditionsPrivacy'];
		else {
			$errorAgreeTermsConditionsPrivacy = "Пожалуйста, подтвердите что Вы принимаете &quot;Условия и положения&quot; и &quot;Политику конфиденциальности&quot; сайта Betfair. ";
			$error = true;
		}

		if (!$error) {
			$sql = "INSERT INTO betfair_users (
			            title, firstName, surname, dateOfBirth, contactNumber, emailAddress, communicationOptIn,
			            countryOfResidence, address, town, county, zipCode, username, currency)
			        VALUES (
			            '$title', '$firstName', '$surname', '$dateOfBirth', '$contactNumber', '$emailAddress', $communicationOptIn,
			            '$countryOfResidence', '$adress', '$town', '$county', '$zipCode', '$username', '$currency')";
			ExecSQL ($sql, $row);
			if ($row) {
				$result = "Вы добавлены в клиентскую базу OKWM. Через некоторое время Ваша регистрация на бирже ставок
				будет активирована. Об этом Вам будет сообщено дополнительно в письме.";
				// Письмо о регистрации клиенту
	            $subject = "Регистрация на бирже ставок Betfair через агента OKWM.";
	            $msg = "
<html>
<head>
  <title>Регистрация на Betfair.</title>
</head>
<body>
<p>Ув. $title $firstName $surname!</p>
<p>Благодарим Вас за регистрацию!<br>
Через некоторое время Ваша учетная запись будет активирована на Betfair.<br>
Об этом мы Вам сообщим дополнительно письмом.<br>
При первом входе в учетную запись Вам будет предложено поменять пароль.<br><br>
В регистрации Вы указали:<br>
	<table>
    	<tr><td>Имя пользователя:</td><td>$username</td></tr>
    	<tr><td>Пароль:</td><td>$userpassword</td></tr>
    </table>
<br><br>
Используйте эти данные для первого входа.<br><br>
</p>
<p>
==================================================<br />
С уважением,<br />
<br />
Администраторы сервиса http://www.okwm.com.ua<br />
<br />
тел. +380 (67) 931-85-77, +380 (66) 772-60-76<br />
ICQ 637139590 Яна<br />
Skype: okwm-info
</p>
</body>
</html>\r\n";
    			$to = $emailAddress;
	            $from = $HTTP_SERVER_VARS['SERVER_ADMIN'];
    			$success = @mail($to, "=?utf-8?B?".base64_encode($subject)."?=",
                  			 	chunk_split(base64_encode($msg)),
                   				"From: ".$from."\nMIME-Version: 1.0\nContent-Type: text/html; ".
                   				"charset=utf-8\nContent-Transfer-Encoding: base64\nX-Mailer: PHP/".
                   				phpversion()."\n","-f".$from);
				// Письмо администратору admin@okwm.com.ua
	            $subject = "$title $firstName $surname произвел(-a) регистрацию на Betfair.";
	            $msg = "
<html>
<head>
  <title>Регистрация клиента на Betfair.</title>
</head>
<body>
	<table>
		<tr><td>Титул</td><td>$title</td></tr>
		<tr><td>Имя</td><td>$firstName</td></tr>
		<tr><td>Фамилия</td><td>$surname</td></tr>
    	<tr><td>Дата рождения</td><td>$dateOfBirth</td></tr>
    	<tr><td>Контактный телефон</td><td>$contactNumber</td></tr>
		<tr><td>E-mail</td><td>$emailAddress</td></tr>
    	<tr><td>Получать информацию от Betfair</td><td>$communicationOptIn</td></tr>
    	<tr><td>Страна</td><td>$countryOfResidence</td></tr>
    	<tr><td>Адрес</td><td>$adress</td></tr>
    	<tr><td>Город</td><td>$town</td></tr>
    	<tr><td>Область</td><td>$county</td></tr>
    	<tr><td>Почтовый индекс</td><td>$zipCode</td></tr>
    	<tr><td>Имя пользователя</td><td>$username</td></tr>
    	<tr><td>Пароль</td><td>$userpassword</td></tr>
    	<tr><td>Секретный вопрос 1</td><td>$securityQuestion1</td></tr>
    	<tr><td>Ответ</td><td>$securityAnswer1</td></tr>
    	<tr><td>Секретный вопрос 2</td><td>$securityQuestion2</td></tr>
    	<tr><td>Ответ</td><td>$securityAnswer2</td></tr>
    	<tr><td>Валюта счета Betfair</td><td>$currency</td></tr>
    	<tr><td>Код промо акции</td><td>TWD118</td></tr>
    </table>
</body>
</html>\r\n";
    			$to = $HTTP_SERVER_VARS['SERVER_ADMIN'];
	            $from = $HTTP_SERVER_VARS['SERVER_ADMIN'];
    			$success = @mail($to, "=?utf-8?B?".base64_encode($subject)."?=",
                  			 	chunk_split(base64_encode($msg)),
                   				"From: ".$from."\nMIME-Version: 1.0\nContent-Type: text/html; ".
                   				"charset=utf-8\nContent-Transfer-Encoding: base64\nX-Mailer: PHP/".
                   				phpversion()."\n","-f".$from);
			} else {				$result = "Ваши данные по какой-то причине не внесены в клиентскую базу OKWM.
				Попробуйте поменять имя пользователя или свяжитесь с нашим администратором..";			}
		}
}

echo <<<EOT

	<!-- VERSION:2.1.0-3 -->

</head>

<body class="bodyTxt" onload="disableAutoComplete();">

<!--form id="registrationForm" name="registrationForm" method="post" action="https://account.betfair.com/account-web/registerAccount.html?origin=GOAALL&promotionCode=TWD118"-->
<form id="registrationForm" name="registrationForm" method="post">

	<div style="width:700px;">

		<div id="header">
			<span class="head">Регистрация</span>
			<div class="bodyTxt" style="padding-top:10px;">Пожалуйста, введите свои данные чтобы открыть счет. После регистрации, вы можете внести деньги на счет и делать ставки на бирже или играть в игры. </div>
		</div>

		<div id="contactUs">
			<span class="contactUsHead">Контакты</span>
			<div id="contactUsLine" class="bodyTxt" >
				Email:
				<a class="bodyBetLnk" href="mailto:Support.ru@betfair.com">
					Support.ru@betfair.com
				</a>
				<a class="bodyBetLnk" href="mailto:bf@okwm.com.ua">
					bf@okwm.com.ua
				</a>
			</div>
			<div id="contactUsLine" class="bodyTxt" > </div>
		</div>


		<!-- ERRORS LIST -->
EOT;
	if (isset($error)&&$error) {
		echo <<<EOT
	<div id="errors">
		<span class="errorItems" style="margin-top:5px;margin-left:5px;">
			Пожалуйста, предоставьте больше информации или исправьте отмеченные поля.
		</span>
		<p/>

		<table>
EOT;
		if (isset($errorTitle)) echo ("<tr class=\"error\"><td>Титул: $errorTitle</td></tr>");
		if (isset($errorFirstName)) echo ("<tr class=\"error\"><td>Имя: $errorFirstName</td></tr>");
		if (isset($errorSurname)) echo ("<tr class=\"error\"><td>Фамилия: $errorSurname</td></tr>");
		if (isset($errorDateOfBirthYear)) echo ("<tr class=\"error\"><td>Дата рождения: $errorDateOfBirthYear</td></tr>");
		if (isset($errorDateOfBirthMonth)) echo ("<tr class=\"error\"><td>Дата рождения: $errorDateOfBirthMonth</td></tr>");
		if (isset($errorDateOfBirthDay)) echo ("<tr class=\"error\"><td>Дата рождения: $errorDateOfBirthDay</td></tr>");
		if (isset($errorContactNumber)) echo ("<tr class=\"error\"><td>Контактный телефон: $errorContactNumber</td></tr>");
		if (isset($errorEmailAddress)) echo ("<tr class=\"error\"><td>E-mail: $errorEmailAddress</td></tr>");
		if (isset($errorConfirmEmailAddress)) echo ("<tr class=\"error\"><td>Подтверждение E-mail: $errorConfirmEmailAddress</td></tr>");
		if (isset($errorEmailConfirm)) echo ("<tr class=\"error\"><td>Подтверждение E-mail: $errorEmailConfirm</td></tr>");
		if (isset($errorCountryOfResidence)) echo ("<tr class=\"error\"><td>Страна: $errorCountryOfResidence</td></tr>");
		if (isset($errorAdress)) echo ("<tr class=\"error\"><td>Адрес: $errorAdress</td></tr>");
		if (isset($errorTown)) echo ("<tr class=\"error\"><td>Город: $errorTown</td></tr>");
		if (isset($errorUsername)) echo ("<tr class=\"error\"><td>Имя пользователя: $errorUsername</td></tr>");
		if (isset($errorUserpassword)) echo ("<tr class=\"error\"><td>Пароль: $errorUserpassword</td></tr>");
		if (isset($errorConfirmPassword)) echo ("<tr class=\"error\"><td>Подтверждение пароля: $errorConfirmPassword</td></tr>");
		if (isset($errorPasswordConfirm)) echo ("<tr class=\"error\"><td>Пароль: $errorPasswordConfirm</td></tr>");
		if (isset($errorSelectedSecurityQuestion1)) echo ("<tr class=\"error\"><td>Секретный вопрос 1: $errorSelectedSecurityQuestion1</td></tr>");
		if (isset($errorSecurityAnswer1)) echo ("<tr class=\"error\"><td>Секретный вопрос 1: $errorSecurityAnswer1</td></tr>");
		if (isset($errorSelectedSecurityQuestion2)) echo ("<tr class=\"error\"><td>Секретный вопрос 2: $errorSelectedSecurityQuestion2</td></tr>");
		if (isset($errorSecurityAnswer2)) echo ("<tr class=\"error\"><td>Секретный вопрос 2: $errorSecurityAnswer2</td></tr>");
		if (isset($errorCurrency)) echo ("<tr class=\"error\"><td>Валюта счета Betfair: $errorCurrency</td></tr>");
		if (isset($errorTuringTest)) echo ("<tr class=\"error\"><td>$errorTuringTest</td></tr>");
		if (isset($errorAgreeTermsConditionsPrivacy)) echo ("<tr class=\"error\"><td>$errorAgreeTermsConditionsPrivacy</td></tr>");
        echo <<<EOT

		</table>
	</div>
EOT;
	}
	if (isset($result)) {		echo <<<EOT

		<div class="sectionSpacer" />

		<div class="personalDetails">

			<div class="l">
				<div class="r">
					<div class="bi"><span class="title">Результат регистрации</span></div>
				</div>
			</div>

			<div class="fieldSpacer5"/>

			$result


        </div>


EOT;
    } else {

    echo <<<EOT

		<div class="sectionSpacer" />

				<div class="personalDetails">

			<div class="l">
				<div class="r">
					<div class="bi"><span class="title">Личные данные</span></div>
				</div>
			</div>

			<div class="fieldSpacer5"/>

    			<!-- TITLE, FIRST NAME, SURNAME ERRORS -->

EOT;
    if (isset($errorFirstName)) {    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="firstName.errors" class="errorItems">$errorFirstName</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsFirstName = "errorField";
    } else {
    	$classFieldsFirstName = "inputFields";
    }
   	if (isset($firstName)) $htmlFirstName = stripslashes ($firstName);
   	else $htmlFirstName = "";

    if (isset($errorSurname)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="surname.errors" class="errorItems">$errorSurname</span>
						</span>
					</div>
					<div class="spacer" />


EOT;
    	$classFieldsSurname = "errorField";
    } else {
    	$classFieldsSurname = "inputFields";
    }
   	if (isset($surname)) $htmlSurname = stripslashes ($surname);
   	else $htmlSurname = "";
    echo <<<EOT

			<!-- NAME -->

			<div>

				<span class="fieldName" style="padding-top:23px;">Полное имя</span>

				<table border="0">
					<tr class="fieldNameSuper">
						<td>Титул</td>
						<td>Имя</td>
						<td>Фамилия</td>
					</tr>
					<tr>
						<td>
							<select id="title" name="title" class="inputFields" style="margin-top:0px;">
								<option value="MR">Господин</option><option value="MISS">Госпожа</option>
							</select>
						</td>

						<td><input id="firstName" name="firstName" class="$classFieldsFirstName" style="width:148px;margin-top:0px;" type="text" value="$htmlFirstName"/></td>

						<td><input id="surname" name="surname" class="$classFieldsSurname" style="width:148px;margin-top:0px;" type="text" value="$htmlSurname"/></td>

					</tr>
				</table>

			</div>

			<div class="fieldSpacer10" />

			<!-- DATE OF BIRTH ERRORS -->

EOT;
    if (isset($errorDateOfBirthDay)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="dateOfBirth.day.errors" class="errorItems">$errorDateOfBirthDay</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsDateOfBirthDay = "errorField";
    } else {
    	$classFieldsDateOfBirthDay = "inputFields";
	}
   	if (isset($dateOfBirth_day)) $htmlDateOfBirth_day = stripslashes ($dateOfBirth_day);
   	else $htmlDateOfBirth_day = "";

    for ($m=1; $m<=12; $m++)		if (isset($dateOfBirth_month)&&($m==$dateOfBirth_month)) $htmlMonth[$m] = " selected=\"selected\"";
	    else $htmlMonth[$m] = "";

    if (isset($errorDateOfBirthYear)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="dateOfBirth.year.errors" class="errorItems">$errorDateOfBirthYear</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsDateOfBirthYear = "errorField";
    } else {
    	$classFieldsDateOfBirthYear = "inputFields";
    }
   	if (isset($dateOfBirth_year)) $htmlDateOfBirth_year = stripslashes ($dateOfBirth_year);
   	else $htmlDateOfBirth_year = "";
    echo <<<EOT

			<!-- DATE OF BIRTH -->
			<div>
				<span class="fieldName" style="padding-top:23px;">Дата рождения</span>


					<table border="0">
						<tr>
							<td>дд</td>
							<td>месяц</td>
							<td>гггг</td>
							<td width="90%"/>
						</tr>
						<tr>

							<td><input id="dateOfBirth.day" name="dateOfBirth.day" class="$classFieldsDateOfBirthDay" style="width:26px;margin-top:0px;" type="text" value="$htmlDateOfBirth_day"/></td>

							<td>
								<select id="dateOfBirth.month" name="dateOfBirth.month" class="inputFields" style="width:97px;margin-top:0px;">
									<option value="01"${htmlMonth[1]}>Январь</option>
									<option value="02"${htmlMonth[2]}>Февраль</option>
									<option value="03"${htmlMonth[3]}>Март</option>
									<option value="04"${htmlMonth[4]}>Апрель</option>
									<option value="05"${htmlMonth[5]}>Май</option>
									<option value="06"${htmlMonth[6]}>Июнь</option>
									<option value="07"${htmlMonth[7]}>Июль</option>
									<option value="08"${htmlMonth[8]}>Август</option>
									<option value="09"${htmlMonth[9]}>Сентябрь</option>
									<option value="10"${htmlMonth[10]}>Октябрь</option>
									<option value="11"${htmlMonth[11]}>Ноябрь</option>
									<option value="12"${htmlMonth[12]}>Декабрь</option>
								</select>
							</td>

							<td><input id="dateOfBirth.year" name="dateOfBirth.year" class="$classFieldsDateOfBirthYear" style="width:38px;margin-top:0px;" type="text" value="$htmlDateOfBirth_year"/></td>

							<td/>
						</tr>
						<tr>
							<td valign="top">
								<img src="./images/18red_plus_25px.gif" border="0" alt="18+" title="18+" />
							</td>
							<td colspan="3">
								<a href="javascript:getWindow(49,'http://sports.betfair.com/myaccount/account/registration/AgeRestriction.do', 0, 250, 300);" class="bodyStatLnkSm">Только старше 18 лет</a>&nbsp;
								<span class="bodyTxtSm">
									На основании наших правил, Ваша дата рождения и другие личные данные могут быть подтверждены независимо. Ограничения на использование Вашего счета Betfair могут быть наложены до момента подтверждения Вашего возраста.
								</span>
							</td>
						</tr>
					</table>


			</div>

			<!--  Used for under age validation -->
			<input id="under18" name="under18" type="hidden" value="false"/>

			<div class="fieldSpacer10" />

			<!-- CONTACT NUMBER ERRORS -->

EOT;
    if (isset($errorContactNumber)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="contactNumber.number.errors" class="errorItems">$errorContactNumber</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsContactNumber = "errorField";
    } else {
    	$classFieldsContactNumber = "inputFields";
    }
   	if (isset($contactNumber)) $htmlContactNumber = stripslashes ($contactNumber);
   	else $htmlContactNumber = "";
    echo <<<EOT

			<!-- CONTACT NUMBER -->
			<div>
				<span class="fieldName" style="padding-top:6px;">Контактный телефон</span>

				<table>
					<tr>

						<td><input id="contactNumber.number" name="contactNumber.number" class="$classFieldsContactNumber" style="width:137px;" type="text" value="$htmlContactNumber"/></td>

						<td>
							<span class="bodyTxtSm">
								Мы свяжемся с Вами только в случае необходимости, относительно администрирования Вашего счета.
							</span>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="bodyTxtSm">
							Пожалуйста, вводите цифры телефона без пробелов.
						</td>
					</tr>
				</table>
			</div>

			<div class="fieldSpacer20" />


			<!-- EMAIL ERRORS -->

EOT;
    if (isset($errorEmailAddress)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="emailAddress.errors" class="errorItems">$errorEmailAddress</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsEmailAddress = "errorField";
    } else
    	$classFieldsEmailAddress = "inputFields";
   	if (isset($emailAddress)) $htmlEmailAddress = stripslashes ($emailAddress);
   	else $htmlEmailAddress = "";
    echo <<<EOT

			<!-- EMAIL -->
			<span class="fieldName">E-mail</span>

			<span class="fieldValue">

					<input id="emailAddress" name="emailAddress" class="$classFieldsEmailAddress" style="width:238px;" type="text" value="$htmlEmailAddress"/>

					<a href="javascript:getWindow(31,'http://content.betfair.com/aboutus/?sWhichKey=Privacy%20Policy',0,500,788)" tabIndex="999" class="bodyStatLnk" >
						Политика конфиденциальности Betfair
					</a>
			</span>

			<div class="fieldSpacer5" />


			<!-- CONFIRM EMAIL ERRORS -->

EOT;
    if (isset($errorConfirmEmailAddress)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="confirmEmailAddress.errors" class="errorItems">$errorConfirmEmailAddress</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsConfirmEmailAddress = "errorField";
    } elseif (isset($errorEmailConfirm)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="confirmEmailAddress.errors" class="errorItems">$errorEmailConfirm</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsConfirmEmailAddress = "errorField";
    } else
    	$classFieldsConfirmEmailAddress = "inputFields";
   	if (isset($confirmEmailAddress)) $htmlConfirmEmailAddress = stripslashes ($confirmEmailAddress);
   	else $htmlConfirmEmailAddress = "";
    echo <<<EOT

			<!-- CONFIRM EMAIL -->
			<span class="fieldName">Подтверждение E-mail</span>

			<span class="fieldValue">

				<input id="confirmEmailAddress" name="confirmEmailAddress" class="$classFieldsConfirmEmailAddress" style="width:238px;" type="text" value="$htmlConfirmEmailAddress"/>

			</span>

			<div class="fieldSpacer10" />


			<!-- COMMUNICATION PREFS -->

			<span class="fieldName"></span>

			<table border="0">
				<tr valign="center">
					<td>	<input id="userOptIn" name="communicationOptIn" type="radio" value="true" checked="checked"/></td>
					<td>	Да</td>
					<td>	<input id="userOptOut" name="communicationOptIn" type="radio" value="false"/></td>
					<td>	Нет	</td>
					<td width="10px"></td>
					<td class="bodyTxtBold">	Я хочу получать информацию о предложениях от Betfair</td>
				</tr>
				<tr>
					<td colspan="5"/>
					<td class="bodyTxtSm">
						Вы сможете изменить предпочтение в будущем. Мы не предоставляем ваши данные третьим лицам.
					</td>
				</tr>
			</table>

			<div class="fieldSpacer10" />

	</div>


		<div class="sectionSpacer" />

		<!--  ADDRESS DETAILS TITLE BAR -->
    <div class="personalDetails">

	<div class="l">
		<div class="r">
			<div class="bi">
				<span class="title">Адрес</span>
			</div>
		</div>
	</div>

	<div class="fieldSpacer10"/>


	<!-- Hidden value that keeps track of if they address was entered manually -->
	<input id="addressManualEntry" name="addressManualEntry" type="hidden" value="false"/>



	<!-- COUNTRY OF RESIDENCE ERRORS -->

EOT;
    if (isset($errorCountryOfResidence)) {
    	echo <<<EOT

 					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="countryOfResidence.errors" class="errorItems">$errorCountryOfResidence</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    }
    echo <<<EOT

	<span class="fieldName">Страна</span>

	<!-- LIST OF COUNTRIES -->
	<span class="fieldValue">
		<select id="countryOfResidenceList" name="countryOfResidenceList" class="inputFields">

				<option id="AU" name="Австралия" value="AU">Австралия</option>

				<option id="AT" name="Австрия" value="AT">Австрия</option>

				<option id="AZ" name="Азербайджан" value="AZ">Азербайджан</option>

				<option id="AL" name="Албания" value="AL">Албания</option>

				<option id="DZ" name="Алжир" value="DZ">Алжир</option>

				<option id="AI" name="Ангилья" value="AI">Ангилья</option>

				<option id="AO" name="Ангола" value="AO">Ангола</option>

				<option id="AD" name="Андорра" value="AD">Андорра</option>

				<option id="AQ" name="Антарктида" value="AQ">Антарктида</option>

				<option id="AG" name="Антигуа и Барбуда" value="AG">Антигуа и Барбуда</option>

				<option id="AN" name="Антильские острова (Нид.)" value="AN">Антильские острова (Нид.)</option>

				<option id="AR" name="Аргентина" value="AR">Аргентина</option>

				<option id="AM" name="Армения" value="AM">Армения</option>

				<option id="AW" name="Аруба" value="AW">Аруба</option>

				<option id="AF" name="Афганистан" value="AF">Афганистан</option>

				<option id="BS" name="Багамы" value="BS">Багамы</option>

				<option id="BD" name="Бангладеш" value="BD">Бангладеш</option>

				<option id="BB" name="Барбадос" value="BB">Барбадос</option>

				<option id="BH" name="Бахрейн" value="BH">Бахрейн</option>

				<option id="BZ" name="Белиз" value="BZ">Белиз</option>

				<option id="BY" name="Белоруссия" value="BY">Белоруссия</option>

				<option id="BE" name="Бельгия" value="BE">Бельгия</option>

				<option id="BJ" name="Бенин" value="BJ">Бенин</option>

				<option id="BM" name="Бермуды" value="BM">Бермуды</option>

				<option id="BG" name="Болгария" value="BG">Болгария</option>

				<option id="BO" name="Боливия" value="BO">Боливия</option>

				<option id="BA" name="Босния и Герцеговина" value="BA">Босния и Герцеговина</option>

				<option id="BW" name="Ботсвана" value="BW">Ботсвана</option>

				<option id="BR" name="Бразилия" value="BR">Бразилия</option>

				<option id="IO" name="Британские Территории в Индийском Океане" value="IO">Британские Территории в Индийском Океане</option>

				<option id="BN" name="Бруней" value="BN">Бруней</option>

				<option id="BF" name="Буркина-Фасо" value="BF">Буркина-Фасо</option>

				<option id="BI" name="Бурунди" value="BI">Бурунди</option>

				<option id="BT" name="Бутан" value="BT">Бутан</option>

				<option id="VU" name="Вануату" value="VU">Вануату</option>

				<option id="VA" name="Ватикан" value="VA">Ватикан</option>

				<option id="GB" name="Великобритания" value="GB">Великобритания</option>

				<option id="HU" name="Венгрия" value="HU">Венгрия</option>

				<option id="VE" name="Венесуэла" value="VE">Венесуэла</option>

				<option id="VG" name="Виргинские острова (Брит.)" value="VG">Виргинские острова (Брит.)</option>

				<option id="VN" name="Вьетнам" value="VN">Вьетнам</option>

				<option id="GA" name="Габон" value="GA">Габон</option>

				<option id="HT" name="Гаити" value="HT">Гаити</option>

				<option id="GY" name="Гайана" value="GY">Гайана</option>

				<option id="GM" name="Гамбия" value="GM">Гамбия</option>

				<option id="GH" name="Гана" value="GH">Гана</option>

				<option id="GT" name="Гватемала" value="GT">Гватемала</option>

				<option id="GN" name="Гвинея" value="GN">Гвинея</option>

				<option id="GW" name="Гвинея-Бисау" value="GW">Гвинея-Бисау</option>

				<option id="DE" name="Германия" value="DE">Германия</option>

				<option id="GI" name="Гибралтар" value="GI">Гибралтар</option>

				<option id="NL" name="Голландия" value="NL">Голландия</option>

				<option id="HN" name="Гондурас" value="HN">Гондурас</option>

				<option id="GD" name="Гренада" value="GD">Гренада</option>

				<option id="GL" name="Гренландия" value="GL">Гренландия</option>

				<option id="GR" name="Греция" value="GR">Греция</option>

				<option id="GE" name="Грузия" value="GE">Грузия</option>

				<option id="DK" name="Дания" value="DK">Дания</option>

				<option id="DJ" name="Джибути" value="DJ">Джибути</option>

				<option id="DM" name="Доминика" value="DM">Доминика</option>

				<option id="DO" name="Доминиканская Республика" value="DO">Доминиканская Республика</option>

				<option id="EG" name="Египет" value="EG">Египет</option>

				<option id="ZM" name="Замбия" value="ZM">Замбия</option>

				<option id="EH" name="Западная Сахара" value="EH">Западная Сахара</option>

				<option id="WS" name="Западное Самоа" value="WS">Западное Самоа</option>

				<option id="ZW" name="Зимбабве" value="ZW">Зимбабве</option>

				<option id="IL" name="Израиль" value="IL">Израиль</option>

				<option id="IN" name="Индия" value="IN">Индия</option>

				<option id="ID" name="Индонезия" value="ID">Индонезия</option>

				<option id="JO" name="Иордания" value="JO">Иордания</option>

				<option id="IQ" name="Ирак" value="IQ">Ирак</option>

				<option id="IR" name="Иран" value="IR">Иран</option>

				<option id="IE" name="Ирландия" value="IE">Ирландия</option>

				<option id="IS" name="Исландия" value="IS">Исландия</option>

				<option id="ES" name="Испания" value="ES">Испания</option>

				<option id="IT" name="Италия" value="IT">Италия</option>

				<option id="YE" name="Йемен" value="YE">Йемен</option>

				<option id="CV" name="Кабо-Верде" value="CV">Кабо-Верде</option>

				<option id="KZ" name="Казахстан" value="KZ">Казахстан</option>

				<option id="KY" name="Каймановы острова" value="KY">Каймановы острова</option>

				<option id="KH" name="Камбоджа" value="KH">Камбоджа</option>

				<option id="CM" name="Камерун" value="CM">Камерун</option>

				<option id="CA" name="Канада" value="CA">Канада</option>

				<option id="QA" name="Катар" value="QA">Катар</option>

				<option id="KE" name="Кения" value="KE">Кения</option>

				<option id="CY" name="Кипр" value="CY">Кипр</option>

				<option id="KG" name="Киргизия" value="KG">Киргизия</option>

				<option id="KI" name="Кирибати" value="KI">Кирибати</option>

				<option id="CC" name="Кокосовые(Килинг) острова" value="CC">Кокосовые(Килинг) острова</option>

				<option id="CO" name="Колумбия" value="CO">Колумбия</option>

				<option id="KM" name="Коморские острова" value="KM">Коморские острова</option>

				<option id="CD" name="Конго" value="CD">Конго</option>

				<option id="CR" name="Коста-Рика" value="CR">Коста-Рика</option>

				<option id="CI" name="Кот-д'Ивуар" value="CI">Кот-д'Ивуар</option>

				<option id="CU" name="Куба" value="CU">Куба</option>

				<option id="KW" name="Кувейт" value="KW">Кувейт</option>

				<option id="LA" name="Лаос" value="LA">Лаос</option>

				<option id="LV" name="Латвия" value="LV">Латвия</option>

				<option id="LS" name="Лесото" value="LS">Лесото</option>

				<option id="LR" name="Либерия" value="LR">Либерия</option>

				<option id="LB" name="Ливан" value="LB">Ливан</option>

				<option id="LY" name="Ливия" value="LY">Ливия</option>

				<option id="LT" name="Литва" value="LT">Литва</option>

				<option id="LI" name="Лихтенштейн" value="LI">Лихтенштейн</option>

				<option id="LU" name="Люксембург" value="LU">Люксембург</option>

				<option id="MU" name="Маврикий" value="MU">Маврикий</option>

				<option id="MR" name="Мавритания" value="MR">Мавритания</option>

				<option id="MG" name="Мадагаскар" value="MG">Мадагаскар</option>

				<option id="MO" name="Макао" value="MO">Макао</option>

				<option id="MK" name="Македония" value="MK">Македония</option>

				<option id="MW" name="Малави" value="MW">Малави</option>

				<option id="MY" name="Малайзия" value="MY">Малайзия</option>

				<option id="ML" name="Мали" value="ML">Мали</option>

				<option id="MV" name="Мальдивы" value="MV">Мальдивы</option>

				<option id="MT" name="Мальта" value="MT">Мальта</option>

				<option id="MA" name="Марокко" value="MA">Марокко</option>

				<option id="MH" name="Маршаловы острова" value="MH">Маршаловы острова</option>

				<option id="MX" name="Мексика" value="MX">Мексика</option>

				<option id="MZ" name="Мозамбик" value="MZ">Мозамбик</option>

				<option id="MD" name="Молдавия" value="MD">Молдавия</option>

				<option id="MC" name="Монако" value="MC">Монако</option>

				<option id="MN" name="Монголия" value="MN">Монголия</option>

				<option id="MS" name="Монтсеррат" value="MS">Монтсеррат</option>

				<option id="MM" name="Мьянма" value="MM">Мьянма</option>

				<option id="NA" name="Намибия" value="NA">Намибия</option>

				<option id="NR" name="Науру" value="NR">Науру</option>

				<option id="NP" name="Непал" value="NP">Непал</option>

				<option id="NE" name="Нигер" value="NE">Нигер</option>

				<option id="NG" name="Нигерия" value="NG">Нигерия</option>

				<option id="NI" name="Никарагуа" value="NI">Никарагуа</option>

				<option id="NU" name="Ниуэ" value="NU">Ниуэ</option>

				<option id="NZ" name="Новая Зеландия" value="NZ">Новая Зеландия</option>

				<option id="NC" name="Новая Каледония" value="NC">Новая Каледония</option>

				<option id="NO" name="Норвегия" value="NO">Норвегия</option>

				<option id="AE" name="Объединенные Арабские Эмираты ( ОАЭ)" value="AE">Объединенные Арабские Эмираты ( ОАЭ)</option>

				<option id="OM" name="Оман" value="OM">Оман</option>

				<option id="BV" name="Остров Буве" value="BV">Остров Буве</option>

				<option id="NF" name="Остров Норфолк" value="NF">Остров Норфолк</option>

				<option id="CX" name="Остров Рождества" value="CX">Остров Рождества</option>

				<option id="SH" name="Остров Святой Елены" value="SH">Остров Святой Елены</option>

				<option id="CK" name="Острова Кука" value="CK">Острова Кука</option>

				<option id="HM" name="Острова Херда и Маккдонольда" value="HM">Острова Херда и Маккдонольда</option>

				<option id="PK" name="Пакистан" value="PK">Пакистан</option>

				<option id="PW" name="Палау" value="PW">Палау</option>

				<option id="PS" name="Палестина" value="PS">Палестина</option>

				<option id="PA" name="Панама" value="PA">Панама</option>

				<option id="PG" name="Папуа-Новая Гвинея" value="PG">Папуа-Новая Гвинея</option>

				<option id="PY" name="Парагвай" value="PY">Парагвай</option>

				<option id="PE" name="Перу" value="PE">Перу</option>

				<option id="PN" name="Питкерн" value="PN">Питкерн</option>

				<option id="PL" name="Польша" value="PL">Польша</option>

				<option id="PT" name="Португалия" value="PT">Португалия</option>

				<option id="RU" name="Россия" value="RU">Россия</option>

				<option id="RW" name="Руанда" value="RW">Руанда</option>

				<option id="RO" name="Румыния" value="RO">Румыния</option>

				<option id="SV" name="Сальвадор" value="SV">Сальвадор</option>

				<option id="SM" name="Сан-Марино" value="SM">Сан-Марино</option>

				<option id="ST" name="Сан-Томе и Принсипи" value="ST">Сан-Томе и Принсипи</option>

				<option id="SA" name="Саудовская Аравия" value="SA">Саудовская Аравия</option>

				<option id="SZ" name="Свазиленд" value="SZ">Свазиленд</option>

				<option id="KP" name="Северная Корея" value="KP">Северная Корея</option>

				<option id="SC" name="Сейшельские острова" value="SC">Сейшельские острова</option>

				<option id="SN" name="Сенегал" value="SN">Сенегал</option>

				<option id="VC" name="Сент Винсент и Гренадины" value="VC">Сент Винсент и Гренадины</option>

				<option id="KN" name="Сент-Китс и Невис" value="KN">Сент-Китс и Невис</option>

				<option id="LC" name="Сент-Люсия" value="LC">Сент-Люсия</option>

				<option id="CS" name="Сербия и Черногория" value="CS">Сербия и Черногория</option>

				<option id="SG" name="Сингапур" value="SG">Сингапур</option>

				<option id="SY" name="Сирия" value="SY">Сирия</option>

				<option id="SK" name="Словакия" value="SK">Словакия</option>

				<option id="SI" name="Словения" value="SI">Словения</option>

				<option id="SB" name="Соломоновы Острова" value="SB">Соломоновы Острова</option>

				<option id="SO" name="Сомали" value="SO">Сомали</option>

				<option id="SD" name="Судан" value="SD">Судан</option>

				<option id="SR" name="Суринам" value="SR">Суринам</option>

				<option id="SL" name="Сьерра-Леоне" value="SL">Сьерра-Леоне</option>

				<option id="TJ" name="Таджикистан" value="TJ">Таджикистан</option>

				<option id="TH" name="Таиланд" value="TH">Таиланд</option>

				<option id="TW" name="Тайвань" value="TW">Тайвань</option>

				<option id="TZ" name="Танзания" value="TZ">Танзания</option>

				<option id="TC" name="Теркс и Кайкос острова" value="TC">Теркс и Кайкос острова</option>

				<option id="TL" name="Тимор" value="TL">Тимор</option>

				<option id="TG" name="Того" value="TG">Того</option>

				<option id="TK" name="Токелау" value="TK">Токелау</option>

				<option id="TO" name="Тонга" value="TO">Тонга</option>

				<option id="TT" name="Тринидад и Тобаго" value="TT">Тринидад и Тобаго</option>

				<option id="TV" name="Тувалу" value="TV">Тувалу</option>

				<option id="TN" name="Тунис" value="TN">Тунис</option>

				<option id="TM" name="Туркмения" value="TM">Туркмения</option>

				<option id="TR" name="Турция" value="TR">Турция</option>

				<option id="UG" name="Уганда" value="UG">Уганда</option>

				<option id="UZ" name="Узбекистан" value="UZ">Узбекистан</option>

				<option id="UA" name="Украина" value="UA">Украина</option>

				<option id="WF" name="Уоллис и Футуна" value="WF">Уоллис и Футуна</option>

				<option id="UY" name="Уругвай" value="UY">Уругвай</option>

				<option id="FO" name="Фарое острова" value="FO">Фарое острова</option>

				<option id="FM" name="Федеративные Штаты Микронезий" value="FM">Федеративные Штаты Микронезий</option>

				<option id="FJ" name="Фиджи" value="FJ">Фиджи</option>

				<option id="PH" name="Филиппины" value="PH">Филиппины</option>

				<option id="FI" name="Финляндия" value="FI">Финляндия</option>

				<option id="FK" name="Фолклендские  острова" value="FK">Фолклендские  острова</option>

				<option id="PF" name="Французская Полинезия" value="PF">Французская Полинезия</option>

				<option id="TF" name="Французские Южные территории" value="TF">Французские Южные территории</option>

				<option id="HR" name="Хорватия" value="HR">Хорватия</option>

				<option id="CF" name="Центральноафриканская республика" value="CF">Центральноафриканская республика</option>

				<option id="TD" name="Чад" value="TD">Чад</option>

				<option id="CZ" name="Чехия" value="CZ">Чехия</option>

				<option id="CL" name="Чили" value="CL">Чили</option>

				<option id="CH" name="Швейцария" value="CH">Швейцария</option>

				<option id="SE" name="Швеция" value="SE">Швеция</option>

				<option id="SJ" name="Шпицберген и Ян-Майен" value="SJ">Шпицберген и Ян-Майен</option>

				<option id="LK" name="Шри-Ланка" value="LK">Шри-Ланка</option>

				<option id="EC" name="Эквадор" value="EC">Эквадор</option>

				<option id="GQ" name="Экваториальная Гвинея" value="GQ">Экваториальная Гвинея</option>

				<option id="ER" name="Эритрея" value="ER">Эритрея</option>

				<option id="EE" name="Эстония" value="EE">Эстония</option>

				<option id="ET" name="Эфиопия" value="ET">Эфиопия</option>

				<option id="KR" name="Южная Корея  " value="KR">Южная Корея  </option>

				<option id="ZA" name="Южно-Африканская Республика (ЮАР)" value="ZA">Южно-Африканская Республика (ЮАР)</option>

				<option id="JM" name="Ямайка" value="JM">Ямайка</option>

		</select>
	</span>


	<div class="fieldSpacer10" />


	<div style="padding-bottom:5px;">
		<span class="fieldName"></span>
		<span class="fieldValue" style="float:left;display:block;width:500px;">Нам необходимо знать ваш адрес для проверки личности клиента и обеспечения безопасности сайта. </span>
		<input id="countryOfResidence" name="countryOfResidence" type="hidden" value="UA"/>
	</div>

	<div class="spacer" />


	<!-- SPINNER BLOCK -->
	<div id="spinner" style="display:none;">
		<span class="fieldName"></span>
		<span class="fieldValue"><img src="./images/indicator.gif" alt="Loading..." /></span>
	</div>


	<div class="spacer" ></div>

	<div id="zipCodeMessage" style="display:none;padding-bottom:10px;">
		<span class="fieldName"></span>
		<span class="fieldNote">
			<span class="bodyTxt">
				Пожалуйста, заполните поля ниже или
				<a href="javascript:clearErrors('true');prepForOtherLocale('false');" class="bodyStatLnk">введите адрес вручную</a>
			</span>
		</span>
	</div>


	<div class="spacer" />

	<!-- ADDRESS ENTRY FIELDS -->
	<div id="addressRows" style="display:none;padding-top:10px;">

		<div id="addressFullLine1" style="padding-bottom:5px;">

        <!-- ADDRESS ENTRY ERRORS -->

EOT;
    if (isset($errorAdress)) {
    	echo <<<EOT

					<div id="address1_mainError" style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="address.address1.errors" class="errorItems">$errorAdress</span>
						</span>
					</div>

EOT;
    	$classFieldsAddress1 = "errorField";
    } else
    	$classFieldsAddress1 = "inputFields";
   	if (isset($adress)) $htmlAdress = stripslashes ($adress);
   	else $htmlAdress = "";
    echo <<<EOT

			<div style="clear:left;">
				<span class="fieldName"><span id="address1CheckText">Адрес</span></span>

				<span class="fieldValue"><input id="address1" name="address.address1" class="$classFieldsAddress1" style="width:203px;" type="text" value="$htmlAdress"/></span>

			</div>

		</div>

		<div id="townFullLine" style="clear:left;padding-bottom:5px;">

EOT;
    if (isset($errorTown)) {
    	echo <<<EOT

					<div id="town_mainError" style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="address.town.errors" class="errorItems">$errorTown</span>
						</span>
					</div>
EOT;
    	$classFieldsTown = "errorField";
    } else
    	$classFieldsTown = "inputFields";
   	if (isset($town)) $htmlTown = stripslashes ($town);
   	else $htmlTown = "";
   	if (isset($county)) $htmlCounty = stripslashes ($county);
   	else $htmlCounty = "";
   	if (isset($zipCode)) $htmlZipCode = stripslashes ($zipCode);
   	else $htmlZipCode = "";
    echo <<<EOT

			<div style="clear:left;">
				<span class="fieldName"><span id="townCheckText">Город</span></span>

				<span class="fieldValue"><input id="town" name="address.town" class="$classFieldsTown" style="width:203px;" type="text" value="$htmlTown"/></span>

			</div>

		</div>

		<div id="countyFullLine" style="clear:left;padding-bottom:5px;">
			<div id="county_textfield" style="display:none;clear:left;" >
				<span class="fieldName"><span id="countyCheckText">Область</span></span>

				<span class="fieldValue"><input id="county" name="address.county" class="inputFields" style="width:203px;" type="text" value="$htmlCounty"/></span>

				<span class="fieldValue"><span class="bodyTxt">необязательно</span></span>
			</div>
		</div>
	</div>

	<div class="spacer" />


	<!-- ZIPCODE SECTION -->
	<div id="zipCodeRows" style="display:none;clear:left;">

		<!-- ZipCode Error -->



		<!-- ZipCode No Matching Error -->
		<div id="zipCodeNoMatchingAddressMessage" style="display:none;clear:left;">
			<span class="fieldName"></span>
			<span class="errorMessage">
				<span class="errorItems" style="float:left;display:block;width:500px;">
					Мы не можем найти ни одного адреса соответствующего данному почтовому индексу. Пожалуйста, проверьте данные и попробуйте снова, так же Вы можете
					<a href="javascript:prepForOtherLocale('true');clearErrors('true');" class="bodyBetLnk">ввести адрес вручную</a>.
				</span>
			</span>
		</div>


		<!-- ZipCode Missing Error -->
		<div id="zipCodeMissingMessage" style="display:none;clear:left;">
			<span class="fieldName"></span>
			<span class="errorMessage">
				<span class="errorItems" style="float:left;display:block;width:500px;">
					Введите Ваш почтовый индекс.
				</span>
			</span>
		</div>

		<!-- ZipCode Missing Error -->
		<div id="zipCodeInvalidMessage" style="display:none;clear:left;">
			<span class="fieldName"></span>
			<span class="errorMessage">
				<span class="errorItems" style="float:left;display:block;width:500px;">
					Данный почтовый индекс недействительный.  Пожалуйста, попробуйте снова.
				</span>
			</span>
		</div>

		<div style="clear:left;" >
			<span class="fieldName"><span id="postcodeCheckText">Почтовый индекс</span></span>

			<span class="fieldValue"><input id="zipCode" name="address.zipCode" class="inputFields" style="width:74px;" type="text" value="$htmlZipCode"/></span>

		</div>
	</div>
    </div>

	<div id="avsLookupButton" style="display:none;clear:left;">
		<div style="padding-top:5px;">
			<span class="fieldName"></span>
			<span class="fieldValue"><input type="button" value='Искать' id="Registration.ButtonName.LookUp" class="bodyTxtBold" style="margin-right:10px;" /></span>
		</div>
	</div>




	<!-- ADDRESS LABEL ROWS-->
	<div id="addressRowsLabels" style="display:none;clear:left;padding-top:15px;">

		<div style="clear:left;"/>

			<span class="basicFieldName">&nbsp;Адрес</span>

			<table>
				<tr>
					<td>
						<span id="address1_label" class="bodyTxt" style="margin-right:50px;"></span>
					</td>
					<td>
						<a id="amendAddress" href="javascript:$('addressManualEntry').value = 'true'; clearErrors('true'); Element.hide('addressRowsLabels'); Element.show('addressRows'); Element.show('zipCodeRows');" class="bodyStatLnk">Редактировать адрес</a>
						<span class="bodyTxt">или</span>
						<a href="javascript:prepForGBLocale('true');clearErrors('true');" class="bodyStatLnk">поиск</a>
					</td>
				</tr>
			</table>

		</div>


		<div style="clear:left;">
			<div id="address2_label_tag" style="display:none;padding-top:7px;">
				<span class="basicFieldName">&nbsp;&nbsp;</span>
				<span class="basicFieldValue"><span id="address2_label" class="bodyTxt" style="text-align:left;margin-right:30px;margin-left:3px;"></span></span>
			</div>
		</div>

		<div style="clear:left;padding-top:7px;">
			<span class="basicFieldName">&nbsp;Город</span>
			<span class="basicFieldValue"><span id="town_label" class="bodyTxt" style="text-align:left;margin-right:30px;margin-left:3px;"></span></span>
		</div>


		<div style="clear:left;">
			<div id="county_label_tag" style="display:none;padding-top:7px;">
				<span class="basicFieldName">&nbsp;Область</span>
				<span class="basicFieldValue"><span id="county_label" class="bodyTxt" style="text-align:left;margin-right:30px;margin-left:3px;"></span></span>
			</div>
		</div>


		<div style="clear:left;padding-top:7px;">
			<span class="basicFieldName">&nbsp;Почтовый индекс</span>
			<span class="basicFieldValue"><span id="postcode_label" class="bodyTxt" style="text-align:left;margin-right:30px;margin-left:3px;"></span></span>
		</div>

	</div>


	<!-- ADDRESS SELECTION LIST -->
	<div id="addressSelectorRow" style="clear:left;display:none;padding-top:10px;">

		<div style="clear:left;padding-top:5px;">
			<span class="fieldName"></span>
			<span class="fieldValue"><select name="addressSelector" id="addressSelector" size="0" class="inputFields"></select></span>
		</div>


		<div style="clear:left;padding-top:5px;">
			<span class="fieldName"></span>

			<span class="fieldValue">
				<input type="button" id="selectAddressButton" class="bodyTxtBold" value='Выбор' />
			</span>
		</div>


		<div style="clear:left;padding-top:5px;">
			<span class="fieldName"></span>

			<span class="fieldValue">
				Или
				<a href="javascript:prepForOtherLocale('true');clearErrors('true');">введите адрес вручную</a>
				или
				<a href="javascript:prepForGBLocale('true');clearErrors('true');">поиск</a>
			</span>
		</div>
	</div>


	<div class="fieldSpacer15" />
    </div>


		<div class="sectionSpacer" />

				<!-- PERSONAL DETAILS BLOCK -->
		<div class="personalDetails" >

			<div class="l">
				<div class="r">
					<div class="bi"><span class="title">Данные счета Betfair</span></div>
				</div>
			</div>


			<div class="fieldSpacer10"></div>


			<!-- USERNAME ERRORS -->

EOT;
    if (isset($errorUsername)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="username.errors" class="errorItems">$errorUsername</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsUsername = "errorField";
    } else
    	$classFieldsUsername = "inputFields";
   	if (isset($username)) $htmlUsername = stripslashes ($username);
   	else $htmlUsername = "";
    echo <<<EOT

			<!-- USERNAME -->
			<div>
				<span class="fieldName">Имя пользователя</span>

				<table cellpadding="0" border="0" >
					<tr valign="top">

						<td><input id="username" name="username" class="$classFieldsUsername" style="width:137px;" type="text" value="$htmlUsername"/></td>

						<td rowspan="2" class="bodyTxtSm" style="padding-left:15px;width:300px;">
							Вам необходимо иметь имя пользователя и пароль для входа на ваш счет и получения выигрышей.
						</td>
					</tr>
					<tr>
						<td class="bodyTxtSm" style="width:145px;">
							6-20 знаков. Чувствительно к регистру.
						</td>
					</tr>
				</table>
			</div>

			<div class="fieldSpacer5"></div>


			<!-- PASSWORD ERRORS -->

EOT;
    if (isset($errorUserpassword)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="username.errors" class="errorItems">$errorUserpassword</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsUserpassword = "errorField";
    	$classFieldsConfirmPassword = "inputFields";
    } elseif (isset($errorConfirmPassword)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="username.errors" class="errorItems">$errorConfirmPassword</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsUserpassword = "errorField";
    	$classFieldsConfirmPassword = "errorField";
    } elseif (isset($errorPasswordConfirm)) {
    	echo <<<EOT

					<div style="padding-bottom:5px;">
						<span class="fieldName"></span>
						<span class="errorMessage">
							<span id="username.errors" class="errorItems">$errorPasswordConfirm</span>
						</span>
					</div>
					<div class="spacer" />

EOT;
    	$classFieldsUserpassword = "errorField";
    	$classFieldsConfirmPassword = "errorField";
    } else {
    	$classFieldsUserpassword = "inputFields";
    	$classFieldsConfirmPassword = "inputFields";
    }
    echo <<<EOT

			<!-- PASSWORD -->
			<div style="padding-top:2px;">
				<span class="fieldName">Пароль</span>
				<table cellpadding="0" border="0" style="float:left;">
					<tbody>
						<tr valign="top">
							<td>
								<span class="fieldValue">
									<span onKeyPress="return disableCtrlKeyCombination(event);" onKeyDown="return disableCtrlKeyCombination(event);" onContextMenu="return false">
										<input id="password" name="password" class="$classFieldsUserpassword" style="width:137px;" type="password" value=""/>
									</span>
								</span>
							</td>
							<td rowspan="2" class="bodyTxtSm" style="padding-left:15px;width:200px;">
								<div id="passwordError" class="bodyTxtSm" style="display: block;">
									<div class="tooShort">Ваш пароль короткий.</div>
									<div class="tooLong">Ваш пароль слишком длинный.</div>
									<div class="validCharacters">Вы должны использовать комбинацию цифр и букв из английского алфавита.</div>
									<div class="validPassword">Ваш пароль действительный.</div>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" class="bodyTxtSm" style="width:155px;">
								<div class="bodyTxtSm" style="display:block;padding-top:5px;width:155px;">
									8-20 знаков, включая буквы и цифры.
								</div>
							</td>
						</tr>
					</tbody>
				</table>

				</span>
			</div>


			<div class="fieldSpacer5" />


			<!-- CONFIRM PASSWORD ERRORS -->



			<!-- CONFIRM PASSWORD -->
			<span class="fieldName">Подтверждение пароля</span>
				<table cellpadding="0" border="0"  style="float:left;">
					<tbody>
						<tr valign="top">
							<td>
								<span class="fieldValue">
									<span onKeyPress="return disableCtrlKeyCombination(event);" onKeyDown="return disableCtrlKeyCombination(event);" onContextMenu="return false">
										<input id="confirmPassword" name="confirmPassword" class="$classFieldsConfirmPassword" style="width:137px;" type="password" value=""/>
									</span>
								</span>
							</td>
							<td class="bodyTxtSm" style="padding-left:15px;width:200px;">
								<div id="passwordMatch"  class="bodyTxtSm" style="display: block; width: 155px;">
									<div class="noMatch">
										Пароли не совпадают.
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>

			<div class="fieldSpacer15" />

				<!-- SELECT SECURITY QUESTION 1 ERROR -->

EOT;
    if (isset($errorSelectedSecurityQuestion1)) {
    	echo <<<EOT

						<div style="padding-bottom:5px;">
							<span class="fieldName"></span>
							<span class="errorMessage">
								<span id="selectedSecurityQuestion1.errors" class="errorItems">$errorSelectedSecurityQuestion1</span>
							</span>
						</div>

EOT;
    	$classFieldsSecurityQuestion1 = "errorField";
    } else
    	$classFieldsSecurityQuestion1 = "inputFields";
    if (isset($securityQuestion1)) {    	if ($securityQuestion1=="Registration.Your.Favourite.Sports.Team") $sq1[1] = "selected=\"selected\""; else $sq1[1] = "";
    	if ($securityQuestion1=="Registration.Your.Pets.Name") $sq1[2] = "selected=\"selected\""; else $sq1[2] = "";
    	if ($securityQuestion1=="Registration.Your.Favourite.Movie") $sq1[3] = "selected=\"selected\""; else $sq1[3] = "";
    	if ($securityQuestion1=="Registration.Your.Favourite.Food") $sq1[4] = "selected=\"selected\""; else $sq1[4] = "";
    } else {    	$sq1[1]=$sq1[2]=$sq1[3]=$sq1[4]="";
    }
    echo <<<EOT

			<div>

				<!-- SECURITY QUESTIONS 1 -->
				<!-- Unfortunately these messages need to be variables because the value argument of the f:option doesn't support other tagss -->

				<span class="fieldName">Секретный вопрос 1</span>
				<table cellpadding="0" border="0" >
					<tr valign="top">
                    <td>
						<select id="securityQuestionList" name="identificationQuestion1" class="$classFieldsSecurityQuestion1">
							    <option value="invalid 1">Выбрать</option>
								<option value="Registration.Your.Favourite.Sports.Team"${sq1[1]}>Любимая спортивная команда?</option>
								<option value="Registration.Your.Pets.Name"${sq1[2]}>Имя вашего домашнего любимца ?</option>
								<option value="Registration.Your.Favourite.Movie"${sq1[3]}>Любимый фильм?</option>
								<option value="Registration.Your.Favourite.Food"${sq1[4]}>Любимое блюдо?</option>
						</select>
                    </td>
                    <td class="bodyTxtSm" style="padding-left:0px;width:500px;">
						В случае контакта с нами, мы будем использовать данную информацию для удостоверения вашей личности.
                    </td>
                    </tr>
      			</table>
			</div>


			<div style="clear:both;">
				<!-- SECURITY ANSWER 1 ERROR -->

EOT;
    if (isset($errorSecurityAnswer1)) {
    	echo <<<EOT

						<div style="padding-bottom:5px;">
							<span class="fieldName"></span>
							<span class="errorMessage"><span id="securityAnswer.errors" class="errorItems">$errorSecurityAnswer1</span></span>
						</div>
						<div class="spacer" />

EOT;
    	$classFieldsSecurityAnswer1 = "errorField";
    } else
    	$classFieldsSecurityAnswer1 = "inputFields";
   	if (isset($securityAnswer1)) $htmlSecurityAnswer1 = stripslashes ($securityAnswer1);
   	else $htmlSecurityAnswer1 = "";
    echo <<<EOT

				<!-- SECURITY ANSWER -->
				<span class="fieldName">Ваш ответ</span>
				<span class="fieldValue">
					<input id="securityAnswer" name="identificationAnswer1" class="$classFieldsSecurityAnswer1" style="width:159px;" type="text" value="$htmlSecurityAnswer1"/>
				</span>
				<div class="fieldSpacer5" />
				<span class="fieldName"></span>
				<span class="fieldValue" style="float:left;display:block;width:500px;">не более 50 знаков – только латинские буквы и пробелы.</span>

			</div>

			<div class="fieldSpacer5" />

				<!-- SELECT SECURITY QUESTION 1 ERROR -->

EOT;
    if (isset($errorSelectedSecurityQuestion2)) {
    	echo <<<EOT

						<div style="padding-bottom:5px;">
							<span class="fieldName"></span>
							<span class="errorMessage">
								<span id="selectedSecurityQuestion1.errors" class="errorItems">$errorSelectedSecurityQuestion2</span>
							</span>
						</div>

EOT;
    	$classFieldsSecurityQuestion2 = "errorField";
    } else
    	$classFieldsSecurityQuestion2 = "inputFields";
    if (isset($securityQuestion1)) {
    	if ($securityQuestion1=="Registration.Your.Favourite.Sports.Team") $sq2[1] = "selected=\"selected\""; else $sq2[1] = "";
    	if ($securityQuestion1=="Registration.Your.Pets.Name") $sq2[2] = "selected=\"selected\""; else $sq2[2] = "";
    	if ($securityQuestion1=="Registration.Your.Favourite.Movie") $sq2[3] = "selected=\"selected\""; else $sq2[3] = "";
    	if ($securityQuestion1=="Registration.Your.Favourite.Food") $sq2[4] = "selected=\"selected\""; else $sq2[4] = "";
    } else {
    	$sq2[1]=$sq2[2]=$sq2[3]=$sq2[4]="";
    }

    echo <<<EOT

			<div>

				<!-- Секретный вопрос 2 -->

				<span class="fieldName">Секретный вопрос 2</span>
				<span class="fieldValue" >
						<select name="identificationQuestion2" style="width:286px;" class="$classFieldsSecurityQuestion2">
							<option value="invalid 1">Выбрать</option>
							<option value="Registration.Your.Anniversary"${sq2[1]}>Юбилей [dd/mm/yyyy]?</option>
							<option value="Registration.Your.Partners.Birthday"${sq2[2]}>День рождения вашей супруги/вашего супруга [dd/mm/yyyy]?</option>
							<option value="Registration.Your.Mothers.Birthday"${sq2[3]}>День рождения вашей матери [dd/mm/yyyy]?</option>
							<option value="Registration.Your.Fathers.Birthday"${sq2[4]}>День рождения вашего отца [dd/mm/yyyy]?</option>
						</select>
				</span>

				<div class="fieldSpacer5" />

				<!-- SECURITY ANSWER 1 ERROR -->

EOT;
    if (isset($errorSecurityAnswer2)) {
    	echo <<<EOT

						<div style="padding-bottom:5px;">
							<span class="fieldName"></span>
							<span class="errorMessage"><span id="securityAnswer2.errors" class="errorItems">$errorSecurityAnswer2</span></span>
						</div>
						<div class="spacer" />

EOT;
    	if (isset($error_a2Day)&&$error_a2Day)
	    	$classFields_a2Day = "errorField";
    	if (isset($error_a2Month)&&$error_a2Month)
	    	$classFields_a2Month = "errorField";
    	if (isset($error_a2Year)&&$error_a2Year)
	    	$classFields_a2Year = "errorField";
    } else {
    	$classFields_a2Day = "inputFields";
    	$classFields_a2Month = "inputFields";
    	$classFields_a2Year = "inputFields";
    }
    echo <<<EOT


				<!-- SECURITY ANSWER -->
				<span class="fieldName">Ваш ответ</span>
				<span class="fieldValue">

						<select name="a2Day" class="$classFields_a2Day"><option value="invalid 1">Число</option>

EOT;
	for ($d=1; $d<=31; $d++)
		if (isset($a2Day)&&($d==$a2Day))
			echo "
							<option value=\"$d\" selected=\"selected\">$d</option>";
		else
			echo "
							<option value=\"$d\">$d</option>";

    for ($a2M=1; $a2M<=12; $a2M++)
    	if (isset($a2Month)&&($a2M==$a2Month)) $a2MonthSelected[$a2M] = " selected=\"selected\"";
    	else $a2MonthSelected[$a2M] = "";
    echo <<<EOT

							</select>

						<select name="a2Month" class="$classFields_a2Month">
							<option value="invalid 1">Месяц</option>
							<option value="01"${a2MonthSelected[1]}>Январь</option>
							<option value="02"${a2MonthSelected[2]}>Февраль</option>
							<option value="03"${a2MonthSelected[3]}>Март</option>
							<option value="04"${a2MonthSelected[4]}>Апрель</option>
							<option value="05"${a2MonthSelected[5]}>Май</option>
							<option value="06"${a2MonthSelected[6]}>Июнь</option>
							<option value="07"${a2MonthSelected[7]}>Июль</option>
							<option value="08"${a2MonthSelected[8]}>Август</option>
							<option value="09"${a2MonthSelected[9]}>Сентябрь</option>
							<option value="10"${a2MonthSelected[10]}>Октябрь</option>
							<option value="11"${a2MonthSelected[11]}>Ноябрь</option>
							<option value="12"${a2MonthSelected[12]}>Декабрь</option>
						</select>

						<select name="a2Year" class="$classFields_a2Year">
							<option value="invalid 1">Год</option>
EOT;
	$startYear = date("Y", time());
	for ($i=$startYear; $i>=$startYear-100; $i--)
		if (isset($a2Year)&&($a2Year==$i))
			echo "
							<option value=\"$i\" selected=\"selected\">$i</option>";
		else
			echo "
							<option value=\"$i\">$i</option>";
    echo <<<EOT

						</select>&nbsp;<span class="GlobalAsteriskText">
                 </span>

			</div>

			<div class="fieldSpacer30" />

EOT;
    if (isset($errorCurrency)) {
    	echo <<<EOT
			<!-- CURRENCY ERROR -->

						<div style="padding-bottom:5px;">
							<span class="fieldName"></span>
							<span class="errorMessage"><span id="currency.errors" class="errorItems">$errorCurrency</span></span>
						</div>
						<div class="spacer" />
EOT;
    }
    echo <<<EOT

			<!-- CURRENCY -->
			<span class="fieldName">Валюта счета Betfair </span>
			<span class="fieldValue">
				<select id="currency" name="currency" class="inputFields">
					<option value="EUR">Евро</option>
					<option value="USD" selected="selected">Доллар США</option>
				</select>
			</span>


			<div class="fieldSpacer30" />


			<!-- PROMO CODE ERRORS -->



			<!-- PROMO CODE -->

			<div id="promoCodeSelectionEntry" style="display:none;">
				<span class="fieldName">
					<a href="javascript:getWindow(31,'https://promotions.betfair.com/football-cashback-RU',0,500,788)" tabIndex="999" class="bodyStatLnk" title="Правила промо акции">Код промо акции</a>
				</span>

				<input type="hidden" id="promoCodeYes" name="promoCodeSelection" checked/>
				<span class="fieldValue"><input id="promoReferEarnCode" name="promoReferEarnCode" class="inputFields" style="width:85px;" type="text" value="CBL420" readonly/></span>

			</div>


			<div class="fieldSpacer15" />



			<!-- TURING TEST ERRORS -->

EOT;
    if (isset($errorTuringTest)) {
    	echo <<<EOT

						<div style="padding-bottom:5px;">
							<span class="fieldName"></span>
							<span class="errorMessage"><span id="turingTest.errors" class="errorItems">$errorTuringTest</span></span>
						</div>
						<div class="spacer" />

EOT;
    	$classFieldsTuringTest = "errorField";
    } else
    	$classFieldsTuringTest = "inputFields";
    echo <<<EOT

			<!-- TURING TEST -->

			<span class="fieldName"><img src="scode.php" alt="Image" /></span>

			<span class="fieldBlock">

				<span class="fieldValue" style="padding-right:10px;">

					<input id="session_id" name="sid" type="hidden" value="$sid"/>
					<input id="turingTest" name="turingTest" class="$classFieldsTuringTest" style="width:60px;" type="text" value=""/>

				</span>

				<span class="fieldNote" style="display:block;padding-top:5px;">
					<span class="bodyTxtBold" style="padding-top:5px;">
						Пожалуйста, введите буквы/цифры представленные в левом окошке.
					</span>

					<span class="bodyTxtSm" style="display:block;padding-top:10px;padding-left:72px;">
						Это позволяет обеспечить безопасность и уверенность, что только данный пользователь (а не система) может открыть счет. Автоматическая система не может видеть слова представленные в окне слева.
					</span>
				</span>
			</span>


			<div class="fieldSpacer10" />


			<!-- PRIVACY POLICY ERRORS -->

EOT;
    if (isset($errorAgreeTermsConditionsPrivacy)) {
    	echo <<<EOT

    				<div style="padding-bottom:5px;">
					<span class="fieldName"></span>
					<span class="errorMessage" style="float:left;display:block;width:500px;">
						<span id="agreeTermsConditionsPrivacy.errors" class="errorItems">$errorAgreeTermsConditionsPrivacy</span>
					</span>
				</div>
				<div class="spacer" />
EOT;
    }
   	if (isset($agreeTermsConditionsPrivacy)&&$agreeTermsConditionsPrivacy) $htmlAgreeTermsConditionsPrivacy = " checked=\"checked\"";
   	else $htmlAgreeTermsConditionsPrivacy = "";
    echo <<<EOT


			<!-- PRIVACY POLICY -->
			<span class="fieldName"></span>

			<table cellpadding="0" border="0">
				<tr>
					<td>
						<input id="agreeTermsConditionsPrivacy1" name="agreeTermsConditionsPrivacy" style="margin-right:10px;" type="checkbox" value="true"$htmlAgreeTermsConditionsPrivacy/>
						<input type="hidden" name="_agreeTermsConditionsPrivacy" value="on"/>
					</td>
					<td>
						<span id="NormalTandC" style="display:none;">
							Я подтверждаю, что мне 18 или более лет и соглашаюсь с Betfair
							<a href="javascript:getWindow(1,'http://content.betfair.com/aboutus/?sWhichKey=Terms%20and%20Conditions',0,500,788)" class="bodyTCLink" >Условия и положения </a>
							и
							<a href="javascript:getWindow(31,'http://content.betfair.com/aboutus/?sWhichKey=Privacy%20Policy',0,500,788)" class="bodyTCLink" >Политику конфиденциальности.</a>
						</span>
						<span id="GermanTandC" style="display:none;">123</span>
					</td>
				</tr>
			</table>

			<div class="fieldSpacer20" />

			<!-- SUBMIT -->

			<span class="fieldName"></span>

			<span class="fieldValue"><input type="button" id="submitButton" value='Открыть счет' class='bodyTxtBold' onClick="validateAndSubmit();"/></span>

			<div class="fieldSpacer10" />

			<span class="fieldName"></span>

			<table class="bodyTxtSm" >
				<tr>
					<td>
						Прежде чем делать ставки на бирже, играть в покер или игры, Вам необходимо внести деньги на Ваш игровой счет.
					</td>
				</tr>
			</table>
</div>


	</div>

	<!-- This displays the hidden errors, to be removed later -->
	<span id="hidden_errors" style="color:#F0F6F7;" style="display:none;"></span>


<img id="imageTrackingTag" src="./images/spacer.gif" height=1px; width=1px; />
EOT;
	}
	echo <<<EOT

</form>
</body>
</html>
EOT;

?>