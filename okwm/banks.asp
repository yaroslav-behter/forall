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
// Контакты
$title = "ПАО «КБ «ПІВДЕНКОМБАНК»";
$Keywords = "Вывод Webmoney в ПІВДЕНКОМБАНК, вывод в Южкомбанк, на карту, положить на счет в банке, обмен, обменник, электронная валюта";
$Description = "Правила вывода WebMoney на карточный счет в Южкомбанке, получить любую сумму на счет в банках партнерах.";
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
       <h1>ПАО &laquo;КБ &laquo;ПРИВАТБАНК&raquo;</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <p>
         <div align="center"><b>Уважаемые клиенты сервиса OKWM.com.ua!</b></div>
      </p>
      <div id="help">
		<p>Мы рады предложить Вам новую услугу – вывод титульных знаков WebMoney на счета и карты банков-партнеров:
		ПАО &laquo;КБ &laquo;ПриватБанк&raquo;.    АО «КБ «»
		</p>
		<p>Выводить и вводить средства имеет право только владелец кошелька WebMoney (WMZ, WMR, WME, WMU). Те же условия распространяются
		и на операции с кошельками Яндекс.Денег, если Вы хотите их купить или продать. При использовании карточек для услуг, связанных
		с вводом и выводом Betfair, PokerStars Вы должны соблюдать не только правила работы с кредитными картами, но и условия сервисов.
		Соответствие данных, указанных в заявке, с паспортными данными клиента проверяется администратором. Для этого клиент обязан
		предоставить администратору сканы своего паспорта.
		В случае несовпадения данных средства будут возвращены на кошелек отправителя за вычетом комиссии системы.</p>

        <p><u><i><b>ПАО &laquo;КБ &laquo;ПРИВАТБАНК&raquo;</b></i></u></p>
        <p>
        1. Информация о представительствах банка по регионам: <a href="http://maps.privatbank.ua/" target="_blank">http://maps.privatbank.ua/</a>.<br />
        2. Информация о платежных картах <a href="http://privatbank.ua/html/5_4r.html" target="_blank">http://privatbank.ua/html/5_4r.html</a>.<br />
        3. Тарифы по личным дебетным картам <a href="http://privatbank.ua/info/index1.stm?fileName=5_4_10_5r.html" target="_blank">http://privatbank.ua/info/index1.stm?fileName=5_4_10_5r.html</a>.<br />
        4. Информация о том, как подключиться к Приват24 <a href="http://privatbank.ua/html/5_8_1_2r.html" target="_blank">http://privatbank.ua/html/5_8_1_2r.html</a>.<br />
        5. Управление счетом с помощью MobileBanking <a href="http://privatbank.ua/html/5_6_8r.html" target="_blank">http://privatbank.ua/html/5_6_8r.html</a>.<br />
        6. Прочие услуги банка <a href="http://privatbank.ua/html/3r.html" target="_blank">http://privatbank.ua/html/3r.html</a>.<br />
        </p>
        <p>Кратко о наиболее популярных платежных картах:<br />
        <u>Карта &quot;Миттєва&quot;</u><br />
        - оформление за 10 минут;<br />
        - мгновенное пополнение счета;<br />
        - открытие картсчета 25 грн / 5 USD.<br /><br />

        <u>Личная дебетная карта</u><br />
        - персонифицированная международная карта VISA Classic или MasterCard Standard;<br />
        - мгновенное пополнение счета;<br />
        - открытие картсчета 150 грн / 30 USD.<br />
        </p>

      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>