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
    $title = GetSEO("4b5af7a8ddebd9f5755d50abed72b1ab");
    if ($title=="") $title = "Зарегестрироваться, играть, пополнить счет, вывести деньги Покерстарс (Pokerstars)";
    $Description = GetSEO("cdac824f1ce0b7f32b08f7c14be7ec61");
    if ($Description=="") $description = "Описание партнерских отношений с крупнейшим Покер-рум Pokerstars.com.";
    $Keywords = GetSEO("5db31f73edf5ae8c28364482ace86eac");
    if ($Keywords=="") $keywords = "Киев, Днепропетровск, Одесса, Запорожье, Webmoney в Киеве, Наличные деньги, купить wm, WMZ, WME, продать, обмен, обменник, электронная валюта, ставки, тотализатор, букмекерския контора";


/*
    // SEO strings
    $title = GetSEO("");
    if ($title=="") $title = "";
    $Description = GetSEO("");
    if ($Description=="") $description = "";
    $Keywords = GetSEO("");
    if ($Keywords=="") $keywords = "";

*/






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
       <h1>О Pokerstars</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
		<p>
		<div align="center"><b>Специальные договоренности &bdquo;PokerStars&ldquo; и &bdquo;OKWM&ldquo;.</b></div>
		<br />
        <p>
        Благодаря экслюзивному агентскому соглашению между OKWM и крупнейшим в мире покер-румом
        <a href="http://www.pokerstars.com?source=psp12329" target="_blank">PokerStars.com</a>,
        игрокам предоставляется уникальная возможность пополнения игрового счета наличными в пяти офисах компании
        и всеми видами кошельков системы Webmoney (WMZ,WMR,WMU). Сегодня доступными формами обмена, покупки и продаж ваучеров
        являются Webmoney (WMZ, WME, WMR, WMU), Яндекс.Денег, карточки Visa, Master, Приват24.
        Ознакомиться с условиями предложения можно ниже.
        </p>
        <p>
        <u>Пополнение счета:</u><br />
        - наличными в одном из офисов;<br />
        - через интернет с кошельков Webmoney (WMZ,WMR,WMU)<br />
        Сроки: до $5000 – моментально в рабочее время, свыше $5000 – в течение 1 одного дня.
        </p>
        <p><u>Вывод средств:</u><br />
        Комиссия на вывод со счета составляет:<br />
        до 1000 $ - 5%;<br />
		от 1000$ до 5000 $ - 4%;<br />
		от 5000$ до 10 000$ - 3.5%;<br />
		от 10 000$ до 25 000$ - 3%;<br />
		от 25 000$ до 50 000$ - 2.5%;<br />
		от 50 000 - 2%.<br /><br />
        Срок получения наличных – через 48 часов после перевода.<br />
        В офисе при получении средств необходимо назвать Ваш логин, дату перевода, сумму, номер транзакции.<br />
        Чтобы вывести средства из PokerStars, необходимо обратиться к администраторам сервиса (раздел <a href="$http/contacts.asp">Контакты</a>)
        для уточнения реквизитов перевода и других деталей.
        </p>
        <p>Если у Вас нет счета на PokerStars, зарегистрируйте по ссылке ниже и воспользуйтесь услугами нашего сервиса.<br />
        <a href="http://www.pokerstars.com/ru/?source=psp12329" target="_blank">Регистрация на PokerStars</a>
        </p>
		<p><b>Краткая информация о компании &quot;PokerStars&quot;.</b></p>
		<p>
		<i>Наименование:</i> <u>PokerStars</u><br />
		<i>Основной вид деятельности:</i> онлайн покер<br />
		<i>Головной офис:</i> Остров Мэн, Великобритания<br />
		<i>Главный сайт:</i> <a href="http://www.pokerstars.com/ru/?source=psp12329" target="_blank">www.pokerstars.com</a><br /><br />
		PokerStars – это самый большой покер-рум в мире, который объединяет 30 миллионов зарегистрированных игроков.
		Он располагает большим количеством игровых столов, чем любой другой сайт. PokerStars, являясь основной интернет-платформой
		для сильнейших игроков, предоставляет лучшее программное обеспечение и наивысший уровень безопасности в  мире онлайн покера.
		Каждый день на сайте проходят многочисленные турниры.<br /><br />
		PokerStars обладатель двух рекордов Гиннеса:<br />
		- 300 тыс. игроков одновременно присутствовало на сайте<br />
		- 65 тыс игроков участвовало в одном турнире<br /><br />
		PokerStars является организатором самой масштабной и самой известной серии покерных турниров в интернете – Чемпионата Мира
		по Онлайн Покеру (WCOOP), а также спонсором живых турниров по покеру: European Poker Tour (<a href="http://www.ept.com/" target="_blank">www.ept.com</a>),
		PokerStars Caribbean Adventure, Latin American Poker Tour (<a href="http://www.lapt.com" target="_blank">www.lapt.com</a>),
		Asia Pacific Poker Tour (<a href="http://www.appt.com" target="_blank">www.appt.com</a>) и The World Cup of Poker.<br /><br />
		PokerStars – родная онлайн площадка для команды профессионалов Team PokerStars Pro, в которую входят ветераны и перспективные игроки
		со всего мира. Команда PokerStars Pro регулярно участвует в турнирах. Покер-рум спонсирует участие членов команды
		в международных соревнованиях по всему миру.
        </p>
        <p>Полезные ссылки:<br />
        <a href="http://www.pokerstars.com/ru/?source=psp12329" target="_blank">Регистрация на PokerStars</a><br />
        <a href="http://www.pokerstars.com/ru/poker/download/" target="_blank">Скачать покер для игры на PokerStars</a><br />
        <a href="http://www.pokerstars.com/ru/poker/room/support/" target="_blank">Служба поддержки клиентов PokerStars</a><br />
        <a href="http://www.pokerstarsblog.com/ru/" target="_blank">Новостной блог PokerStars</a></p>

      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>