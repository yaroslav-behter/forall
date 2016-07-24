<?php
#--------------------------------------------------------------------
# OKWM contacts page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
$WMid = WM_ID;

/*

// ICQ Status Indicator - 637139590
$curl=curl_init();
curl_setopt($curl, CURLOPT_URL, "http://status.icq.com/online.gif?icq=637139590&img=27");
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
$stat=curl_exec($curl);
curl_close($curl);
if (strstr($stat, "online1")) { $status_637139590 = "Online"; }

*/
// Контакты
$title = "Контакты администраторов OKWM для обмена, ввода и вывода WebMoney, Ukash, Pokerstars, Betfair";
$Keywords = "комиссия Webmoney, курс обмена wmz, купить WMZ, продать WMZ, wmz на доллары, WMZ на наличные, купить wm, WMZ, WME, продать WebMoney, обмен, обменник, электронная валюта";
$Description = "Выгодно и быстро обменять WebMoney, Ukash, Pokerstars, Betfair в Киеве, Одессе, Днепропетровске.";
HTMLHead ($title, $Keywords, $Description);
echo <<<EOT

	 <tr><td></td><td id="phl"><img width="1" height="4" alt="" src="$http/img/0.gif" /></td>
	     <td id="phr"><img width="210" height="4" alt="" src="$http/img/0.gif" /></td><td></td>
	 <td rowspan="5" class="right_banners">
EOT;
    if (!isset($HTTP_SERVER_VARS['HTTPS'])) EchoBaners ();
    echo <<<EOT
	 </td>
	 </tr>
	 <tr><td class="lsh"></td><td id="pbl">
       <h1>Контакты</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="news">
       <p>
       Телефон и ICQ администраторов (для всех представительств):<br>
       +380 (97) 479-00-08 Киевстар<br>
       +380 (95) 649-00-08 МТС<br><br />
       <!--+380 (73) 439-00-08 Life:)<br><br-->

       <a href="http://web.icq.com/whitepages/add_me?uin=637139590&action=add" title="Добавить в список контактов"> <b>ICQ 637139590</b> <img src="img/icq.gif" border=0></a> Лилия<br>
       Skype: okwm-info <script type="text/javascript" src="http://download.skype.com/share/skypebuttons/js/skypeCheck.js"></script>
       <a href="skype:okwm-info?call"><img src="http://mystatus.skype.com/bigclassic/okwm-info" style="border: none;" width="91" height="22" alt="Статус OKWM" /></a><br />
       <small><b>Внимание!</b> Логины Skype: <b>okwm-info</b>. (точка в конце) и <b>okwm_info</b> (нижнее подчеркивание) - МОШЕННИКИ!</small><br />
       <a href="https://twitter.com/OKWMcomua" class="twitter-follow-button" data-show-count="false" data-lang="ru">Твитнуть @OKWMcomua</a>
       <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
       <br /><br />
       WMId $WMid<br>
       Аттестат продавца: <a href="https://passport.webmoney.ru/asp/CertView.asp?wmid=179209804904" target="_blank">
       Рыков Дмитрий Николаевич</a><br />
       Номер ресурса в каталоге <a href="http://megastock.ru/searchres.aspx?search=okwm.com.ua">Мегасток</a> 9460<br>
       e-mail: <a href="mailto:admin@okwm.com.ua"><img src="$http/img/admin.png" alt="обмен WMZ на наличные" title="Отправить письмо администратору"></a><br /><br />
       <b>Если у Вас есть предложения или замечания по работе нашего сервиса, пожалуйста нажмите <a href="/policy.asp">сюда</a>.</b>
       </p>
       <hr>
       <p>
       <!-- Адресса -->
       <a href="$http/contacts/map_kiev.asp" title="Подробнее" target="_blank">г. <b>Киев, Украина</b></a><br>
       ул.Большая Васильковская д.65, 3й этаж, оф.355. Станция метро &quot;Олимпийская&quot;.<br>
       Понедельник - пятница с 10<sup><u>00</u></sup> до 18<sup><u>00</u></sup>,<br>
       выходные дни: суббота и воскресенье.<br><br>


       <a href="$http/contacts/map_dp.asp" title="Подробнее" target="_blank">г. <b>Днепропетровск, Украина</b></a><br>
       ул. Владимира Мономаха (Московская), 7 2й этаж, комн. 215.<br>
       Понедельник - пятница с 12<sup><u>00</u></sup> до 18<sup><u>00</u></sup>,<br>
       выходные дни: суббота и воскресенье.<br><br>


       <a href="$http/contacts/map_od.asp" title="Подробнее" target="_blank">г. <b>Одесса, Украина</b></a><br>
       Вознесенский переулок, дом 2а, офис 10.<br>
       Понедельник - пятница с 12<sup><u>00</u></sup> до 18<sup><u>00</u></sup>,<br>
       выходные дни: суббота и воскресенье.<br><br>
       </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
?>