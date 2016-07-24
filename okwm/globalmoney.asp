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
    $title = GetSEO("9aa2614f84c0601f34548e7079a74762");
    if ($title=="") $title = "Купить, продать, обменять Ukash. Ваучеры Ukash любого номинала за WebMoney и наличные в Украине";
    $Description = GetSEO("13865a8560d3077d4c88194c333567a8");
    if ($Description=="") $description = "Онлайн обмен Ukash на WebMoney, покупка ваучера Ukash на любую сумму за наличные.";
    $Keywords = GetSEO("1c96e282b8a37a6acca820a8e169826b");
    if ($Keywords=="") $keywords = "Купить юкеш в Украине, купить Ukash, Ukash в Киеве, купить ваучер ukash, продать Ukash, юкеш, Ukash, обмен, обменник, электронная валюта";


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
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <p>
         <div align="center"><img src="/img/visa.png" width="390" height="192" alt="" border="0"><br /><b>Расчетная карта VISA &laquo;Глобалмани&raquo;</b></div>
      </p>
      <div id="help">
		<p>Расчетная карта VISA «Глобалмани» - это уникальный инструмент расчета электронными деньгами через POS-терминалы и в сети Интернет,
		а также удобный способ обратного обмена электронных гривен на наличные с помощью банкоматов.<br /><br />
		Данная карта НЕ ИМЕННАЯ, что позволяет сохранить анонимность ее владельца. Для оформления карты нет необходимости
		предоставлять паспорт или идентификационный код в банк, оформлять договора. Для вывода Webmoney на VISA Globalmoney
		привязывать карту к Вашему WMID не нужно.<br /><br />

		Возможности карты:<br />
		- Снятие денег в любом банкомате, который принимает карточки международной платежной системы MasterCard/VISA,
		по всей Украине и в мире.<br />
		- Расчет картой в торговых сетях через POS-терминалы.<br />
		- Расчет в сети Интернет через системы Интернет-эквайринга.<br /><br />

		Стоимость расчетной карты: 50 грн.
		</p>

      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>