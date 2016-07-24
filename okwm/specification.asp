<?php
#--------------------------------------------------------------------
# OKWM specification page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003.
#--------------------------------------------------------------------
# Requires /lib/config.asp
# Requires /lib/currency.asp
# Requires /lib/database.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/currency.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/verifysum.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/matrix_api.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm.inc");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/mb.inc");
// Подключение массивов валют $In_Val_name, $In_Val_code, $Out_Val_name, $Out_Val_code, $Town_name
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/in_form_val.asp");

 $domain = DOMAIN_HTTPS;
 if (isset($HTTP_POST_VARS['lastname'])) $lastname = htmlspecialchars(trim($HTTP_POST_VARS['lastname'])); else $lastname = "Фамилия";
 if (isset($HTTP_POST_VARS['firstname'])) $firstname = htmlspecialchars(trim($HTTP_POST_VARS['firstname'])); else $firstname = "Имя";
 if (isset($HTTP_POST_VARS['midlename'])) $midlename = htmlspecialchars(trim($HTTP_POST_VARS['midlename'])); else $midlename = "Отчество";
 if (isset($HTTP_POST_VARS['passport'])) $passport = htmlspecialchars(trim($HTTP_POST_VARS['passport'])); else $passport = "серия номер";
 $NUAH   = "&nbsp;&nbsp;Указанная сумма передается из рук в руки в течении 24 часов.<br>
            Получатель:
            <input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
            <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
            <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20><br>
            Документ: <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20><br>
            <u>Данные подтверждаю</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $P24   = "&nbsp&nbspУказанная сумма перечисляется на указанные вами реквизиты в
            течении 24 часов. Формулировка перевода: \"агентское соглашение
            о выводе средств из системы электронных денежных расчетов Webmoney (счет Z...)\".<br>
            Ваши данные:
            <input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
            <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
            <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20>
            <hr color=#C0C0C0 size=3 noshade>";
 $d      = date ("d.m.Y");
 $n      = rand (21,99);
 $USD    = "&nbsp;&nbsp;Указанная сумма передается из рук в руки в течении 24 часов.
      Однако мы не нарушаем законодательства Украины поэтому, (на основании
      ст.44, 64, 386 Гражданского кодекса Украины) пожалуйста подтвердите
      поручение на покупку причитающейся Вам суммы  $ в уполномоченном
      банке:<br>
      <b>Договор поручение № $n  от $d г.</b><br>
      &nbsp;&nbsp;Я (<input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
      <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
      <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20>, документ
      <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20>) поручаю администрации
      OKWM.com.ua обменять причитающиеся мне при выводе из электронной системы
      платежей, денежные средства, на иностранную валюту (доллары США) в любом
      уполномоченном банке Украины.<br>
      &nbsp;&nbsp;Администрация OKWM.com.ua гарантирует выполнение данного
      поручения в течении 24 часов. Все расходы связанные с выполнением данного
      поручения уже включены в выставленный ранее счет.<br>
      <u>Договор подтверждаю</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $USD_   = "&nbsp;&nbsp;Указанная сумма передается из рук в руки в течении 24 часов.
      Однако мы не нарушаем законодательства Украины поэтому, (на основании
      ст.44, 64, 386 Гражданского кодекса Украины) пожалуйста подтвердите
      поручение на продажу переданной Вами суммы  $ в уполномоченном
      банке:<br>
      <b>Договор поручение № $n  от $d г.</b><br>
      &nbsp;&nbsp;Я (<input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
      <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
      <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20>, документ
      <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20>) поручаю администрации
      OKWM.com.ua обменять переданную мною при вводе в электронную систему
      платежей, денежные средства, с иностранной валюты (доллары США) в любом
      уполномоченном банке Украины.<br>
      &nbsp;&nbsp;Администрация OKWM.com.ua гарантирует выполнение данного
      поручения в течении 24 часов. Все расходы связанные с выполнением данного
      поручения уже включены в выставленный ранее счет.<br>
      <u>Договор подтверждаю</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $EUR    = "&nbsp;&nbsp;Указанная сумма передается из рук в руки в течении 24 часов.
      Однако мы не нарушаем законодательства Украины поэтому, (на основании
      ст.44, 64, 386 Гражданского кодекса Украины) пожалуйста подтвердите
      поручение на покупку причитающейся Вам суммы евро в уполномоченном
      банке:<br>
      <b>Договор поручение № $n  от $d г.</b><br>
      &nbsp;&nbsp;Я (<input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
      <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
      <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20>, документ
      <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20>) поручаю администрации
      OKWM.com.ua обменять причитающиеся мне при выводе из электронной системы
      платежей, денежные средства, на иностранную валюту (евро) в любом
      уполномоченном банке Украины.<br>
      &nbsp;&nbsp;Администрация OKWM.com.ua гарантирует выполнение данного
      поручения в течении 24 часов. Все расходы связанные с выполнением данного
      поручения уже включены  в выставленный ранее счет.<br>
      <u>Договор подтверждаю</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $EUR_   = "&nbsp;&nbsp;Указанная сумма передается из рук в руки в течении 24 часов.
      Однако мы не нарушаем законодательства Украины поэтому, (на основании
      ст.44, 64, 386 Гражданского кодекса Украины) пожалуйста подтвердите
      поручение на продажу переданной Вами суммы евро в уполномоченном
      банке:<br>
      <b>Договор поручение № $n  от $d г.</b><br>
      &nbsp;&nbsp;Я (<input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
      <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
      <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20>, документ
      <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20>) поручаю администрации
      OKWM.com.ua обменять переданные мною при вводе в электронную систему
      платежей, денежные средства, с иностранной валюты (евро) в любом
      уполномоченном банке Украины.<br>
      &nbsp;&nbsp;Администрация OKWM.com.ua гарантирует выполнение данного
      поручения в течении 24 часов. Все расходы связанные с выполнением данного
      поручения уже включены  в выставленный ранее счет.<br>
      <u>Договор подтверждаю</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $WarningX19 = "<p class=\"error\">Переданные данные проходят проверку на соответствие с данными в аттестате. В случае неверных данных обмен производится не будет.</p>";
 $WebmoneyToBetfairRules = "<u>Владелец кошелька Webmoney</u>:<br />
            <input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
            <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
            <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20><br>
            Документ: <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20><br>
            <u>Данные подтверждаю</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $WebmoneyToPokerstarsRules = "<u>Владелец кошелька Webmoney</u>:<br />
            <input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
            <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
            <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20><br>
            Документ: <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20><br>
            <u>Данные подтверждаю</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $WebmoneyToGlobalmoney = $WebmoneyToBetfairRules;

 $YandexToBetfairPokerstarsRules = "<u>Владелец счета Яндекс.Денег</u>:<br />
            <input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
            <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
            <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20><br>
            Документ: <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20><br>
            <u>Данные подтверждаю</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";

 $vip_flag = "vip";
 $WMid = "";

 function ConvertName ($money) {
         switch ($money) {
            case "NUAH":
               return "гривны";
            case "PSU":
               return "Pokerstars";
            case "BFU":
               return "Betfair USD";
            case "USD":
               return "USD";
            case "EUR":
               return "евро";
            case "UKSH":
               return "Ukash EURO";
            case "YAD":
               return "Yandex RUR";
            case "PCB":
               return "USD ПАТ КБ ПІВДЕНКОМБАНК";
            case "SBRF":
               return "Резерв";
               //return "Сбербанк России";
            case "BANK":
               return "USD Ячейка банка";
            case "P24US":
               return "Приват24 USD";
            case "P24UA":
               return "Приват24 грн";
            case "GMU":
               return "VISA Globalmoney, ГРН";
            default:
               return $money;
         }
 }

 function InDetails ($inmoney) {
      // реквизиты для оплаты
      switch ($inmoney) {
         case "WMZ":
         case "WME":
         case "WMR":
         case "WMU":
         // Введите WMid для отправки счета
         global $WMid, $outmoney;
         if ($outmoney == "GMU") $protec_msg = "<p>(при оплате заявки с кодом протекции свяжитесь с администратором для завершения обмена)</p>";
echo <<<EOT

<table width="100%" style="font-size:13px;font-weight:normal;color:#525252;margin-left:15px;">
   <tr>
   <td width="10%">Способ оплаты:&nbsp;&nbsp;</td>
   <td>
       <input type="radio" name="method" value="wmt" id="wmt" checked>
       <label for="wmt">через Merchant WebMoney</label><br />
       <input type="radio" name="method" value="invc" id="invc">
       <label for="invc">через выписку счета</label> $protec_msg
   </td>
   </tr>
   </table><br />
<p>
Введите WMID Вашего кошелька для <b>обязательной</b> проверки соответствия введенных данных с аттестатом:<br>
<input type=text name="WMid" value="$WMid" maxlength=12 size=15><br /><br />
</p>

EOT;
            break;
         case "MBU":
         // Введите Moneybookers Account (счет) с которого будете платить
         global $MBAcc;
echo <<<EOT
<p>Введите Ваш счет Moneybookers (e-mail), с которого Вы будете платить:<br>
<input type=text name="MBAcc" value="$MBAcc" maxlength=40 size=40>
</p>
EOT;
            break;
         case "USD":
         case "EUR":
         case "NUAH":
         // Выберите город, где Вы будете платить:
         global $phone, $USD_, $EUR_, $NUAH, $office_addr;
            if ($inmoney == "USD") echo "<br /><br />$USD_";
            if ($inmoney == "EUR") echo "<br /><br />$EUR_";
            if ($inmoney == "NUAH") echo "<br /><br />$NUAH";
            // Добавляет поля для ввода ФИО и документа при выборе города Киев (депозитарий) - 20.04.2010 убрал
            //require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/js/onclick.js");
echo <<<EOT

<div id="doc" style="width:380;height=0;"></div>
<br />
<p>В выбранном Вами городе наш офис находится по адресу:<br />
$office_addr<br />
Уточнить детали можно по телефонам, указанным на странице
<a href="/contacts.asp" title="Адрес приема платежей." target="_blank">&quot;Контакты&quot;</a>
</p>
<p>Hомер Вашего контактного телефона:
<input type=text name="phone" value="$phone" maxlength=15 size=20>
</p>

EOT;
            break;
         case "UKSH":
            global $vNumber, $vValue, $InSum;
echo <<<EOT
<p><a href="http://www.ukash.com" target="_blank"><img src="/img/ukash-logo.gif" border="0"></a><br />
<font color="red"><b>Внимание!</b> Для ваучеров Ukash минимальная сумма списания 10 &euro;.</font><br />
Номер ваучера: <input name="vNumber" type="text" value="$vNumber" size="20" maxlength="19"><br />
Номинал ваучера: <input name="vValue" type="text" value="$vValue"><br />
Сумма cписания:  $InSum &euro;</p>
<p>Если номинал Вашего ваучера больше суммы оплаты, в таком случае Вам будет выдан новый ваучер на оставшуюся сумму.<br />
Сохраните его у себя для дальнейшего использования Ukash.<br />
Копия нового ваучера будет выслана Вам на e-mail.<br />
При возникновении ошибки сообщите, пожалуйста, администратору.
</p>
EOT;
            break;
         case "YAD":
            global $yandexAcc, $outmoney;
            if (in_array($outmoney, array("WMZ","WME","WMR","WMU"))){
echo <<<EOT
<p>
Для обмена WebMoney - Яндекс.Деньги ваш счет в Янднекс.Деньгах должен быть идентифицирован и привязан к WMID на сайте banks.webmoney.ru <br />
Информация о привязке счетов обновляется раз в час. Если сразу после привязки счета вам все равно выдается сообщение
о несоответствии его вашему WMID — повторите попытку позднее.
Также необходимо привязать Ваш кошелек WebMoney к счету в Яндекс.Деньгах. Подробная информация находится тут
<a href="http://money.yandex.ru/exchange/wm/about.xml" target="_BLANK">http://money.yandex.ru/exchange/wm/about.xml</a>.<br />
</p>
EOT;
            }
echo <<<EOT
<p>
Номер счета Яндекс.Денег: <input name="yandexAcc" type="text" value="$yandexAcc" size="27" maxlength="27"><br />
</p>
EOT;
            break;
         case "P24US":
         case "P24UA":
            global $p24account, $lastname, $firstname, $midlename, $phone;
echo <<<EOT
<p>
При переводе на наш счет по системе Приват24 в назначении платежа Вы должны обязательно указать  &quot;Перевод личных средств&quot;.<br />
Перед оплатой убедитесь, что Вы согласовали наличие средств у администраторов.
</p>
<p>
Данные владельца банковского счета:<br />
<input type=text name="lastname" value="$lastname" maxlength=25 size=20>
<input type=text name="firstname" value="$firstname" maxlength=25 size=20>
<input type=text name="midlename" value="$midlename" maxlength=25 size=20><br /><br />
Hомер Вашего контактного телефона:<br />
<input type=text name="phone" value="$phone" maxlength=15 size=20><br /><br />
Номер карты без пробелов (16 символов):<br />
<input type=text name="p24account" value="" maxlength=25 size=20><br /><br />
</p>

EOT;
            break;
      }
 }

 function OutDetails ($outmoney) {
    global $USD, $EUR, $NUAH, $WebmoneyToBetfairRules, $WebmoneyToPokerstarsRules, $WebmoneyToGlobalmoney, $YandexToBetfairPokerstarsRules;

         // реквизиты для продаваемых денег
         switch ($outmoney) {
            case "WMZ":
            // Введите номер Вашего Z-кошелька для отправки Вам WebMoney:
            global $Z;
            $Z = (!empty($Z))? $Z: "Z";
echo <<<EOT
<p> Введите номер Вашего Z-кошелька для отправки Вам WebMoney:<br>
<input type=text name="Z" value="$Z" maxlength=13 size=15>
</p>
EOT;
            break;
            // Введите номер Вашего Z-кошелька для отправки Вам WebMoney:
         case "WME":
            global $E;
            $E = (!empty($E))? $E: "E";
echo <<<EOT
<p> Введите номер Вашего E-кошелька для отправки Вам WebMoney:<br>
<input type=text name="E" value="$E" maxlength=13 size=15>
</p>
EOT;
            break;
            // Введите номер Вашего R-кошелька для отправки Вам WebMoney:
         case "WMR":
            global $R;
            $R = (!empty($R))? $R: "R";
echo <<<EOT
<p> Введите номер Вашего R-кошелька для отправки Вам WebMoney:<br>
<input type=text name="R" value="$R" maxlength=13 size=15>
</p>
EOT;
            break;
            // Введите номер Вашего U-кошелька для отправки Вам WebMoney:
         case "WMU":
            global $U;
            $R = (!empty($R))? $U: "U";
echo <<<EOT
<p> Введите номер Вашего U-кошелька для отправки Вам WebMoney:<br>
<input type=text name="U" value="$U" maxlength=13 size=15>
</p>
EOT;
            break;
         case "USD":
         case "EUR":
         case "NUAH":
         case "BANK":
            global $office_addr;
            // Ввод ФИО и пасспорта
            if ($outmoney == "NUAH") echo $NUAH;
            if ($outmoney == "USD") echo $USD;
            if ($outmoney == "EUR") echo $EUR;
            if ($outmoney == "BANK") echo $USD;
            // Выберите город, где Вы хотите получить деньги
echo <<<EOT
<p>В Выбранном Вами городе наш офис работает по адресу:<br>
$office_addr<br />
Уточнить детали можно по телефонам, указанным на странице
<a href="/contacts.asp" title="Адрес приема платежей." target="_blank">&quot;Контакты&quot;</a>
</p>
<p>Hомер Вашего контактного телефона:
<input type=text name="phone" value="" maxlength=15 size=20>
</p>

EOT;
            break;
         case "MBU":
            global $MBU;
echo <<<EOT
<p>Введите счет Moneybookers (e-mail), куда отправлять перевод:<br>
<input type=text name="MBAcc" value="$MBAcc" maxlength=40 size=40>
</p>
EOT;
            break;
         case "UKSH":
echo <<<EOT
<p><a href="http://www.ukash.com" target="_blank"><img src="/img/ukash-logo.gif" border="0"></a></p>
<p>После оплаты заявки будет создан ваучер Ukash &euro;<br>
Копия ваучера будет выслана Вам на e-mail.<br />
При возникновении ошибки сообщите пожалуйста администратору.
</p>
EOT;
            break;
         case "BFU":
             global $BFacc, $inmoney;
             if (in_array($inmoney,array("WMZ","WME","WMR","WMU"))) {
                 echo $WebmoneyToBetfairRules;
             }
             if ($inmoney == "YAD") {
             	echo $YandexToBetfairPokerstarsRules;
             }
echo <<<EOT
<p>
Для пополнения Вашего счета <b>Betfair</b> введите свой ник:<br />
<input type=text name="BFacc" value="$BFacc" maxlength=40 size=40>
</p>
EOT;
            break;
         case "PSU":
             global $PSacc, $inmoney;
             if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))) {                 echo $WebmoneyToPokerstarsRules;
             }
echo <<<EOT
<p>
Для пополнения Вашего счета <b>PokerStars</b> введите свой ник:<br />
<input type=text name="PSacc" value="$PSacc" maxlength=40 size=40>
</p>
EOT;
            break;
         case "YAD":
            global $yandexAcc, $inmoney;
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))){
echo <<<EOT
<p>
Для обмена WebMoney - Яндекс.Деньги Ваш счет в ЯД должен быть идентифицирован и привязан к WMID на сайте banks.webmoney.ru<br />
Информация о привязке счетов обновляется раз в час. Если сразу после привязки счета Вам все равно выдается сообщение
о несоответствии его Вашему WMID — повторите попытку позднее.
Также необходимо привязать Ваш кошелек WebMoney к счету в Яндекс.Деньгах. Подробная информация находится тут
<a href="http://money.yandex.ru/exchange/wm/about.xml" target="_BLANK">http://money.yandex.ru/exchange/wm/about.xml</a>.<br />
</p>
EOT;
            }

echo <<<EOT
<p>
Номер счета Яндекс.Денег: <input name="yandexAcc" type="text" value="$yandexAcc" size="27" maxlength="27"><br />
</p>
EOT;
            break;
         case "PCB":
            global $pcb_acc, $lastname, $firstname, $midlename, $inn, $mfo, $egrpou, $cardAcc, $inmoney;
echo <<<EOT
<p>
Данные владельца банковского счета или карточки:<br />
<input type=text name="lastname" value="$lastname" maxlength=25 size=20>
<input type=text name="firstname" value="$firstname" maxlength=25 size=20>
<input type=text name="midlename" value="$midlename" maxlength=25 size=20><br /><br />
Серия и номер паспорта: <input type=text name="passport" value="$passport" maxlength=25 size=20> (например, СА 982344)<br />
ИНН: <input name="inn" type="text" value="$inn" size="10" maxlength="10"> (10 цифр)<br />
Код банка (МФО): <input name="mfo" type="text" value="$mfo" size="6" maxlength="6"> (6 цифр)<br />
Код ЕГРПОУ: <input name="egrpou" type="text" value="$egrpou" size="8" maxlength="8"> (8 цифр)<br />
Номер счета или номер карты: <input name="cardAcc" type="text" value="$cardAcc" size="27" maxlength="27"> (12-16 цифр)<br />
<input name="card_bank" type="radio" value="cardAcc" checked>Карточка<br />
<input name="card_bank" type="radio" value="bankAcc">Счет<br />
EOT;
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))) {
echo <<<EOT

<b>Внимание!</b> Ваша карточка или счет обязательно должен быть прикреплен к Вашему WMID на сайте
<a href="https://cards.webmoney.ru/asp/default.asp" target="_blank">https://cards.webmoney.ru/asp/default.asp</a>
EOT;
            }            echo <<<EOT
<br />При выводе средств на ПАТ КБ &laquo;ПІВДЕНКОМБАНК&raquo;:<br />
- по заявкам, оплаченным до 16-00, зачисление на счет/карту происходит в этот же день в течение 2 часов (не включая выходные и праздничные дни);<br />
- заявки, оплаченные после 16-00, обрабатываются на следующий день до 12-00.<br />
Подробное описание правил работы сервиса OKWM с банками находится <a href="$domain/banks.asp" target="_blank">здесь</a>.

EOT;
            echo "</p>";
            break;
         case "SBRF":
echo <<<EOT
<p>
В разработке
</p>
EOT;
            break;
         case "BANK":
echo <<<EOT
<p>
Вывод WMZ на банковскую ячейку осуществляется <b>только</b> для клиентов из г.Киева.<br />
Для проведения обмена и уточнения деталей свяжитесь с нашими администраторами:<br />
+380 (97) 479-00-08<br>
+380 (95) 649-00-08<br>
+380 (73) 439-00-08<br><br>
<a href="http://web.icq.com/whitepages/add_me?uin=637139590&action=add" title="Добавить в список контактов"> <b>ICQ 637139590</b> <img src="img/icq.gif" border=0></a><br><br>
WMId $WMid<br>
</p>
EOT;
            break;
         case "P24US":
         case "P24UA":
            global  $inmoney, $p24account, $lastname, $firstname, $midlename, $phone;
echo <<<EOT
<p>
Перевод на Ваш счет по системе Приват24 осуществляется мгновенно, в автоматическом режиме, после проведения оплаты заявки.
</p>
<p>
Данные владельца банковского счета:<br />
<input type=text name="lastname" value="$lastname" maxlength=25 size=20>
<input type=text name="firstname" value="$firstname" maxlength=25 size=20>
<input type=text name="midlename" value="$midlename" maxlength=25 size=20><br /><br />
Hомер Вашего контактного телефона:<br />
<input type=text name="phone" value="$phone" maxlength=15 size=20><br /><br />
Номер карты без пробелов (16 символов):<br />
<input type=text name="p24account" value="" maxlength=25 size=20><br /><br />
</p>

EOT;
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))) {
echo <<<EOT

<b>Внимание!</b> Вывод осуществляется только на карты, <a href="https://cards.webmoney.ru/asp/default.asp" target="_blank">прикрепленные</a>
к WMID владельца, c которого производится оплата.

EOT;
            }
            break;
         case "GMU":
            global $GMaccount, $lastname, $firstname, $midlename, $phone, $passport;
            echo $WebmoneyToGlobalmoney;

echo <<<EOT
<p>
Hомер Вашего контактного телефона:<br />
<input type=text name="phone" value="$phone" maxlength=15 size=20><br /><br />
Номер карты VISA Globalmoney без пробелов (16 символов):<br />
<input type=text name="GMaccount" value="" maxlength=25 size=20><br /><br />
</p>

EOT;
            break;
      }
 }

 // Verify purchase length and letters
 function VerifyP ($type, $P) {
   if ($type == "z") {      global $WMid;
      if (!preg_match("/^Z[0-9]{12}\$/",$P)) {
         $err = "Ошибка: Номер кошелька должен начинаться с буквы Z<br>";
         $err.= "и содержать 12 цифр! Например: Z619795576359";
      } else {         list($status, $wm_error) = CheckWMIDPurse($WMid, $P);
         if ($status!==1) $err = $wm_error;
      }
   }
   if ($type == "e") {
      global $WMid;
      if (!preg_match("/^E[0-9]{12}\$/",$P)) {
         $err = "Ошибка: Номер кошелька должен начинаться с буквы E<br>";
         $err.= "и содержать 12 цифр! Например: E493920922153";
      } else {
         list($status, $wm_error) = CheckWMIDPurse($WMid, $P);
         if ($status!==1) $err = $wm_error;
      }
   }
   if ($type == "r") {
      global $WMid;
      if (!preg_match("/^R[0-9]{12}\$/",$P)) {
         $err = "Ошибка: Номер кошелька должен начинаться с буквы R<br>";
         $err.= "и содержать 12 цифр! Например: R118454266669";
      } else {
         list($status, $wm_error) = CheckWMIDPurse($WMid, $P);
         if ($status!==1) $err = $wm_error;
      }
   }
   if ($type == "u") {
      global $WMid;
      if (!preg_match("/^U[0-9]{12}\$/",$P)) {
         $err = "Ошибка: Номер кошелька должен начинаться с буквы U<br>";
         $err.= "и содержать 12 цифр! Например: U182522806177";
      } else {
         list($status, $wm_error) = CheckWMIDPurse($WMid, $P);
         if ($status!==1) $err = $wm_error;
      }
   }
   if ($type == "WMid") {
      if (strlen($P)!=12) {
         $err = "Ошибка: номер кипера должен содержать 12 цифр! Например: 523133987155";
      } else {
         list($status, $wm_error) = CheckWMIDPurse($P);
         if ($status!==1) $err = $wm_error;
      }
   }
   if ($type == "AuthWMid") {       $sql = "SELECT COUNT(wmid) FROM authwmid WHERE wmid='".mysql_escape_string(trim($P))."'";
       OpenSQL($sql, $rows, $res);
       GetFieldValue ($res, $row, "COUNT(wmid)", $isAuthWMid, $IsNull);
       if ($isAuthWMid==0) {           $err = "Ваших данных нет в нашей базе клиентов.<br />";
           $err.= "Вам необходимо подъехать в наш офис с документом для уточнения Ваших данных.<br />";
           $err.= "Для уточнения деталей свяжитесь с администратором.<br />";
       }
   }
   if ($type == "pu") {
      if (substr($P,0,5)!="41004") {
         $err = "Номер счета Интернет.Денег должен начинаться с 41004!";
      }
   }
   if ($type == "fio") {
      if (ereg("Фамилия", $P)) {
         $err = "Фамилия введена неверно! <b>С такими данными платеж будет возвращен.</b><br />";
      }
      if (ereg("Имя", $P)) {
         $err.= "Имя введено неверно! <b>С такими данными платеж будет возвращен.</b><br />";
      }
      if (ereg("Отчество", $P)) {
         $err.= "Отчество введено неверно! <b>С такими данными платеж будет возвращен.</b><br />";
      }
      if ($P=="  ") {
         $err.= "Вы не ввели фамилию, имя и отчество! <b>Заявка не принята.</b>";
      }
      //$r = preg_match_all('/([0-9a-zA-Zа-яА-ЯіІєЄїЇ -]+)/', $P, $ok);
      //echo $r;
      if (preg_match_all('/([0-9a-zA-Zа-яА-ЯёЁіІєЄїЇ -]+)/', $P, $ok)<>1) {         $err.= "Вы ввели недопустимые символы в фамилии, имени или отчестве! <b>Заявка не принята.</b>";
      }
   }
   if ($type == "passport") {
      if ($P=="") {
         $err.= "Введите серию и номер документа.";
      }
   }
   if ($type == "city") {
      if ($P=="") {
         $err.= "Выберите <b>город</b>, в котором Вы хотите совершить обмен.";
      }
   }
   //if (($type == "mbu")&&(!preg_match('/^(.+@.+\..+|)$/', $P))) {
   //   $err.= "Счет Moneybookers (e-mail) введен не верно.";
   //}
   if (($type == "uksh_num")&&(!preg_match('/^[0-9]{19}$/', $P))) {       $err.= "Ошибка: Номер ваучера Ukash состоит из девятнадцати цифр.";
   }
   if (($type == "uksh_val")&&(!preg_match('/^\d+[\.|\,]?\d*$/', $P))) {       $err.= "Ошибка: Номинал ваучера Ukash не является числом.";
   }
   if ($type == "mbu") {
      $err.= "К сожалению обмен Moneybookers временно приостановлен.<br />Для уточнения обращайтесь к администраторам.";
   }
   //if (($type == "yandex")&&(!preg_match('/^[0-9]{10,16}$/', $P))) {
   //    $err.= "Ошибка: Номер счета Яндекс.Денег на данный момент варьируется от 11 до 16 цифр.";
   //}
   // 03.03.2015
   if ($type == "yandex") {
       $err.= "В данный момент прием Яндекс.Денег временно отключен.";
   }
   if (($type == "mfo")&&(!preg_match('/^[0-9]{6}$/', $P))) {
       $err.= "Ошибка: МФО состоит из 6 цифр.";
   }
   if (($type == "inn")&&(!preg_match('/^[0-9]{10}$/', $P))) {
       $err.= "Ошибка: ИНН состоит из 10 цифр.";
   }
   if (($type == "egrpou")&&(!preg_match('/^[0-9]{8}$/', $P))) {
       $err.= "Ошибка: ЕГРПОУ состоит из 8 цифр.";
   }
   if (($type == "bankAcc")&&(!preg_match('/^[0-9]{16}$/', $P))) {
       $err.= "Ошибка: Номер счета(карточки) состоит только из цифр.";
   }
   if (isset($err)) {       if (strlen($P)>0) {           $err.= "<br>Вы ввели ".htmlspecialchars($P).".<br>";
       } else {           $err.= "<br>Вы ничего не ввели.<br>";
       }
      return $err;
   }
 }

if (isset($HTTP_POST_VARS{'order'})) {  // Нажатие на кнопку Далее (первый вход на страницу)
   // convert all POST vars to locals
   foreach ($HTTP_POST_VARS as $fk => $fv) {
       $fv = addcslashes($fv, '"');
       eval("\$$fk = \"$fv\";");
   }
   // Приведение полученых POST-переменных из новой формы (26-12-2010)
   // к пержним переменным
   if (isset($inmoney)&&(preg_match('/^[0-9]{1,2}$/', $inmoney))) {       $id_inmoney = $inmoney;
       $inmoney = $In_Val_code[$id_inmoney];
       $InSum = $HTTP_POST_VARS["InSum".$id_inmoney];
   } else {       $inmoney = "";
       $InSum = "";
   }
   if (isset($outmoney)&&(preg_match('/^[0-9]{1,2}$/', $outmoney))) {
       $id_outmoney = $outmoney;
       $outmoney = $Out_Val_code[$id_outmoney];
       $OutSum = $HTTP_POST_VARS["OutSum".$id_outmoney];
   } else {
       $outmoney = "";
       $OutSum = "";
   }

   if (isset($town)&&($towm<1000)&&(preg_match('/^[0-'.(count($Town_name)-1).']{1}$/', $town))) {       $id_town = $town;
       $town = $Town_name[$id_town];
       // На главной странице был определен город
       switch ($town) {
           case "Киев":
              $office_addr = ADDR_Kiev;
              break;
           case "Днепропетровск":
              $office_addr = ADDR_Dnepr;
              break;
           case "Одесса":
              $office_addr = ADDR_Odessa;
              break;
       }
   }

   // Change ',' to '.' in InSum and OutSum
   $InSum  = str_replace(',','.',$InSum);
   $OutSum = str_replace(',','.',$OutSum);
   // $action = buy     (Купить) - в старой версии было купить-продать. В новой только продать.
   $action = "sell";
   $o = ConvertName($outmoney);
   $i = ConvertName($inmoney);
   $title_page = "Обмен ".$i." на ".$o." ";
   // Verify format sum
   if (!VerifyFormatSum($InSum)) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("Ошибка");
      HTMLError("Заявка не принята! Сумма оплаты введена неверно.");
      echo <<<EOT

<p>
Вы хотели сделать обмен $InSum $i на $OutSum $o.
Однако, сумма для обмена должна быть числом с двумя знаками после точки!<br>
</p>
<p>
Попробуйте еще раз ввести корректно сумму или свяжитесь с <a href="/contacts.asp">
администрацией<a> сайта.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }
   if (!VerifyFormatSum($OutSum)) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("Ошибка");
      HTMLError("Заявка не принята! Сумма выплаты введена неверно.");
      echo <<<EOT

<p>
Вы хотели сделать обмен $InSum $i на $OutSum $o.
Однако, сумма должна быть числом с двумя знаками после точки!<br>
</p>
<p>
Попробуйте еще раз ввести корректно сумму или свяжитесь с <a href="/contacts.asp">
администрацией<a> сайта.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }

   // Добавлено ограничение на минимальную входящую сумму Ukash
   if (($inmoney=="UKSH")&&($InSum<10)) {
       $InSum = 10;
       VerifySum ($InSum, $inmoney, $OutSum, $outmoney, $NewInSum, $NewOutSum, $action);
       $OutSum = $NewOutSum;
   }

   // Добавлено ограничение на минимальную входящую сумму Pokerstars
   if (($outmoney=="PSU")&&($OutSum<10)) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("Ошибка");
      HTMLError("Заявка не принята! Сумма пополнения Pokerstars должна быть больше $10.");
      echo <<<EOT

<p>
Вы хотели пополнить счет Pokerstars на $OutSum $o.
Однако, сумма должна быть больше $10!<br>
</p>
<p>
Попробуйте ввести большую сумму.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }

   // Verify sum of operation
   if (VerifySum ($InSum, $inmoney, $OutSum, $outmoney, $NewInSum, $NewOutSum, $action)) {
      $CorrectSum = "Сумма к оплате: $InSum $i<br>\n Сумма к выдаче: $OutSum $o \n";
   } else {
      $CorrectSum = "Суммы были подкорректированы!<br>\n
                   К оплате: $InSum $i<br>\n
                   К выдаче: $OutSum $o<br>\n
                   После пересчета, сумма <br>\n
                   к оплате: $NewInSum $i<br>\n
                   к выдаче: $NewOutSum $o<br>\n";
      $InSum = $NewInSum;
      $OutSum = $NewOutSum;
   }
   //*********************************************************************************************************************************
   //********************************************* TEST Приват24 *********************************************************************
   //*********************************************************************************************************************************
   /*if ((($inmoney=="P24US")||($outmoney=="P24US")||($inmoney=="P24UA")||($outmoney=="P24UA"))&&getenv('REMOTE_ADDR')!="178.95.197.15"&&getenv('REMOTE_ADDR')!="93.127.52.55") {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("Тест Приват24");
      HTMLError("Тестовый режим.");
      echo <<<EOT

<p>
Операции с Приват24 в данный момент запрещены.
</p>
<p>
Начало работы планируется на 29 сентября 2011 г.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();

   }*/

   //*********************************************************************************************************************************
   //*********************************************************************************************************************************
   //*********************************************************************************************************************************

   if (($inmoney==$outmoney)||($NewOutSum==0)||($NewInSum==0)||
      ((in_array($inmoney,array("USD","EUR","NUAH")))&&(in_array($outmoney,array("USD","EUR","NUAH")))))
   {
          // Запрещенный обмен. Страница ошибки
          HTMLHead($title_page, "", "");
          HTMLAfteHead_noBanner("Ошибка");
          HTMLError("Выбранный Вами обмен невозможен!");
          echo <<<EOT

<p>
Вы хотели сделать обмен $i на $o.<br>
При этом либо были введены недопустимые суммы, либо выбрано неправильное направление.
</p>
<p>
Попробуйте еще раз ввести корректно сумму и выбрать направление обмена или свяжитесь с <a href="/contacts.asp">
администрацией<a> сайта.
</p>

EOT;
          HTMLAfteBody();
          HTMLTail();
          exit();
   }
   // eval("\$explain = \"\$$outmoney\";");
} elseif (isset($HTTP_POST_VARS{'signup'})) {  // Нажатие на кнопку "Отправить заявку"
   // convert all POST vars to locals
   foreach ($HTTP_POST_VARS as $fk => $fv) {
       $fv = addcslashes($fv, '"');
       eval("\$$fk = \"$fv\";");
   }

   $o = ConvertName($outmoney);
   $i = ConvertName($inmoney);
   $title_page = "OKWM.com.ua - купить, продать, обменять WMZ WME WMR Ukash (".$i."->".$o.")";
   $Operation = "sell";
   // Verify format sum
   if (!VerifyFormatSum($InSum)) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("Ошибка");
      HTMLError("Заявка не принята! Сумма оплаты введена неверно.");
      echo <<<EOT

<p>
Вы хотели сделать обмен $InSum $i на $OutSum $o.
Однако, сумма для обмена должна быть числом с двумя знаками после точки!<br>
</p>
<p>
Попробуйте еще раз ввести корректно сумму или свяжитесь с <a href="/contacts.asp">
администрацией<a> сайта.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }
   if (!VerifyFormatSum($OutSum)) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("Ошибка");
      HTMLError("Заявка не принята! Сумма выплаты введена неверно.");
      echo <<<EOT

<p>
Вы хотели сделать обмен $InSum $i на $OutSum $o.
Однако, сумма должна быть числом с двумя знаками после точки!<br>
</p>
<p>
Попробуйте еще раз ввести корректно сумму или свяжитесь с <a href="/contacts.asp">
администрацией<a> сайта.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }
   // Verify minimal InSum
   if (($inmoney=="WMZ")||($inmoney=="USD")||($inmoney=="P24US")) {
      $v_iCourse = BaseCurr("USD");
   } elseif (($inmoney=="WME")||($inmoney=="EUR")||($inmoney=="UKSH")) {
      $v_iCourse = BaseCurr("EUR");
   } elseif (($inmoney=="WMR")||($inmoney=="YAD")) {
      $v_iCourse = BaseCurr("RUR");
   } else {
      $v_iCourse = 1;
   }
   $InSumUSD = (BaseCurr("USD")!=0)? $InSum*$v_iCourse / BaseCurr("USD") : 0;
   if ($InSumUSD < $Down) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("Ошибка");
      HTMLError("Заявка не принята! Сумма оплаты меньше $Down USD.");
      echo <<<EOT

<p>
Вы хотели сделать обмен $InSum $i на $OutSum $o.
Однако, минимальная сумма для обмена должна быть эквивалентна $Down USD!<br>
</p>
<p>
Попробуйте еще раз с большей суммой или свяжитесь с <a href="/contacts.asp">
администрацией<a> сайта для проведения обмена меньшей суммы.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }
   if ($InSumUSD > $Up) {
      HTMLHead($title_page, $class, "", "");
      HTMLAfteHead_noBanner("Ошибка");
      HTMLError("Заявка не принята! Сумма оплаты больше $Up USD.");
      echo <<<EOT

<p>
Вы хотели сделать обмен $InSum $i на $OutSum $o.
Однако, сумма для обмена должна быть менее эквивалента $Up USD!<br>
</p>
<p>
Попробуйте еще раз с меньшей суммой или свяжитесь с <a href="/contacts.asp">
администрацией<a> сайта для проведения обмена большей суммы.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }

   // Добавлено ограничение на минимальную входящую сумму Ukash
   if (($inmoney=="UKSH")&&($InSum<10)) {
       $InSum = 10;
       VerifySum ($InSum, $inmoney, $OutSum, $outmoney, $NewInSum, $NewOutSum, $Operation);
       $OutSum = $NewOutSum;
   }

   // Verify sum of operation
//   if (VerifySum ($InSum, $inmoney, $OutSum, $outmoney, $NewSum, $Operation)||($s == $vip_flag)) { - с акцией
   if (VerifySum ($InSum, $inmoney, $OutSum, $outmoney, $NewInSum, $NewOutSum, $Operation)) {
      $CorrectSum = "Сумма к оплате: $InSum $i<br>\n Сумма к выдаче: $OutSum $o";
   } else {
      $CorrectSum = "Суммы были подкорректированы!<br>\n
                   К оплате: $InSum $i<br>\n
                   К выдаче: $OutSum $o<br>\n
                   После пересчета, сумма <br>\n
                   к оплате: $NewInSum $i<br>\n
                   к выдаче: $NewOutSum $o<br>\n";
      $InSum = $NewInSum;
      $OutSum = $NewOutSum;
   }
   if (($inmoney==$outmoney)||($NewOutSum==0)||($NewInSum==0)||
      ((in_array($inmoney,array("USD","EUR","NUAH","P24US","P24UA")))&&(in_array($outmoney,array("USD","EUR","NUAH","PCB","BANK","P24US","P24UA","GMU")))))
   {
          // Запрещенный обмен. Страница ошибки
          HTMLHead($title_page, "", "");
          HTMLError("Выбранный Вами обмен невозможен!");
          echo <<<EOT

<p>
Вы хотели сделать обмен $i на $o.<br>
При этом либо были введены недопустимые суммы, либо выбрано неправильное направление.
</p>
<p>
Попробуйте еще раз ввести корректно сумму и выбрать направление обмена или свяжитесь с <a href="/contacts.asp">
администрацией<a> сайта.
</p>

EOT;
          HTMLAfteBody();
          HTMLTail();
          exit();
   }

   // Формирование правил обмена
   $terms = "Откуда будут платить:\r\n";
   switch ($inmoney) {
      case "WMZ":
      case "WME":
      case "WMR":
      case "WMU":
            $errWMid= VerifyP ("WMid", $WMid);
            // Merchant или Invoice
            if ($method=="invc") {
               $terms .= $WMid;
            } elseif ($method=="wmt") {               $terms .= "Merchant \r\n";
            } else {               $errWMid = "Не выбран способ оплаты!";
            }
         break;
      case "MBU":
            $errI = VerifyP("mbu", "$MBAcc");
            $terms .= "MoneyBookers: $MBAcc\r\n";
            // Проверка плательщика MoneyBookers
			//list($res, $data) = MB_CheckMail($MBAcc);
			//if ($res) {
			//    $terms.= "MoneyBookers reg data:";
			//    foreach ($data as $v) $terms.= $v."\r\n";
			//} else {
			//    $errI = "Ошибка: Счет MoneyBookers $MBAcc не зарегистрирован.\r\n";
	        //}
         break;
      case "USD":
      case "EUR":
      case "NUAH":
            $errI = VerifyP("city", $city);
            $errI.= VerifyP("fio", "$lastname $firstname $midlename");
            $errI.= VerifyP("passport", "$passport");
            $terms .= "фио: $lastname $firstname $midlename\r\n";
            $terms .= "док: $passport\r\n";
            $terms .= "город: $city \r\n";
            $terms .= "тел: $phone\r\n";
         break;
      case "UKSH":
            // Ukash Redemtion Term:
            // Minimum Voucher Value: 5 GBP, 5 USD, 5 Euro
            // Maximum Voucher Value: 500 GBP, 750 USD, 750 Euro
            // All customers who redeem vouchers above the Maximum Voucher Value should visit one pf our offices to show their passport...
            $errI = VerifyP("uksh_num", $vNumber);
            $errI.= VerifyP("uksh_val", $vValue);
            if ($InSum > 750) {                $errI.= "Обмен суммы <b>свыше 750 &euro;</b> возможен только через администратора в ручном режиме.<br />";
                $errI.= "Для проведения обмена необходимо предоставить документ, удостоверяющий личность.<br />";
            }
            $terms .= "Ukash voucher: $vNumber\r\n";
            $terms .= "Value: $vValue\r\n";
            $Purse_From = "$vNumber:$vValue";
         break;
      case "YAD":
            $errI = VerifyP("yandex", $yandexAcc);
            $terms.= "Yandex RUR: $yandexAcc\r\n";
            $Purse_From = $yandexAcc;
         break;
      case "P24US":
      case "P24UA":
            $errI = VerifyP("fio", "$lastname $firstname $midlename");
            $errI.= VerifyP("bankAcc", "$p24account");
            if ($inmoney=="P24US") {                $terms.= "Приват24 USD: $p24account\r\n";
            } else {                $terms.= "Приват24 грн: $p24account\r\n";
            }
            $terms .= "фио: $lastname $firstname $midlename\r\n";
            $terms .= "тел: $phone\r\n";
            $Purse_From = $p24account;
         break;
   }
   $terms .= "\r\nКуда отправлять деньги:\r\n";
   if (empty($WMid)) $WMid="";
   else $WMid_In = $WMid;
   switch ($outmoney) {
      case "WMZ":
            $terms .= $Z;
            $errP = VerifyP ("z", $Z);
            $Purse_To = $Z;
         break;
      case "WME":
            $terms .= $E;
            $errP = VerifyP ("e", $E);
            $Purse_To = $E;
         break;
      case "WMR":
            $terms .= $R;
            $errP = VerifyP ("r", $R);
            $Purse_To = $R;
         break;
      case "WMU":
            $terms .= $U;
            $errP = VerifyP ("u", $U);
            $Purse_To = $U;
         break;
      case "MBU":
            $errP = VerifyP("mbu", $MBAcc);
            $terms .= "MoneyBookers: $MBAcc\r\n";
            // Проверка плательщика MoneyBookers
			/*list($res, $data) = MB_CheckMail($MBAcc);
			if ($res) {
			    $terms.= "MoneyBookers reg data:";
			    foreach ($data as $v) $terms.= $v."\r\n";
			} else {
			    $errP = "Ошибка: Счет MoneyBookers $MBAcc не зарегистрирован.\r\n";
	        }*/
            $Purse_To = $MBAcc;
         break;
      case "USD":
      case "EUR":
      case "NUAH":
            $errP = VerifyP("fio", "$lastname $firstname $midlename");
            $terms .= "фио: $lastname $firstname $midlename\r\n";
            $terms .= "док: $passport\r\n";
            $terms .= "город: $city\r\n";
            $terms .= "тел: $phone\r\n";
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {                // При выводе Webmoney по правилам от 15.04.2010г. проверка пасспорта клиента по X19                $resCheckUser = XMLCheckUser(1, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"","","","","","1");
                if ($resCheckUser['retval'] != 0) $errP = $resCheckUser['retdesc'];
            }
            $Purse_To = "";
         break;
      case "UKSH":
            $terms .= "Ukash EUR";
            $Purse_To = "Ukash";
            if ($OutSum > 1000) {                $errP = "Сумма обмена более &euro;1000 проводится по согласованию с администрацией.";
                break;
            }
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {
                // 22.11.2010 - отмена онлайн операций WM<->Ukash
                $errP = "Уважаемые клиенты! Проведение операций по обмену Ukash - Webmoney запрещено системой Webmoney.<br />".
                        "Для приобретения ваучеров Ukash за наличные свяжитесь с администратором.<br />".
                        "Телефоны и ICQ администраторов (для всех представительств):<br>".
                        "+380 (97) 479-00-08<br>".
                        "+380 (95) 649-00-08<br><br>".
                        //"+380 (73) 439-00-08<br><br>".
                        "<b>ICQ 637139590</b> <img src=\"img/icq.gif\" border=0><br><br>";
                break;
            }
            /*if (($inmoney=="WMU")&&$WMid!="") {
                // При обмене Webmoney на Ukash по правилам от 15.04.2010г. проверка аттестата
                $resCheckWMPassport = XMLGetWMPassport($WMid);
                if ($resCheckWMPassport['retval'] != 0) {                    if (isset($resCheckWMPassport['retdesc'])) {                        $errP = $resCheckWMPassport['retdesc'];
                    } else {                        $errP = "Запрос аттестата WMid $WMid не выполнен.";
                    }
                } else {                    if ($resCheckWMPassport['recalled'] == 1) {                        $errP = "Ваш аттестат отозван и его статус эквивалентен аттестату псевдонима.";
                    } else {                        $yesterday = date ("Y-m-d H:i:s", time()-86400);
                        $sqlUkashSum = "SELECT SUM(GOOD_AMOUNT) AS sumUkash FROM contract
                                         INNER JOIN goods ON (contract.GOOD_ID = goods.GOODS_ID)
                                         WHERE wmid = '$WMid' AND contract.Delivery_Status = 1 AND goods.GOODS_NAME = 'UKSH' AND
                                         contract.Purchase_Order_Time BETWEEN '$yesterday' AND NOW()";
                        OpenSQL ($sqlUkashSum, $rows, $res);
                        $row = NULL;
                        GetFieldValue ($res, $row, "sumUkash", $sumUkash, $IsNull);
                        if (($resCheckWMPassport['att']==110) AND (($sumUkash+$OutSum)> 200)) {                            // Формальный
                            $errP = "Сумма ваучера Ukash для Вашего аттестата не может превышать 200 EUR в сутки.";
                            break;
                        }
                        if (($resCheckWMPassport['att']>=120) AND (($sumUkash+$OutSum)> 500)) {                            // Начальный, персональный, продавца ...
                            $errP = "Сумма ваучера Ukash для Вашего аттестата не может превышать 500 EUR в сутки.";
                            break;
                        }
                        // Проверка нашей базы клиента
                        $errP = VerifyP("AuthWMid", $WMid);
                    }
                }
            }*/
         break;
      case "BFU":
            $errP = VerifyP("fio", "$lastname $firstname $midlename");
            $terms .= "фио: $lastname $firstname $midlename\r\n";
            $terms .= "док: $passport\r\n";
            $terms .= "Betfair $BFacc";
            $Purse_To = $BFacc;
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {
                // При выводе Webmoney по правилам от 15.04.2010г. проверка пасспорта клиента по X19
                $resCheckUser = XMLCheckUser(1, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"","","","","","1");
                if ($resCheckUser['retval'] != 0) $errP = $resCheckUser['retdesc'];
            }
         break;
      case "PSU":
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {
                $errP = VerifyP("fio", "$lastname $firstname $midlename");
                $terms .= "фио: $lastname $firstname $midlename\r\n";
                $terms .= "док: $passport\r\n";
                // При выводе Webmoney по правилам от 15.04.2010г. проверка пасспорта клиента по X19
                $resCheckUser = XMLCheckUser(1, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"","","","","","1");
                if ($resCheckUser['retval'] != 0) $errP = $resCheckUser['retdesc'];
            }
            $terms .= "Pokerstars $PSacc";
            $Purse_To = $PSacc;
         break;
      case "YAD":
            $errP = VerifyP("yandex", $yandexAcc);
            $terms .= "Yandex RUR: $yandexAcc\r\n";
            $Purse_To = $yandexAcc;
         break;
      case "PCB":
            // Проверка данных для перевода в банк (ФИО,серия номер паспорта,ИНН - 10 цифр,Код банка (МФО) - 6 цифр,
            // Код ЕГРПОУ - 8 цифр,Номер счета или номер карты)
            $errP = VerifyP("fio", "$lastname $firstname $midlename");
            $errP.= VerifyP("passport", "$passport");
            $errP.= VerifyP("mfo", "$mfo");
            $errP.= VerifyP("inn", "$inn");
            $errP.= VerifyP("egrpou", "$egrpou");
            $errP.= VerifyP("bankAcc", "$cardAcc");
            $terms.= "Южкомбанк: $lastname $firstname $midlename\r\n";
            $terms.= "док: $passport\r\n";
            $terms.= "ИНН: $inn\r\n";
            $terms.= "МФО: $mfo\r\n";
            $terms.= "ЕГРПОУ: $egrpou\r\n";
            $terms.= "номер счета(карты): $cardAcc\r\n";
            if ($card_bank=="cardAcc")
                $terms.= "тип: карта\r\n";
            else
                $terms.= "тип: счет\r\n";
            $Purse_To = $cardAcc;
         break;
      case "P24US":
      case "P24UA":
            $errP = VerifyP("fio", "$lastname $firstname $midlename");
            $errP.= VerifyP("bankAcc", "$p24account");
            if ($outmoney=="P24US") {
                $terms.= "Приват24 USD: $p24account\r\n";
            } else {
                $terms.= "Приват24 грн: $p24account\r\n";
            }
            $terms .= "фио: $lastname $firstname $midlename\r\n";
            $terms .= "тел: $phone\r\n";
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {
                // При выводе Webmoney на Приват24 по правилам от 15.04.2010г. проверка пасспорта клиента по X19
                $resCheckUser = XMLCheckUser(4, $inmoney, $InSum, $WMid, "",$lastname,$firstname,"Приватбанк","",$p24account,"","","1");
                if ($resCheckUser['retval'] != 0) $errP = $resCheckUser['retdesc'];
            }
            // Проверить доступную сумму на приват24 и возможность перевода на карту клиента
            $p24 = new matrix();
            $balance_p24 = $p24->getBalance();
            if ($balance_p24 < $OutSum) {
                $errP.= "Ваша сумма превышает доступную на данный момент. Попробуйте позже или свяжитесь с администратором.";
            }

            $check_result = $p24->checkCard($p24account);
            if (!$check_result[0]) {
                $errP.= $p24->getErrMessage();
            } else {                if ($OutSum > $check_result[3]) {                    $errP.= "Сумма обмена превышает максимально возможную сумму по Вашей карте (".$check_result[3]." грн.).";
                }
            }
            $Purse_To = $p24account;
         break;
      case "GMU":
            $errP = VerifyP("fio", "$lastname $firstname $midlename");
            $errP.= VerifyP("passport", "$passport");
            $errP.= VerifyP("bankAcc", "$GMaccount");
            $terms.= "Globalmoney грн: $GMaccount\r\n";
            $terms .= "фио: $lastname $firstname $midlename\r\n";
            $terms .= "тел: $phone\r\n";
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {
                // При выводе Webmoney по правилам от 15.04.2010г. проверка пасспорта клиента по X19
                $resCheckUser = XMLCheckUser(1, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"","","","","","1");
                if ($resCheckUser['retval'] != 0) $errP.= $resCheckUser['retdesc'];
            }

            $Purse_To = $GMaccount;
         break;
   }
   // X19 Ввод в систему
   if (in_array($inmoney, array("NUAH","USD","EUR"))&&in_array($outmoney, array("WMZ","WME","WMR","WMU"))) {        // При вводе Webmoney по правилам от 15.04.2010г. проверка пасспорта клиента по X19
        $resCheckUser = XMLCheckUser(1, $outmoney, $OutSum, $WMid, $passport,$lastname,$firstname,"","","","","","2");
        if ($resCheckUser['retval'] != 0)
            $errP = $resCheckUser['retdesc'];
        else
            $terms.= "\r\n$WMid\r\n";
   }
   if (in_array($inmoney, array("P24US","P24UA"))&&in_array($outmoney, array("WMZ","WME","WMR","WMU"))) {
        // При вводе Webmoney с Приватбанка по правилам от 15.04.2010г. проверка пасспорта клиента по X19
        $resCheckUser = XMLCheckUser(4, $outmoney, $OutSum, $WMid, "",$lastname,$firstname,"Приватбанк","",$p24account,"","","2");
        if ($resCheckUser['retval'] != 0)
            $errP = $resCheckUser['retdesc'];
        else
            $terms.= "\r\n$WMid\r\n";
   }
   // Автообмен WM-WM, обмен только одному владельцу WMid
   if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&in_array($outmoney, array("WMZ","WME","WMR","WMU"))&&($WMid_In!=$WMid)) {
        // При автообмене Webmoney по правилам от 15.04.2010г. проверка кошельков клиента (Должен быть один владелец)
        $errP = "WMID получателя не совпадает с WMID плательщика.";
   }
   // 03.03.2015 - Автообмен WM-WM должен идти на другие кошельки
   if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&in_array($outmoney, array("WMZ","WME","WMR","WMU"))) {
        $errP = "Автообмен временно отключен.";
   }
   // 22.11.2010 Ukash -> WM
   if ((($inmoney=="UKSH")&&in_array($outmoney,array("WMZ", "WME", "WMR", "WMU")))||
       (($outmoney=="UKSH")&&in_array($inmoney,array("WMZ", "WME", "WMR", "WMU"))))
   {
       // 22.11.2010 - онлайн операций WM<->Ukash через проверку клиента
       //HTMLError("<b>С 22.11.2010г. данные операции запрещены системой Webmoney.</b><br />Обмен производиться не будет!<br />");
   }
   /*if (($inmoney=="UKSH")&&in_array($outmoney,array("WMZ", "WME", "WMR", "WMU"))) {
       // 22.11.2010 - онлайн операций WM<->Ukash через проверку клиента
       $errP.= VerifyP("AuthWMid", $WMid);
   }*/
   if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&($outmoney=="PCU")) {
        // При выводе Webmoney на карту или счет по правилам от 15.04.2010г. проверка пасспорта клиента и карточки(счета) по X19

        if ($card_bank=="bankAcc") {
            $resCheckUser = XMLCheckUser(3, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"Южкомбанк",$cardAcc,"","","","1");
        } else {            $resCheckUser = XMLCheckUser(4, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"Южкомбанк","",$cardAcc,"","","1");
        }
        if ($resCheckUser['retval'] != 0)
            $errP = $resCheckUser['retdesc'];
        else
            $terms.= "\r\n$WMid\r\n";
   }
   if ((in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&($outmoney=="YAD")) ||
       (($inmoney=="YAD")&&in_array($outmoney, array("WMZ","WME","WMR","WMU")))){        if ($inmoney=="YAD") {            // Ввод WM в систему
            $direction = "2";
        } else {            // Вывод WM из системы            $direction = "1";
        }
        // При обмене Webmoney на Яндекс.Деньги по правилам от 15.04.2010г. проверка привязки счета Яндекс.Денег по X19
        //if (getenv('REMOTE_ADDR')!="82.207.125.214")
            $resCheckUser = XMLCheckUser(5, $inmoney, $InSum, $WMid, "","","","","","","money.yandex.ru ",$yandexAcc,$direction);
        //else
        //    $resCheckUser['retval']=0; // ДЛЯ ОТЛАДКИ ПРИНИМАЕМ ЗАЯВКУ

        if ($resCheckUser['retval'] != 0)
            $errP = "<br />Ошибка при проверке X19.<br />Проверьте привязку Вашего счета $yandexAcc к кошельку Webmoney (WMid $WMid) на странице <a href=\"https://banks.webmoney.ru\" target=\"_BLANK\">https://banks.webmoney.ru</a><br />".$resCheckUser['retdesc'];
        else
            $terms.= "\r\n$WMid\r\n";
   }

   if ((empty($errI))&&(empty($errP))&&(empty($errWMid))) {
      // Добавить заявку в базу
      // $WMid плательщика и $Purse_To кошелек получателя заполнены ранее
      $PaymentSum       = $InSum;
      $PaymentCurrency  = $inmoney;
      $PaymentAccount   = (isset($Purse_From))? $Purse_From : "";
      $PaymentID        = "AU-".$HTTP_SERVER_VARS{'UNIQUE_ID'};
      $ShortDescription = "Вход $InSum $inmoney, выход $OutSum $outmoney.";
      $ContractTerms    = $terms;
      $GoodsAmountReq   = $OutSum;
      $GoodsName        = $outmoney;
      $encode_mail      = base64_encode ($mail);
      $ip               = getenv("REMOTE_ADDR");

      $sqlID = "SELECT GOODS_ID, GOODS_AMOUNT FROM goods where GOODS_NAME='$GoodsName'";
      OpenSQL ($sqlID, $row, $res);
      $row = NULL;
      GetFieldValue ($res, $row, "GOODS_ID", $GoodsID, $IsNull);
      if ($row) {
         GetFieldValue ($res, $row, "GOODS_AMOUNT", $GoodsAmount, $IsNull);
         if ($GoodsAmountReq <= $GoodsAmount) {          if (empty($WMid)) $WMid = "";
            $sql = "INSERT INTO Contract
                       (PAYMENT_ID,
                        SHORT_DESCRIPTION,
                        CONTRACT_TERMS,
                        PURCHASE_ORDER_TIME,
                        PAYMENT_CURRENCY,
                        PAYMENT_SUM,
                        PAYMENT_ACCOUNT,
                        GOOD_ID,
                        GOOD_AMOUNT,
                        wmid,
                        MAIL,
                        IP,
                        Purse_To)
                    VALUES (
                        '$PaymentID',
                        '$ShortDescription',
                        '$ContractTerms',
                        NOW(),
                        '$PaymentCurrency',
                        '$PaymentSum',
                        '$PaymentAccount',
                        '$GoodsID',
                        '$GoodsAmountReq',
                        '$WMid',
                        '$encode_mail',
                        '$ip',
                        '$Purse_To'
                    )";
            ExecSQL ($sql, $row);
            if ($row) {
               // Номер заявки в пользовательском формате
               $ContractID = round(mysql_insert_id() * pi());
               // Оплата в представительстве или электронными деньгами ?
               if (($inmoney == "WME")||($inmoney == "WMZ")||($inmoney == "WMR")||($inmoney == "WMU")||($inmoney == "YAD")) {
                  // WME, WMZ, WMR, WMU, YAD - оплачиваются сразу
                  // Заявка принята! Произведите пожалуйста оплату.
                  $message = "Заявка принята и отправлена администратору! Произведите пожалуйста оплату заявки.";
                  if (($outmoney == "BFU")||($outmoney=="PSU")) {                      $message.= "<br />Для завершения обмена обратитесь к администраторам по ICQ: 637139590<br />".
                                 "или телефонам:<br />".
                                 "+380 (97) 479-00-08 Киевстар<br />".
                                 "+380 (95) 649-00-08 МТС<br />";
                                 //"+380 (73) 439-00-08 Life:)";
                  }
                  $Pay = true;  // разрешить оплату через merchant
                  // URL для письма на случай обрыва связи
                  $mail_msg = "При обрыве связи после оплаты, завершить обмен Вы можете по ссылке $domain/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::")."\r\n";
                  if (($outmoney == "BFU")||($outmoney=="PSU")) {
                     $mail_msg.= "Для завершения обмена обратитесь к администраторам по ICQ:\r\n";
                     $mail_msg.= "637139590\r\n";
                     $mail_msg.= "или телефонам:\r\n";
                     $mail_msg.= "+380 (97) 479-00-08\r\n";
                     $mail_msg.= "+380 (95) 649-00-08\r\n";
                     //$mail_msg.= "+380 (73) 439-00-08\r\n";
                  }
               } elseif ($inmoney =="MBU") {
                  $message = "Заявка принята! Обмен совершается в ручном режиме. Для совершения обмена Moneybookers USD свяжитесь с администратором.";
                  $Pay = false;
                  // Приглашение в представительство оплатить заявку
                  $mail_msg = "Для совершения обмена Moneybookers USD свяжитесь с администратором. Телефоны, ICQ и e-mail Вы найдете на странице http://www.okwm.com.ua/contacts.asp\r\n";
               } elseif ($inmoney =="UKSH") {
                  $message = "Заявка принята и отправлена на обработку!<br />Результы списания ваучера Ukash.";
                  $Pay = true;
                  // URL для письма на случай обрыва связи
                  $mail_msg = "При обрыве связи после оплаты, завершить обмен Вы можете по ссылке $domain/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::")."\r\n";
               } elseif (($inmoney =="P24US")||($inmoney =="P24UA")) {
                  // оплата с Приват24
                  $message = "Заявка принята и отправлена администратору! Номер заявки $ContractID.
                  На указаный Вами e-mail было выслано письмо с подтверждением.<br />
                  Для получения реквизитов оплаты и завершения заявки свяжитесь с администраторами сайта в рабочее время:<br />
                  Будние дни с 10-00 до 19-00, выходные с 12-00 до 14-00.<br />
                  ICQ 637139590<br />
                  +380 (97) 479-00-08<br />
                  +380 (95) 649-00-08<br />
                  +380 (73) 439-00-08<br />
                  <br>";
                  $Pay = false;
                  // Приглашение в представительство оплатить заявку
                  $mail_msg = "Для получения реквизитов оплаты и завершения заявки свяжитесь с администраторами сайта в рабочее время:\r\n";
                  $mail_msg.= "Будние дни с 10-00 до 19-00, выходные с 12-00 до 14-00.\r\n";
                  $mail_msg.= "637139590\r\n";
                  $mail_msg.= "+380 (97) 479-00-08\r\n";
                  $mail_msg.= "+380 (95) 649-00-08\r\n";
                  $mail_msg.= "+380 (73) 439-00-08\r\n";
               } else {
                  // наличные оплачиваются при личной встрече
                  $message = "Заявка принята! Номер заявки $ContractID. На указаный Вами e-mail было выслано письмо с подтверждением. Оплатите заявку в нашем представительстве.<br />
                  При оплате сообщите номер заявки представителю. Адреса представительств и время их работы Вы найдете на странице <a href=\"http://www.okwm.com.ua/contacts.asp\" target=\"_BLANK\">\"Контакты\"</a><br>";
                  $Pay = false;
                  // Приглашение в представительство оплатить заявку
                  $mail_msg = "Ждем Вас в представительстве. Адреса представительств и время их работы Вы найдете на странице http://www.okwm.com.ua/contacts.asp\r\n";
               }
               // send mail to admin
               $title = "Получена заявка $ContractID.";
               $msg = "$terms\r\n К оплате: $PaymentSum ".ConvertName($inmoney)."\r\n";
               $msg.= "К выдаче: $GoodsAmountReq ".ConvertName($outmoney)."\r\n";
       		   $msg.= "e-mail: $mail\r\n";
               $msg.= "Завершить обмен можно по ссылке $domain/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::")."\r\n";
               $from = $HTTP_SERVER_VARS['SERVER_ADMIN'];
               $res = SendMail ($from, $title, $msg);
               // send mail to client
               if ($mail!=""){
                  $to = $mail;
                  $client_title = "Обработка заявки okwm.com.ua";
                  $client_message = "Здравствуйте!\r\nВаша заявка принята. Номер заявки $ContractID\r\n\r\n";
                  $client_message.= "К оплате: $PaymentSum ".ConvertName($inmoney)."\r\n";
                  $client_message.= "К выдаче: $GoodsAmountReq ".ConvertName($outmoney)."\r\n";
                  if (isset($prot)) $client_message.= "Код протекции: $prot."."\r\n";
                  $client_message.= $mail_msg;
                  $client_message.= "Спасибо, что воспользовались нашими услугами.\r\n\r\n";
                  $client_message.= "С уважением,\r\nадминистратор www.okwm.com.ua\r\n";
                  SendMail ($from, $client_title, $client_message, $to);
               }
            } else {
               // Сообщите пожалуйста об ошибке администратору!
               $message = "Заявка не принята!<br> Сообщите пожалуйста об ошибке администратору!<br>";
            }
         } else {
            // Указаная сумма превышает допустимую.
            $message = "Заявка не принята!<br>Сумму, которую Вы хотите получить, нет в наличии.<br>Попробуйте ввести меньшую сумму.<br>";
         }
      } else {
         // Выбранная валюта временно не обменивается.
         $message = "Заявка не принята!<br> Выбранная валюта временно не обменивается.";
      }
   } else {
      $action = "sell";
   }
} else {
   // Неправильный вход на страницу
   // через 15 сек перенаправляем клиента на главную страницу
   HTMLHead ("Ошибка на странице оформления заявки", "", "");
   HTMLAfteHead_noBanner("Ошибка в оформлении заявки");
   HTMLError("Заявка не принята!");
   echo <<<EOT

<p>
Вы хотели сделать обмен, однако по какой-то причине возникла ошибка и Ваша заявка не принята!<br>
</p>
<p>

Попробуйте еще раз или сообщите <a href="/contacts.asp">администратору</a> сайта для
выяснения причин ошибки.<br>
Заранее благодарны!
</p>
<p>
Вернуться <a href="$domain/">на главную страницу>>></a>
</p>

EOT;

   HTMLAfteBody ();
   HTMLTail();
   exit;
}

// Определение резерва валюты к получению
$sql_reserv = "SELECT GOODS_ID, GOODS_AMOUNT FROM goods where GOODS_NAME='$outmoney'";
OpenSQL ($sql_reserv, $rows, $res);
if ($rows) {
    $row = NULL;
    GetFieldValue ($res, $row, "GOODS_AMOUNT", $MaxOutSum, $IsNull);
    $MaxOutSum = (in_array($outmoney,array("WMZ","WME","WMR","WMU")))? (floor(($MaxOutSum - $MaxOutSum*0.008)*100))/100 : $MaxOutSum;
    $ReservMsg = "Максимально возможная сумма к получению: $MaxOutSum ".ConvertName($outmoney);
}

// Create HTML code
HTMLHead ($title_page);
HTMLAfteHead_noBanner("Ввод данных для обмена");

if (!empty($action)) {
echo <<<EOT
<script language="JavaScript">
  var key_2_press=new Image();
  key_2_press.src='$domain/img/keys/key_2_press.gif';

  function Verify () {      if (document.insert.agreement) {
        if (document.insert.agreement.checked) {
           document.insert.submit ();
        } else {
		   if ((document.insert.inmoney.value == "USD")||
		       (document.insert.inmoney.value == "EUR")||
		       (document.insert.outmoney.value == "USD")||
		       (document.insert.outmoney.value == "EUR")) {
	           alert ("Вы не подтвердили договор и данные!");
	       } else {	           alert ("Вы не подтвердили данные!");
	       }
        }
      } else {          document.insert.submit ();
      }  }
</script>
$CorrectSum<br />
$ReservMsg<br /><br />
<form enctype="multipart/form-data" method="post" name="insert" action="$domain/specification.asp">

<input type="hidden" name="title_page" value="$title_page">
<input type="hidden" name="InSum" value="$InSum">
<input type="hidden" name="OutSum" value="$OutSum">
<input type="hidden" name="inmoney" value="$inmoney">
<input type="hidden" name="outmoney" value="$outmoney">
EOT;
   // Вывод города, если обмен связан с наличными
   if (isset($town)) {
       // На главной странице был определен город в переменной $town
       echo "\n<input type=\"hidden\" name=\"city\" value=\"$town\">\n";
   } else {
       // На второй странице переопределен город в переменной city
       if (isset($city)) echo "\n<input type=\"hidden\" name=\"city\" value=\"$city\">\n";
       // Определение адреса офиса по городу в переменной city
       switch ($city) {
           case "Киев":
              $office_addr = ADDR_Kiev;
              break;
           case "Днепропетровск":
              $office_addr = ADDR_Dnepr;
              break;
           case "Одесса":
              $office_addr = ADDR_Odessa;
              break;
       }
   }
   // ошибки, если есть
   if (isset($errWMid)) HTMLError ($errWMid);
   if (isset($errI)) HTMLError ($errI);
   if (isset($errP)) HTMLError ($errP);
   // 22.11.2010 Ukash <-> WM
   if ((($inmoney=="UKSH")&&in_array($outmoney,array("WMZ", "WME", "WMR", "WMU")))||
       (($outmoney=="UKSH")&&in_array($inmoney,array("WMZ", "WME", "WMR", "WMU"))))
   {
       // 22.11.2010 - онлайн операций WM<->Ukash через проверку клиента
       //HTMLError("<b>С 22.11.2010г. данные операции запрещены системой Webmoney.</b><br />Обмен производиться не будет!<br />");
   }

   // реквизиты для оплаты
   InDetails ($inmoney);
   // реквизиты для продаваемых денег
   OutDetails ($outmoney);
   // e-mail
   if (!isset($mail)) $mail="";
echo <<<EOT
<p>e-mail:
<input type=text name="mail" value="$mail" maxlength=40 size=40>
</p>
EOT;
   //if (!isset($vip_flag)) $vip_flag="";
   //<input type="hidden" name="s" value="$vip_flag">
   // Если ввод/вывод Webmoney, то вывод предупреждения о проверке данных по X19
   if ((in_array($inmoney,array("NUAH","USD","EUR","P24US","P24UA"))&&in_array($outmoney, array("WMZ","WME","WMR","WMU")))||
       (in_array($inmoney,array("WMZ","WME","WMR","WMU"))&&in_array($outmoney, array("NUAH","USD","EUR","PCB","P24US","P24UA")))) echo $WarningX19;

   // Отправить заявку
   echo <<<EOT
<input type="hidden" name="signup" value="Отправить заявку">
<img src="$domain/img/keys/key_2_symple.gif" width="136" height="19"
     onMouseOut  = "this.src = '$domain/img/keys/key_2_symple.gif';"
     onMouseOver = "this.src =  key_2_press.src;"
     onClick     = "Verify();">
<br>

</form>

EOT;
} else {
    if (!empty($message)) {
        echo "$message <br>\n";
        echo "$CorrectSum<br>\n";
        if ($Pay) {           if (($inmoney == "WME")||($inmoney == "WMZ")||($inmoney == "WMR")||($inmoney == "WMU"))
	        if ($method=="wmt") {		        // Подготовка описания счета по требованиям от 14.01.2006 г.
		        $descr_merchant = "$ContractID.".chr(13);
		        $descr_merchant.= "$InSum $inmoney => $OutSum $o. ";
		        if (($outmoney == "NUAH")||($outmoney == "USD")||($outmoney == "EUR")) {
		           // Обмен на наличные
		           if (isset($city)) $descr_merchant.= "$city ";
		           $descr_merchant.= "$lastname $firstname $midlename $passport.".chr(13);
		        } elseif (($outmoney == "BFU")||($outmoney == "PSU")||($outmoney == "PCB")) {
		           // Пополнение Betfair или Pokerstars или Южкомбанк
		           $descr_merchant.= "$lastname $firstname $midlename $passport.".chr(13);
		           $descr_merchant.= ConvertName($outmoney)." $Purse_To ";
		        } elseif (($outmoney == "P24US")||($outmoney == "P24UA")) {
		           // Вывод Webmoney на Приватбанк
		           $descr_merchant.= "$lastname $firstname $midlename.".chr(13);
		           $descr_merchant.= ConvertName($outmoney)." $Purse_To (Приватбанк)";
		        } elseif ($outmoney == "YAD") {
		           // Пополнение Yandex RUR
		           $descr_merchant.= "Яндекс.Деньги $Purse_To ";
		        } elseif ($outmoney == "GMU") {
		           // Вывод Webmoney на VISA Globalmoney UAH
		           $descr_merchant.= "Globalmoney $Purse_To ";
		        } else {
		           // Автоматический обмен
		           $descr_merchant.= "Счет(кошелек) получателя $Purse_To ";
	            }
	            FormWMT($PaymentID, $InSum, $inmoney, $title_page, $ContractID, $descr_merchant);
            } else {
                require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm_invc.asp");
            }
            if ($inmoney == "YAD")
                FormYMoney($PaymentID, $InSum, $title_page, $ContractID);
            if ($inmoney == "UKSH")
                require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/uk_paychk.asp");
        } else {
           // через 15 сек перенаправляем клиента на главную страницу
           //require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/js/gotomain.js");
           include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
        }
    }
}

HTMLAfteBody();
HTMLTail ();
?>