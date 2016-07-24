<?php
#--------------------------------------------------------------------
# OKWM WMU to Ukash page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
$https= DOMAIN_HTTPS;
// Контакты
$title = "Купить продать Ukash за Webmoney WMU";
$Keywords = "Ukash за WMU, купить ваучер ukash, продать, обмен, обменник, электронная валюта, платежная система";
$Description = "онлайн обмен wmu на Ukash, моментальная покупка ваучера UKASH на любую сумму";
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
       <h1>Купить ваучер Ukash за WMU</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="wmukash">
		<script language="JavaScript">
		  var key_2_press=new Image();
		  key_2_press.src='$domain/img/keys/key_2_press.gif';
		</script>
      <p>Первый сервис в Интернете по обмену WMU на Ukash &euro;.</p>
      <script src="/js/main.js" type="text/javascript"></script>
      <script>
EOT;
    //include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/js/main.js");
    echo "</script>";
    require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/js/pereschet.js");
    echo <<<EOT
      <p>
      <form enctype="multipart/form-data" method="post" name="makeexchange" id="makeexchange" action="$domain/specification.asp">

		<input type="hidden" name="title_page" value="$title">
		Внести сумму WMU <input type="text" name="InSum3" value="" onclick="OutSum7.value=InSum2OutSum('WMU', 'UKSH', InSum3.value);" onkeypress="OutSum7.value=InSum2OutSum('WMU', 'UKSH', InSum3.value);" onkeyup="OutSum7.value=InSum2OutSum('WMU', 'UKSH', InSum3.value);"><br />
		Сумма ваучера Ukash &euro; <input type="text" name="OutSum7" value="" readonly><br /><br />
		<input type="hidden" name="inmoney" value="3">
		<input type="hidden" name="outmoney" value="7">
		<input type="hidden" name="order" value="ukrbuy">
		<img src="$domain/img/keys/key_2_symple.gif" width="136" height="19"
		     onMouseOut  = "this.src = '$domain/img/keys/key_2_symple.gif';"
		     onMouseOver = "this.src =  key_2_press.src;"
		     onClick     = "document.makeexchange.submit();">
		<br>

      </form>
      </p>
      <hr color=#C0C0C0 size=3 noshade>
      </div>
      <div id="help">
		<p><img src="/img/ukash-logo.gif" alt="Ukash" border="0"><br />
		Наш сервис предоставляет возможность покупать ваучеры Ukash любого номинала, оплачивая их удобными для Вас способами
		(титульные знаки WebMoney или наличные средства).
        </p>
        <p><b>Что такое Ukash?</b><br /></p>
        <p>Ваучеры Ukash - это универсальный предоплаченный метод расчетов, используемый в Интернете.<br />
        При помощи ваучеров Ukash можно оплачивать различные товары и услуги, участие в онлайн играх, делать ставки в букмекерских конторах
        и казино, совершая анонимные и безопасные расчеты в интернете. Прежде всего, это удобно для тех, кто не может получить кредитную
        карту в силу объективных причин (подростки, нерезиденты), опасается хищения денег с банковской карточки или желает по ряду причин
        сохранить свою анонимность.
        </p>
        <p>Использовать Ukash очень просто.<br />
        1.	Купите ваучер Ukash.<br />
        2.	Выберите Ukash в качестве метода оплаты.<br />
        3.	Введите номер и номинал ваучера - и все готово!<br />
        </p>
        <p><b>Как и где купить Ukash ваучер?</b><br />
        Существует два способа приобретения ваучера при помощи нашего сервиса.<br />
        1.	заказать онлайн ваучер Ukash любого номинала, используя в качестве оплаты титульные знаки WebMoney (WMZ, WME, WMR, WMU);<br />
        2.	прийти в офис нашего представительства и купить ваучер Ukash любого номинала за наличные средства.
        </p>
        <p><b>Как проверить Ukash ваучер?</b><br />
        Проверить, действителен ли код ваучера Ukash можно на официальном сайте Ukash. Для этого нужно зарегистрироваться на сайте
        <a href="http://www.ukash.com" target="_blank">www.ukash.com</a> и использовать в разделе
        <a href="http://www.ukash.com/uk/en/mytoolkit/" target="_blank">Tool Kit</a> ("Инструментарий") функции Comine (соединить)
        или Split (разделить) номинал ваучера.
        </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
?>