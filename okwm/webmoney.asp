<script language="PHP">
#--------------------------------------------------------------------
# OKWM WHITH WEBMONEY page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2010.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = DOMAIN_HTTP;

    // SEO strings
    $title = GetSEO("c3c5d62cecbb014709481767d39a64e7");
    if ($title=="") $title = "Пополнить, купить, обменять ( wmz, wmu, wmr, wme) в Украине | OKWM - обменник вмз, вму, вмр, вме без комиссии";
    $Description = GetSEO("017240a89bf5a7ccf697e220e268fdfc");
    if ($Description=="") $description = "Выгодно и быстро обменять WebMoney WMZ WMR WMU WME, Ukash, Pokerstars, Betfair, наличные в Киеве, Одессе, Днепропетровске";
    $Keywords = GetSEO("a5519620408ddfea7d6b2a43da73f4ad");
    if ($Keywords=="") $keywords = "Webmoney, продать WebMoney, обмен webmoney, вебмани, купить продать WMZ, обмен WMZ, wmz на доллары, WMZ на наличные, WMZ, WMR, WMU, WME, обменник, электронная валюта";


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
       <h1>OKWM и WebMoney</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
        <p><u><b>Наш сервис предоставляет клиентам следующие услуги по обмену титульных знаков WebMoney:</b></u><br />
        <ul>
        <li>Автоматический обмен титульных знаков системы WebMoney Transfer, а именно: WMZ, WMR, WME, WMU.<br />
        Обмен электронных валют WebMoney между собой осуществляется автоматически и круглосуточно на сайте без участия оператора.<br />
        <a href="$http/help.asp#autoexchange" target="_BLANK">Как осуществить <b>автообмен электронных валют</b></a></li>
        <li>Ввод и вывод титульных знаков WebMoney: WMZ, WMR, WME, WMU.<br />
        Обмен электронных валют на наличные средства и наличных на электронные осуществляется по заявке на сайте после уточнения
        наличия необходимой Вам суммы.<br />
        <a href="$http/help.asp#cash" target="_BLANK">Как оформить заявку на <b>покупку WebMoney</b> на Ваш кошелек (ввод средств в систему)</a><br />
        <a href="$http/help.asp#emoney" target="_BLANK">Как оформить заявку на <b>обмен WebMoney на наличные</b> (вывод средств из системы)</a></li>
        <li>Автоматический обмен титульных знаков WebMoney на ваучеры Ukash и наоборот. <a href="$http/ukash.asp" target="_BLANK">Подробнее...</a></li>
        <li>Ввод/вывод средств через WebMoney на бирже ставок Betfair. <a href="$http/betfair.asp" target="_BLANK">Подробнее...</a></li>
        <li>Пополнение счетов на покерном сайте Pokerstars за WebMoney. <a href="$http/pokerstars.asp" target="_BLANK">Подробнее...</a></li>
        </ul>
        </p>
        <p><u><b>Просим Вас обратить внимание на правила проведения обменных операций WebMoney</b><br /> в соответствии с
        <a href="https://www.megastock.ru/Doc/exchange_rules.aspx" target="_BLANK">Положением о порядке использования системы WebMoney Transfer
        для обменных операций с финансовыми инструментами</a> от 15 апреля 2010г.</u>
        </p>
        <p>
        <ul>
        <li>Вводить/выводить средства WebMoney имеет право только владелец <a href="https://passport.webmoney.ru/asp/WMCertify.asp" target="_BLANK">WM-аттестата</a>
        лично при наличии паспорта, без участия третьих лиц. То есть данные в аттестате WebMoney (ФИО и серия номер паспорта) и данные клиента
        по заявке должны совпадать.</li>
        <li>Ваш WM-аттестат должен быть не ниже формального (если у Вас аттестат псевдонима – обмен производиться не будет).
        Формальный аттестат выдается бесплатно участнику системы WebMoney Transfer после ввода паспортных данных на сайте
        <a href="http://passport.webmoney.ru/" target="_BLANK">Центра аттестации</a>.</li>
        <li>Если Вы хотите вывести средства из системы, Ваш WMID должен быть зарегистрирован не менее чем 7 суток назад.</li>
        </ul>
        </p>
        <p>
        <b>Краткая информация о системе WebMoney Transfer</b><br /><br />
        <u>WebMoney Transfer</u> – система моментальных интернет-переводов, создана в 1998 году. Платежная система WebMoney
        обеспечивает проведение расчетов online посредством титульных знаков WebMoney.<br /><br />
        Главный сайт системы – <a href="http://www.webmoney.ru/" target="_BLANK">www.webmoney.ru</a>, украинский сайт – <a href="http://www.webmoney.ua/" target="_BLANK">www.webmoney.ua</a>.<br />
        Компания WM Transfer Ltd – владелец и администратор платежной системы WebMoney Transfer.<br />
        Функцию технического оператора системы выполняет ЗАО «Вычислительные силы» (г. Москва).<br /><br />
        Для системы WebMoney не существует границ и расстояний – совершать операции с электронными деньгами и пользоваться
        всеми сервисами системы можно, находясь в любой точке земного шара. Технология WebMoney Transfer разработана с учетом
        современных требований безопасности, предъявляемых к системам управления информацией через Интернет. Все трансакции в системе
        являются мгновенными и безотзывными, что гарантирует окончательность сделки и платежа.<br /><br />
        Принцип работы системы довольно прост.<br />
        Чтобы стать участником системы WebMoney Transfer, необходимо установить на своем персональном компьютере, КПК или мобильном телефоне
        <a href="http://www.webmoney.ru/rus/about/demo/index.shtml" target="_BLANK">клиентский интерфейс</a>, зарегистрироваться в системе и принять
        ее условия, получив при этом WM-идентификатор – уникальный номер пользователя. Процесс регистрации также предусматривает
        ввод персональных данных и подтверждение их достоверности через сервис <a href="https://passport.webmoney.ru/asp/pasMain.asp" target="_BLANK">WM-аттестации</a>.
        Каждый пользователь имеет <a href="https://passport.webmoney.ru/asp/wmcertify.asp" target="_BLANK">WM-аттестат</a> – цифровое свидетельство,
        составленное на основании предоставленных им персональных данных.<br /><br />
        Система поддерживает несколько типов титульных знаков WM, обеспеченных различными активами и хранящихся на соответствующих
        электронных кошельках.
        </p>
        <p>
        <u>Наш обменный сервис работает с четырьмя типами кошельков, а именно:</u>
        <ul>
        <li>WMZ – эквивалент долларов США (кошелек типа Z);</li>
        <li>WMU – эквивалент украинских гривен (кошелек типа U);</li>
        <li>WMR – эквивалент российских рублей (кошелек типа R);</li>
        <li>WME – эквивалент евро (кошелек типа Е).</li>
        </ul>
        </p>
        <p>
        Эмиссию титульных знаков определенного типа осуществляет Гарант - организация, управляющая обеспечением эмиссии, устанавливающая
        эквивалент обмена на заявленные имущественные права, обеспечивающая юридически значимое введение в хозяйственный оборот
        титульных знаков гарантируемого типа в соответствии с законами страны регистрации.
        </p>
        <p>
        Для эффективного ведения бизнеса и обмена информацией в системе предусмотрены дополнительные сервисы, позволяющие участникам
        <a href="http://www.webmoney.ru/rus/services/security.shtml" target="_BLANK">обеспечивать необходимый уровень безопасности операций</a>,
        <a href="http://www.webmoney.ru/rus/services/budget.shtml" target="_BLANK">автоматизировать расчеты</a>, вести учет, проводить
        <a href="http://www.exchanger.ru/asp/about.asp">обмен различных расчетных средств</a>, оперативно находить
        <a href="http://geo.webmoney.ru/users/" target="_BLANK">партнеров в своем регионе</a>, не отходя от своего компьютера. Более подробно узнать
        о сервисах WebMoney можно <a href="http://www.webmoney.ru/rus/services/index.shtml" target="_BLANK">здесь</a>.<br /><br />
        Ознакомиться детально с платежной системой WebMoney Transfer Вы можете на сайте
        <a href="http://webmoney.ru/rus/about/index.shtml" target="_BLANK">www.webmoney.ru</a>.
        </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>