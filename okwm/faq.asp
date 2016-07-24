<script language="PHP">
#--------------------------------------------------------------------
# OKWM help page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;

// Контакты
$title = "OKWM.com.ua – купить, продать, обменять WebMoney WMZ WMR WME WMU, Ukash, Pokerstars, Betfair";
$Keywords = "Киев, Днепропетровск, Одесса, комиссия Webmoney, курс обмена wmz, купить WMZ, продать WMZ, wmz на доллары, WMZ, WME, продать WebMoney, обменник";
$Description = "Выгодно и быстро обменять WebMoney, Pokerstars, Ukash, Betfair в Киеве, Одессе, Днепропетровске.";
HTMLHead ($title, $Keywords, $Description);
echo <<<EOT

	 <tr><td></td><td id="phl"><img width="1" height="4" alt="" src="$http/img/0.gif" /></td>
	     <td id="phr"><img width="210" height="4" alt="" src="$http/img/0.gif" /></td>
	     <td></td>
	 <td rowspan="5" class="right_banners">
EOT;
    if (!isset($HTTP_SERVER_VARS['HTTPS'])) EchoBaners ();
    echo <<<EOT

	 </td>
	 </tr>
	 <tr><td class="lsh"></td><td id="pbl">
       <h1>Вопросы и ответы</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
		<p>
		<div align="center"><b>Уважаемые клиенты сервиса OKWM.com.ua!</b></div>
		</p>
		<p><b>Для чего существует Ваш обменный пункт?</b><br>
		Проект <a href="$http" title="Обменный пункт" target="_blank" >OKWM.com.ua</a>
		разработан как универсальный сервис обмена титульных знаков системы
		<a href="http://webmoney.ru/rus/about/index.shtml" target="_blank">WebMoney Transfer</a> между собой и на наличные средства
		в пяти городах Украины. Также мы предоставляем услуги по вводу/выводу средств с биржи ставок
		<a href="http://www.betfair.com/" target="_blank">Betfair</a>. Более подробно об этих и других услугах можно прочитать
		<a href="$http/help.asp">здесь</a>.
		</p>
		<p><b>Какие гарантии Вы предоставляете?</b><br>
		Наш ресурс размещен в официальном каталоге обменных пунктов системы WebMoney Transfer
		<a href="http://www.megastock.ru/Resources.aspx?gid=19" target="_blank">MegaStock.ru</a>, мы имеем
		<a href="http://wiki.webmoney.ru/wiki/list/Аттестация">Аттестат Продавца</a> и вся информация о нас, включая паспортные данные
		Владельца Аттестата, проверена и хранится в базе данных системы WebMoney Transfer.
		</p>
		<p><b>Что такое WebMoney?</b><br>
		Электронная платежная система <a href="http://webmoney.ru/rus/about/index.shtml target="_blank"">WebMoney Transfer</a> обеспечивает
		проведение расчетов online посредством титульных знаков WebMoney. Управление движением титульных знаков осуществляется пользователями
		с помощью клиентской программы WebMoney Keeper.
		<a href="http://webmoney.ru/rus/about/index.shtml" target="_blank" title="Описание системы WebMoney Transfer" target="_blank">Подробнее о системе WebMoney.</a>
		</p>
		<p><b>Как зарегистрироваться в системе WebMoney?</b><br>
        Чтобы открыть кошелек в системе Вам необходимо зайти на сайт
        <a href="http://stat.webmoney.ru/" target="_blank" title="Сайт системы WebMoney Transfer" target="_blank">WebMoney.ru</a>,
        пройти процедуру <a href="http://stat.webmoney.ru/" target="_blank" title="Сайт системы WebMoney Transfer" target="_blank">регистрации</a>,
        скачать программу WebMoney Keeper и установить, следуя инструкциям инсталлятора.
		</p>
		<p><b>Можно ли открыть кошелек WebMoney в Вашем представительстве?</b><br>
		Нет, Вы должны сами зарегистрироваться на сайте системы <a href="http://start.webmoney.ru/"  target="_blank">WebMoney.ru</a>,
		т.к. услуг по регистрации кошельков мы не предоставляем.
		</p>
		<p><b>Что такое Betfair?</b><br>
		Компания <a href="http://www.betfair.com/" target="_blank">Betfair.com</a> –революционная биржа ставок online, на которой,
		в отличие от букмекерской конторы, ставки заключаются напрямую между игроками. Благодаря партнерскому соглашению между обменным
		сервисом OKWM и компанией Betfair, все желающие могут пополнять и выводить средства наличными в любом удобном отделении OKWM
		с комиссией 0% при соблюдении определенных <a href="$http/betfair.asp" target="_blank">правил</a>.
		</p>
		<p><b>Нужно ли регистрироваться на Вашем сайте?</b><br>
		Если Вы хотите обменять титульные знаки WebMoney, то регистрация не нужна. Если Вы хотите воспользоваться услугами по вводу/выводу
		средств Betfair, то необходимо пройти регистрацию по этой <a href="$http/bf/" target="_blank">ссылке</a>.
		</p>
		<p><b>Могу ли я обменять одну электронную валюту на другую на Вашем сайте?</b><br>
		Да, обмен электронных валют WebMoney между собой осуществляется по <a href="$http/help.asp#autoexchange" target="_blank">заявкам</a>
		автоматически и круглосуточно без участия оператора.
		</p>
		<p><b>Как осуществляется обмен валют в Ваших представительствах?</b><br>
		Оформляете заявку на <a href="$http/help.asp#cash" target="_blank">ввод</a> или
		<a href="$http/help.asp#emoney" target="_blank">вывод</a> необходимой валюты с обязательным указанием требуемых данных. Порядок
		оформления заявок можно посмотреть <a href="$http/help.asp" target="_blank">здесь</a>.
		</p>
		<p><b>Могу ли я приехать к вам в офис и сразу произвести необходимый мне обмен?</b><br>
		Да, но только после согласования с администратором и при наличии собственных мобильных средств для совершения обмена
		(ноутбук, КПК, мобильный телефон и т.п.).
		</p>
		<p><b>Какова минимальная и максимальная сумма для обмена?</b><br>
		Минимальная сумма обмена составляет эквивалент 5 USD. Максимальная сумма определяется наличием средств на момент обмена,
		Вы можете уточнить ее у администратора перед оформлением заявки.
		</p>
		<p><b>Зачем Вам нужны мои паспортные данные (данные другого документа) при оформлении заявки?</b><br>
		Это <a href="http://www.megastock.ru/Doc/exchange_agreement.aspx" target="_blank">требования платежной системы WebMoney</a>
		к обменным пунктам для предупреждения мошенничества. Предоставляемые Вами данные необходимы для подтверждения Вашей личности
		в нашем офисе и не передаются третьим лицам.
		</p>
		<p><b>Действуют ли в Вашем обменном пункте накопительные скидки?</b><br>
		Став нашим постоянным клиентом, Вы можете получить определенную скидку на разовый обмен или на постоянной основе по договоренности
		с администратором. При этом администрация сайта оставляет за собой право отменить предоставленную скидку ввиду определенных
		обстоятельств, предупредив Вас об этом перед совершением обмена.
		</p>
		<p><b>Если Вы не нашли ответ на свой вопрос, обратитесь к разделу <a href="$http/help.asp" target="_blank">Помощь</a> или уточните
		у <a href="$http/contacts.asp">администраторов</a>:</b>
		<ul>
		<li>по e-mail, WMID и ICQ в рабочие дни с 11-00 до 19-00, в субботу и воскресенье с 12-00 до 14-00;</li>
		<li>по телефонам – круглосуточно.</li>
        <ul>
        </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>