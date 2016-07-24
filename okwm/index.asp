<?php
#--------------------------------------------------------------------
# OKWM welcome page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2010.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");

    $http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
    $https = DOMAIN_HTTPS;
    $WMid = WM_ID;
    $str = GetCurrStr();
    $comStr = GetComCurrStr();
    $turday = date ("d.m.y");

    // SEO strings
    $title = GetSEO("afc29e2f9a98dffc3e2b945a1d580c66");
    if ($title=="") $title = "OKWM - купить, продать, обменять WMZ WME WMR WMU, Ukash, Betfair, Pokerstars";
    $description = GetSEO("cdf36439dd9ef70d51fa804a17b5e0b7");
    if ($description=="") $description = "Быстро и выгодно обменять WebMoney, Ukash, Pokerstars, Betfair в Киеве, Одессе, Днепропетровске.";
    $keywords = GetSEO("9d4ea185ede88d8c586b23cd15fb0616");
    if ($keywords=="") $keywords = "Киев, Днепропетровск, Одесса, комиссия Webmoney, курс обмена wmz, купить WMZ, продать WMZ, wmz на доллары, WMZ, WME, WMR, WMU, продать WebMoney, обменник, regbnm u kash";

	echo <<<EOT
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang="ru">
<head>
  <title>$title</title>
  <meta content="$keywords" name="keywords" />
  <meta content="$description" name="description" />
  <meta http-equiv="Content-type" content="text/html;charset=windows-1251" />
  <style type="text/css">@import URL($http/styles/main.css);</style>
  <link rel="icon" href="$http/img/favicon.ico" type="image/x-icon">
  <link rel="shortcut icon" href="$http/img/favicon.ico" type="image/x-icon">
  <link rel="stylesheet" type="text/css" href="styles/main.css" />
  <script src="/js/main.js" type="text/javascript"></script>
  <script src="/js/pereschet.js" type="text/javascript"></script>
  <script src="/js/nbu.js" type="text/javascript"></script>
  <script type="text/javascript">
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-24113950-5']);
    _gaq.push(['_trackPageview']);

    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
  </script>
  <script type="text/javascript">
  var fb_param = {};
  fb_param.pixel_id = '6007952271053';
  fb_param.value = '0.00';
  (function(){
    var fpw = document.createElement('script');
    fpw.async = true;
    fpw.src = '//connect.facebook.net/en_US/fp.js';
    var ref = document.getElementsByTagName('script')[0];
    ref.parentNode.insertBefore(fpw, ref);
  })();
  </script>
  <noscript>
      <img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/offsite_event.php?id=6007952271053&amp;value=0" />
  </noscript>

<script type="text/javascript">

 var _gaq = _gaq || [];
 _gaq.push(['_setAccount', 'UA-31274780-1']);
 _gaq.push(['_setDomainName', 'okwm.com.ua']);
 _gaq.push(['_trackPageview']);

 (function() {
   var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
   ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
   var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
 })();

</script>

</head>
<body>
 <table align="left" width="90%" cellspacing="0" height="100%">
 <tr><td width="3" class="lsh"></td>
     <td width="50%" bgcolor="white" style="min-width:375px"><img width="375" height="1" src="http://www.okwm.com.ua/img/0.gif" /></td>
     <td width="50%" bgcolor="white" style="min-width:375px"><img width="375" height="1" src="http://www.okwm.com.ua/img/0.gif" /></td>
     <td width="3" class="rsh"></td>
     <td rowspan="4" width="150"><img width="150" height="1" src="$http/img/0.gif" /></td>
 </tr>
 <tr><td class="lsh"></td><td id="header" colspan="2">
    <div id="htop">
       <h1>OKWM - обмен титульных знаков. WebМoney (WMZ, WME, WMR, WMU), пополнение счетов Pokerstars, Betfair</h1>
		<div style="float: right; text-align: right; color: #808080; padding-right: 20px; margin-top: 15px; font-size: 11px; font-weight: bold; font-family: Verdana;">
		</div>
     <div id="sertif">
      <a href="http://passport.webmoney.ru/asp/certview.asp?wmid=$WMid" target=_blank><img src="$http/img/sert1.gif" title="Здесь находится аттестат нашего WMid $WMid" alt="продать webmoney, купить Webmoney"/></a>
         </div>
       <div id="kurs">
          Курс <a href="http://www.bank.gov.ua" target="_blank" title="Сайт Национального Банка Украины">НБУ</a> на $turday<br />
          <b>${str[0]}</b>
       </div>
       <div id="comKurs">
          Коммерческий курс<br />${comStr[0]}
       </div>
    </div>
  </td><td class="rsh"></td>
 </tr>
 <tr><td colspan="2" width="45%" id="hbl"><img width="1" height="13" alt="" src="$http/img/0.gif" /></td>
   <td colspan="2" width="45%" id="hbr"><img width="1" height="13" alt="" src="$http/img/0.gif" /></td>
 </tr>
 <tr><td colspan="4" id="nav">
     <ul id="cities">
      <li><a href="$http/contacts/map_kiev.asp">КИЕВ</a></li>
      <li><a href="$http/contacts/map_dp.asp">ДНЕПРОПЕТРОВСК</a></li>
      <li><a href="$http/contacts/map_od.asp">ОДЕССА</a></li>
     </ul>
     <ul id="items">
      <li><a href="#" onMouseOver="show_menu('service_menu',event, this)" onMouseOut="hide_menu('service_menu')">УСЛУГИ</a></li>
      <!--li><a href="$http/wmpolicy.asp">ПРАВИЛА</a></li-->
      <li><a href="$http/partners.asp">ПАРТНЕРСТВО</a></li>
      <li><a href="$http/contacts.asp">КОНТАКТЫ</a></li>
      <li><a href="$http/help.asp">ПОМОЩЬ</a></li>
     </ul>
     <div id="service_menu" onMouseOver="show_menu('service_menu', event)" onMouseOut="hide_menu('service_menu')">
     <ul id="service_menu_items">
      <!--li><a href="$http/att.php">АТТЕСТАТЫ</a></li-->
      <li><a href="$http/tarifs.asp">ТАРИФЫ</a></li>
      <li><a href="$http/betfair.asp">BETFAIR</a></li>
      <li><a href="$http/pokerstars.asp">POKERSTARS</a></li>
      <!--li><a href="$http/ukash.asp">UKASH</a></li-->
     </ul>
     </div>
   </td></tr>

   <tr><td></td>
       <td id="phl"><img width="1" height="4px" alt="" src="$http/img/0.gif" /></td>
       <td id="phr"><img width="1" height="4px" alt="" src="$http/img/0.gif" /></td>
       <td></td>
       <td rowspan="5" class="right_banners">
EOT;
    if (!isset($HTTP_SERVER_VARS['HTTPS'])) EchoBaners ();
    echo <<<EOT

       </td>
   </tr>
   <tr><td></td><td id="pbl_idx"></td><td id="pbr_idx"></td><td></td>
   </tr>

      <form method="post" action="$http/specification.asp" name="makeexchange" id="makeexchange" onSubmit="alert('submit')" >
      <input type="hidden" name="inmoney" id="inmoney" value="" />
      <input type="hidden" name="outmoney" id="outmoney" value="" />
      <input type="hidden" name="town" id="towm" value="" />

EOT;
    include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/in_form.asp");
    echo <<<EOT

   <tr><td class="lsh"></td>
       <td class="ok" style="text-align:left; padding-left: 35px;">
       </td>
       <td class="ok">
			<div align=right style="margin-right:150px;"><a href="#"  onClick="RefCancel()" title="попробуйте другие варианты" id="cancel"></a></div>
     		<div align=right style="margin-right:30px;"><a href="#"  onClick="RefComm()" title="если вас устраивает наше предложение нажмите ДАЛЕЕ" id="ok"></a></div>
   </td><td class="rsh"></td></tr>
   </form>
     <tr><td class="lsh"></td><td id="content" colspan="2">

     <table width="100%" cellpadding="0" cellspacing="10">
    <tr><!--td width="100" id="banners"-->
     <td width="100" id="banners_text">

     <ul id="items">
      <li><a href="$http/wmibox.asp">WMZ на терминалах</a></li>
      <li><a href="$http/webmoney.asp">OKWM и Webmoney</a></li>
      <li><a href="$http/betfair.asp">OKWM и Betfair</a></li>
      <li><a href="$http/pokerstars.asp">OKWM и Pokerstars</a></li>
      <!--li><a href="$http/ukash.asp">OKWM и UKASH</a></li-->
     </ul>
     <div style="margin-top:130px;margin-left:20px">
     <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
     <a href="http://webmoney.ru" target="_blank"><img src="$http/img/banners/100x35_WEB_MONEY.gif" title="Мы принимаем Webmoney"/></a>
     <a href="http://megastock.ru/Resources.aspx?gid=19" target="_blank"><img src="$http/img/banners/100x35_RAIT_POSITION.gif" title="Наша позиция в рейтинге"/></a>
     <a href="http://betfair.com" target="_blank"><img src="$http/img/banners/100x35_BETFAIR.gif" title="Betfair.com"/></a>
     <a href="http://www.pokerstars.com/" target="_blank"><img src="$http/img/banners/100x35_POKER_STARS.gif" title="PokerStars.com"/></a>
     <!--a href="$http/ukash.asp" target="_blank"><img src="$http/img/banners/100x35_U_KASH.gif" title="Ukash.com"/></a-->

     <!--a href="https://twitter.com/share" class="twitter-share-button" data-via="OKWMcomua" data-lang="ru">Твитнуть</a-->
     <a href="http://vk.com/okwmcomua" target="_blank"><input type=image src="$http/img/vk-icon.png" title="Мы в контакте"></a>
     <a href="https://www.facebook.com/pages/OKWM/113902255433916" target="_blank"><input type=image src="$http/img/fb-icon.png" title="Мы в Facebook"></a>
     <a href="https://twitter.com/OKWMcomua" target="_blank" data-via="OKWMcomua" data-lang="ru"><input type=image src="$http/img/twitter-icon.png" title="Мы в Twitter"></a>

     </div>
    <br />
    <br />
   </td>
    <td id="news">
    <p><b>Уважаемые клиенты сервиса OKWM!</b><br />
    Обращаем Ваше внимание, что перед оформлением заявок на вывод средств необходимо связываться с администраторами для уточнения их наличия.
    В целях безопасности вывод средств осуществляется только по заявкам на сайте. За платежи, не согласованные с администраторами сервиса
    и отправленные на кошельки, не принадлежащие WMID <a href="https://passport.webmoney.ru/asp/CertView.asp?wmid=$WMid" target="_blank">$WMid</a>,
    указанному на сайте, сервис OKWM ответственности не несет!<br />
    Также Вы можете ознакомиться с <a href="http://www.wmtransfer.com/rus/cooperation/legal/syagreement1.shtml#3">&quot;Уведомлением о рисках&quot;</a>,
    включенным в Приложение 3 к <a href="http://www.wmtransfer.com/rus/cooperation/legal/syagreement1.shtml">Соглашению о трансфере имущественных прав цифровыми титульными знаками</a>.
    </p>
EOT;
# OKWM news script.
include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/news/news.php");

echo <<<EOT
     <a href="$http/archnews.asp">Архив новостей</a>
     </td></tr></table>

   </td><td class="rsh"></td></tr>
      <tr><td class="lsh"></td><td id="footer" colspan="2">

        <table width="100%" cellpadding="0" cellspacing="0" id="bottom">
          <tr height="110" class="foott"><td width="67%" class="footgreen">

          Мы предоставляем полный спектр услуг по работе с наиболее развитыми платежными системами интернета.
          При обмене между платёжными системами, операции обмена происходят круглосуточно в автоматическом режиме, при обмене связанном с наличным или безналичным расчетом обмен производит оператор.

       </td><td width="33%" class="footblue">
          <ul>
            <li><a href="$http/faq.asp">Есть вопросы?</a></li>
            <li><a href="mailto:Администратор OKWM.com.ua<admin@okwm.com.ua>?subject=Вопрос%20администратору%20OKWM.com.ua&body=Задайте%20свой%20вопрос">Нужна помощь?</a></li>
            <li><a href="$http/help.asp">Не знаете что делать?</a></li>
          </ul>
       </td>
      </tr>
        </table>
        <table width="100%" cellpadding="0" cellspacing="0">
          <tr><td>
      <div id="bott2">
       <p>On-line club OKWM.com.ua<br />
            Copyright © 2009-2014<br />
      <a href="$http/contacts.asp">Контакты</a> -
      <a href="http://passport.webmoney.ru/asp/certview.asp?wmid=$WMid" target=_blank>Проверить аттестат</a> -
      <a href="$http/bn/iclick.php?ad=2" target=_blank title="Наш рейтинг в каталоге Megastock.ru">Наш рейтинг</a>
           </p>
      </div>
       </td><td>
EOT;
    if (!isset($HTTP_SERVER_VARS['HTTPS'])) {
        echo <<<EOT

        <!-- Счетчики --------------------------------------------------------------->
              <br /><br />
              <!-- begin WebMoney Transfer : attestation label -->
              <a href="https://passport.webmoney.ru/asp/certview.asp?wmid=179209804904" target=_blank><IMG SRC="http://www.webmoney.ru/img/icons/88x31_wm_v_blue_on_white_ru.png" title="Здесь находится аттестат нашего WM идентификатора 179209804904" border="0"></a>
              <!-- end WebMoney Transfer : attestation label -->

              <!--WebMoney TOP--><script language="JavaScript"><!--
              document.write('<a href="http://top.owebmoney.ru" target=_blank>'+'<img src="http://top.owebmoney.ru/counter.php?site_id=1085&from='+escape(document.referrer)+'&host='+location.hostname+'&rand='+Math.random()+'" alt="WebMoney TOP" '+'border=0 width=88 height=31></a>')//--></script>
              <noscript><a href="http://top.owebmoney.ru" target=_blank>
              <img src="http://top.owebmoney.ru/counter.php?site_id=1085"
              width=88 height=31 alt="WebMoney TOP" border=0></a></noscript>
              <!--/WebMoney TOP-->
              <!-- SpyLOG -->
              <script src="http://tools.spylog.ru/counter2.2.js" type="text/javascript" id="spylog_code" counter="679936"></script>
              <noscript>
              <a href="http://u6799.36.spylog.com/cnt?cid=679936&f=3&p=0" target="_blank">
              <img src="http://u6799.36.spylog.com/cnt?cid=679936&p=0&f=4" alt='SpyLOG' border='0' width=88 height=31></a>
              </noscript>
              <!--/ SpyLOG -->
              <!--bigmir)net TOP 100-->
              <script type="text/javascript" language="javascript"><!--
              function BM_Draw(oBM_STAT){
              document.write('<table cellpadding="0" cellspacing="0" border="0" style="display:inline;margin-right:4px;"><tr><td><div style="margin:0px;padding:0px;font-size:1px;width:88px;"><div style="background:url(\'http://i.bigmir.net/cnt/samples/diagonal/b58_top.gif\') no-repeat bottom;">&nbsp;</div><div style="font:10px Tahoma;background:url(\'http://i.bigmir.net/cnt/samples/diagonal/b58_center.gif\');"><div style="text-align:center;"><a href="http://top.bigmir.net/report/61256/" target="_blank" style="color:#0000ab;text-decoration:none;font:10px Tahoma;">bigmir<span style="color:#ff0000;">)</span>net</a></div><div style="margin-top:3px;padding: 0px 6px 0px 6px;color:#003596;"><div style="float:left;font:10px Tahoma;">'+oBM_STAT.hosts+'</div><div style="float:right;font:10px Tahoma;">'+oBM_STAT.hits+'</div></div><br clear="all"/></div><div style="background:url(\'http://i.bigmir.net/cnt/samples/diagonal/b58_bottom.gif\') no-repeat top;">&nbsp;</div></div></td></tr></table>');
              }
              //-->
              </script>
              <script type="text/javascript" language="javascript"><!--
              bmN=navigator,bmD=document,bmD.cookie='b=b',i=0,bs=[],bm={o:1,v:61256,s:61256,t:0,c:bmD.cookie?1:0,n:Math.round((Math.random()* 1000000)),w:0};
              for(var f=self;f!=f.parent;f=f.parent)bm.w++;
              try{if(bmN.plugins&&bmN.mimeTypes.length&&(x=bmN.plugins['Shockwave Flash']))bm.m=parseInt(x.description.replace(/([a-zA-Z]|\s)+/,''));
              else for(var f=3;f<20;f++)if(eval('new ActiveXObject("ShockwaveFlash.ShockwaveFlash.'+f+'")'))bm.m=f}catch(e){;}
              try{bm.y=bmN.javaEnabled()?1:0}catch(e){;}
            try{bmS=screen;bm.v^=bm.d=bmS.colorDepth||bmS.pixelDepth;bm.v^=bm.r=bmS.width}catch(e){;}
              r=bmD.referrer.slice(7);if(r&&r.split('/')[0]!=window.location.host){bm.f=escape(r);bm.v^=r.length}
              bm.v^=window.location.href.length;for(var x in bm) if(/^[ovstcnwmydrf]$/.test(x)) bs[i++]=x+bm[x];
              bmD.write('<sc'+'ript type="text/javascript" language="javascript" src="http://c.bigmir.net/?'+bs.join('&')+'"></sc'+'ript>');
              //-->
              </script>

              <noscript>
              <a href="http://www.bigmir.net/" target="_blank"><img src="http://c.bigmir.net/?v61256&s61256&t2" width="88" height="31" alt="bigmir)net TOP 100" title="bigmir)net TOP 100" border="0" /></a>
              </noscript>
              <!--bigmir)net TOP 100-->
            <!-- Счетчики /конец/ ------------------------------------------------------->
EOT;
    }
    echo <<<EOT

       </td>
      </tr>
        </table>

    </td><td class="rsh"></td></tr></table>
    <div id="ush"></div>
</body>
</html>
EOT;
?>
