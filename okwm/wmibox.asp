<script language="PHP">
#--------------------------------------------------------------------
# OKWM help page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
$https= DOMAIN_HTTPS;





    // SEO strings
    /*$title = GetSEO("4b5af7a8ddebd9f5755d50abed72b1ab");
    if ($title=="") $title = "Зарегестрироваться, играть, пополнить счет, вывести деньги Покерстарс (Pokerstars)";
    $Description = GetSEO("cdac824f1ce0b7f32b08f7c14be7ec61");
    if ($Description=="") $description = "Описание партнерских отношений с крупнейшим Покер-рум Pokerstars.com.";
    $Keywords = GetSEO("5db31f73edf5ae8c28364482ace86eac");
    if ($Keywords=="") $keywords = "Киев, Днепропетровск, Одесса, Запорожье, Webmoney в Киеве, Наличные деньги, купить wm, WMZ, WME, продать, обмен, обменник, электронная валюта, ставки, тотализатор, букмекерския контора";
    */


    // SEO strings
    $title = GetSEO("");
    if ($title=="") $title = "";
    $Description = GetSEO("");
    if ($Description=="") $description = "";
    $Keywords = GetSEO("");
    if ($Keywords=="") $keywords = "";








// Контакты
HTMLHead ($title, $Keywords, $Description);
echo <<<EOT

	 <tr><td></td><td id="phl"><img width="1" height="4" alt="" src="$http/img/0.gif"/></td>
	     <td id="phr"><img width="210" height="4" alt="" src="$http/img/0.gif" /></td><td></td>
	     <td rowspan="5" class="right_banners">
EOT;
    if (!isset($HTTP_SERVER_VARS['HTTPS'])) EchoBaners ();
    echo <<<EOT
	 </td>
	 </tr>
	 <tr><td class="lsh"></td><td id="pbl">
       <h1>Сертификаты WMZ компании WebMoney на терминалах</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
		<div align="center"><b>Сертификаты WMZ компании WebMoney на терминалах.</b></div>
		<br />

		<p>
			Впервые на территории Украины в сети терминалов <a href="https://bnk24.com.ua/map" target="_blank">ПАО
			&bdquo;Банк 24 Национальный кредит&ldquo;</a> появилась возможность пополнять WMZ-кошельки
			путем покупки WMZ от компании WebMoney прямо на терминале - круглосуточно.<br /><br />

	        На сегодняшний день терминал стал самым удобным инструментом приема платежей для миллионов пользователей.
	        Терминальная сеть ПАО &bdquo;Банк 24 включает в себя более 4500 автоматов по приему платежей,
	        во всех регионах Украины.<br /><br />

			Пользователям платежной системы «Вебмани» не придется отдавать процент от суммы совершенной операции
			за конвертацию в соответствующую расчетную валюту, то есть титульные знаки WMZ
			и позволит сэкономить время и деньги.<br /><br />

        </p>

        <p>Для пополнения Вашего Z-кошелька титульными знаками WMZ в главном меню любого терминала сети ПАО &quot;Банк Национальный кредит&quot;
        выберите в разделе &laquo;ІНШІ КАТЕГОРІЇ&raquo; клавишу &laquo;Грошi&raquo; и выберите тип валюты &laquo;WebMoney WMZ&raquo;.</p>
        <div align="center"><img src="/img/ibox/1.png" width="400" height="321" alt="" border="0"></div>
        <p>После выбора опции &laquo;WMZ&raquo; Вам предложат ознакомиться с Договором публичной оферты.</p>
        <div align="center"><img src="/img/ibox/2.png" width="400" height="321" alt="" border="0"></div>
        <p>Согласившись с Публичной офертой, Вы можете непосредственно приступить к пополнению своего Z-кошелька. Для этого надо ввести номер
        своего кошелька в новом окне после буквы &laquo;Z&raquo; - всего 12 цифр. Перед этим Вы можете получить точную информацию о сумме средств,
        которые будут зачислены Вам на кошелек, воспользовавшись опцией &laquo;КАЛЬКУЛЯТОР&raquo;, внизу окна.</p>
        <div align="center"><img src="/img/ibox/3.png" width="400" height="321" alt="" border="0"></div>
        <p>После ввода номера кошелька, Вы переходите в новое окно, в котором будет высвечиваться сумма внесенных Вами денег
        через купюроприемник терминала.</p>
        <div align="center"><img src="/img/ibox/4.png" width="400" height="321" alt="" border="0"></div>
        <p>Следующее окно предложит Вам выбрать: нужен ли Вам чек или нет.</p>
        <div align="center"><img src="/img/ibox/5.png" width="400" height="321" alt="" border="0"></div>
        <p>И последним шагом операции станет появления окна с уведомлением об успешном окончании транзакции и суммы пополнения Z-кошелька.</p>
        <div align="center"><img src="/img/ibox/6.png" width="400" height="321" alt="" border="0"></div>

      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>