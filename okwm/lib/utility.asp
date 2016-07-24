<?php

#--------------------------------------------------------------------
# lib/utility.asp
# Library file with some useful utilities.
# Copyright by Oleg Semyonov (os@altavista.net), (c) 2000-2001.
#--------------------------------------------------------------------
# Interface functions:
#   SetUserVariable($name, $vals, $save);
#   HTMLHead($title, $headers);
#   HTMLError($msg);
#   HTMLTail();
#   Logger($err, $msg, $file, $line);
#   SendMail($from, $subject, $msg);
#   FormatDate($tm, $sp);
#   FormatTime($tm, $sp);
#   FormatDateTime($tm, $sp);
#   FormatTimeS2HMS($ss, $hours);
#--------------------------------------------------------------------
# Requires lib/config.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/curstr.asp");


//
// Tries to get value of user variable $name from the following sources:
// cookie, HTTP GET variable, HTTP POST variable $name. Latest choices
// override the previous ones. Finally, it tries to save the value as
// cookie if $save is true.
//
function SetUserVariable(
    $name,          // HTTP GET/POST/SESSION/cookie variable name
    $vals,          // array with legal variable values
    $save) {        // try to save as cookie?

    global $HTTP_COOKIE_VARS, $HTTP_GET_VARS, $HTTP_POST_VARS;

    // if cookie is set then use it
    if (isset($HTTP_COOKIE_VARS[$name])) $val = $HTTP_COOKIE_VARS[$name];

    // if HTTP GET variable exists then it overrides the cookie
    if (isset($HTTP_GET_VARS[$name])) $val = $HTTP_GET_VARS[$name];

    // if HTTP POST variable exists then it overrides the HTTP GET
    if (isset($HTTP_POST_VARS[$name])) $val = $HTTP_POST_VARS[$name];

    // if value is not known then set default
    if (!isset($val)) $val = current($vals);

    // set cookie if requested
    if ($save && !headers_sent())
        setcookie($name, $val, time()+COOKIE_LIFETIME, COOKIE_PATH, COOKIE_DOMAIN);

    // return selected value
    return $val;
}


//
// Creates full-blown HTML document head with $title and $class
//
function HTMLHead($title,
                  $Keywords="ОБМЕНЯТЬ Webmoney, обменник в Киеве, ОБНАЛИЧИТЬ WEBMONEY, WMZ, WMR, вебмани, курс обмена wmz, купить wmz, обналичить wmz, оплатить WMZ",
                  $Description="Обменный пункт Webmoney, обменять электронные деньги WMZ, WMR, WME на наличные, купить WMZ, Работаем ежедневно с 10.00 до 18.00 без выходных.Обменный пункт Webmoney, обменять электронные деньги WMZ, WMR, WME на наличные, купить WMZ, Работаем ежедневно с 10.00 до 18.00 без выходных.") {
    // $title - название страницы Главная|Купить|Продать|...
    global $HTTP_SERVER_VARS;
    $http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
    $WMid = WM_ID;
    $str = GetCurrStr();
    $comStr = GetComCurrStr();
    $turday = date ("d.m.y");
    if ((ereg ("MSIE 5.0" ,$HTTP_SERVER_VARS{'HTTP_USER_AGENT'}))||
        (ereg ("MSIE 5.5" ,$HTTP_SERVER_VARS{'HTTP_USER_AGENT'}))||
        (ereg ("MSIE 7" ,$HTTP_SERVER_VARS{'HTTP_USER_AGENT'}))) {
      // для IE 5.0 файл таблицы стилей другой
      $CSS = "main50";
    } else {
      $CSS = "main";
    }

    echo <<<EOT
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang="ru">
<head>
  <title>$title</title>
  <meta content="$Keywords" name="keywords" />
  <meta content="$Description" name="description" />
  <meta http-equiv="Content-type" content="text/html;charset=windows-1251" />
  <style type="text/css" media="screen">@import URL($http/styles/$CSS.css);</style>
  <link rel="stylesheet" type="text/css" href="$http/styles/$CSS.css" />
  <link rel="SHORTCUT ICON" href="$http/img/favicon.ico">
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
 <table align="left" width="90%" height="100%" cellspacing="0">
 <tr><td width="3" class="lsh"></td>
     <td width="67%" bgcolor="white" style="min-width:500px;"><img width="500" height="1" alt="" src="$http/img/0.gif" /></td>
     <td width="33%" bgcolor="white" style="min-width:250px;"><img width="250" height="1" src="$http/img/0.gif" alt="" /></td>
     <td width="3" class="rsh"></td>
     <td rowspan="4" width="150"><img width="150" height="1" src="$http/img/0.gif" /></td>
 </tr>
 <tr><td class="lsh"></td><td colspan="2" id="header">
    <div id="htop">
       <a id="tomain" title="перейти на главную" href="/"><h1>OKWM - обмен титульных знаков. WebМoney (WMZ, WME, WMR, WMU), E-gold, Яндекс-деньги, Территория</h1></a>
     <div id="sertif">
      <a href="http://passport.webmoney.ru/asp/certview.asp?wmid=$WMid" target=_blank><img src="/img/sert1.gif" title="Здесь находится аттестат нашего WMid $WMid" alt="продать webmoney, купить Webmoney"/></a>
     </div>
     <script language="Javascript">
			function show_menu(id, event, from) {
			    var d = document.getElementById(id);
			    if (d.style.visibility != "visible" && from) {
				    d.style.top = event.clientY+document.body.scrollTop-2+'px';
				    d.style.left = event.clientX+document.body.scrollLeft-25+'px';
				}
			    d.style.visibility="visible";
			}

			function hide_menu(id) {
			    var d = document.getElementById(id);
			    d.style.visibility="hidden";
			}

           var kurs_arr = new Array (
EOT;
    for ($i=0; $i < count($str); $i++) { echo "'",$str[$i],"',"; }
    $max_c = count($str)-1;
    echo <<<EOT
           '');
           var com_kurs_arr = new Array (
EOT;
    for ($i=0; $i < count($comStr); $i++) { echo "'",$comStr[$i],"',"; }
    $max_cc = count($comStr)-1;
    echo <<<EOT
           '');
           var c=1;
           var max_c = $max_c;
           var cc=1;
           var max_cc = $max_cc;
       function delay () {
              kurs_obj = document.getElementById? document.getElementById("kurs") : document.all.kurs;
              kurs_obj.innerHTML = 'Курс <a href="http://www.bank.gov.ua" target="_blank" title="Сайт Национального Банка Украины">НБУ</a> на $turday<br /><b>'+kurs_arr[c]+'</b>';
              comKurs_obj = document.getElementById? document.getElementById("comKurs") : document.all.comKurs;
              comKurs_obj.innerHTML = 'Коммерческий курс<br />'+com_kurs_arr[cc];
              if (c>=max_c) c = 0; else c++;
              if (cc>=max_cc) cc = 0; else cc++;
              top.setTimeout("delay();",5000);
         }
       top.setTimeout("delay();",5000);
     </script>
       <div id="kurs">
      <b>${str[0]}</b><br />
          курс <a href="http://www.bank.gov.ua" target="_blank" title="Сайт Национального Банка Украины">НБУ</a> на $turday
       </div>
       <div id="comKurs">
          Коммерческий курс<br />
      ${comStr[0]}
       </div>
     </div>
   </td><td class="rsh"></td></tr>
   <tr><td colspan="2" id="hbl"><img width="1" height="13" alt="" src="$http/img/0.gif" /></td>
       <td colspan="2" width="210" id="hbr"><img width="210" height="1" alt="" src="$http/img/0.gif" /></td>
   </tr>
   <tr><td colspan="4" id="nav">
     <ul id="cities">
     <li><a href="$http/">&lt;&lt;НА ГЛАВНУЮ</a>&nbsp;&nbsp;</li>
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
     <div id="service_menu" onMouseOver="show_menu('service_menu',event)" onMouseOut="hide_menu('service_menu')">
     <ul id="service_menu_items">
      <!--li><a href="$http/att.php">АТТЕСТАТЫ</a></li-->
      <li><a href="$http/tarifs.asp">ТАРИФЫ</a></li>
      <li><a href="$http/betfair.asp">BETFAIR</a></li>
      <li><a href="$http/pokerstars.asp">POKERSTARS</a></li>
     </ul>
     </div>
   </td></tr>

EOT;

}

function HTMLAfteHead($title="") {    global $HTTP_SERVER_VARS;
    $http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
  echo <<<EOT   <tr>
       <td></td>
       <td id="phl"><img width="1" height="4" alt="" src="$http/img/0.gif" /></td>
       <td id="phr"><img width="210" height="4" alt="" src="$http/img/0.gif" /></td>
       <td></td>
       <td rowspan="5" class="right_banners">

EOT;
    if (!isset($HTTP_SERVER_VARS['HTTPS'])) EchoBaners ();
    echo <<<EOT
       </td>
   </tr>
   <tr><td class="lsh"></td><td id="pbl">
       <h1>$title</h1>
   </td>
   <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
   </tr>
     <tr height="200"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
EOT;
}

function HTMLAfteHead_noBanner($title="") {
    global $HTTP_SERVER_VARS;
    $http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
  echo <<<EOT
   <tr>
       <td></td>
       <td id="phl"><img width="1" height="4" alt="" src="$http/img/0.gif" /></td>
       <td id="phr"><img width="210" height="4" alt="" src="$http/img/0.gif" /></td>
       <td></td>
       <td rowspan="5" class="right_banners">
       </td>
   </tr>
   <tr><td class="lsh"></td><td id="pbl">
       <h1>$title</h1>
   </td>
   <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
   </tr>
     <tr height="200"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
EOT;
}

function EchoBaners() {  global $HTTP_SERVER_VARS;
  $http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
//          <li> <a href="https://www.allmoney.com.ua/sys" target="_blank"><img src="$http/img/banners/allmoney.gif" title="Оплата более 1000 поставщиков услуг - интернет, телефидение, мобильная связь!"/></a></li>
//          <!--script src="$http/js/snow.js" type="text/javascript"></script-->
//          <li> <a href="http://payallmoney.com.ua/listservice.php?grp=100012" target="_blank"><img src="/img/banners/zkhwm.gif" style="border-width: 0px;" title="Оплата коммунальных услуг г.Запорожье."></a></li>
//          <li> <a href="http://payallmoney.com.ua/listservice.php?grp=100002&provider=5363" target="_blank"><img src="/img/banners/100x100_MTS.png" style="border-width: 0px;" title="Пополнение мобильного оператора МТС"></a></li>
//          <li> <a href="http://payallmoney.com.ua/listservice.php?grp=100002&provider=5362" target="_blank"><img src="/img/banners/100x100_KS.png" style="border-width: 0px;" title="Пополнение мобильного оператора Киевстар"></a></li>
//          <li> <a href="http://payallmoney.com.ua/listservice.php?grp=100002&provider=5361" target="_blank"><img src="/img/banners/100x100_life.png" style="border-width: 0px;" title="Пополнение мобильного оператора Life:)"></a></li>
//          <li> <a href="http://www.telefon.net.ua/" target="_blank"><img src="/img/banners/telefon_100_150.gif" style="border-width: 0px;" title="Пополнение счета телефона за Webmoney"></a></li>
//          <li> <a href="http://www.okwm.com.ua/ukash.asp" target="_blank"><img src="/img/banners/100x100_U_KASH.gif" style="border-width: 0px;" title="Наши соглашения с Ukash"></a></li>
  echo <<<EOT

    <ul>
          <li> <a href="http://www.okwm.com.ua/bf" target="_blank"><img src="/img/banners/100x100_BETFAIR.gif" style="border-width: 0px;" title="Регистрация на Betfair.com"></a></li>
          <li> <a href="http://www.okwm.com.ua/pokerstars.asp" target="_blank"><img src="/img/banners/100x100_POKER_STARS.gif" style="border-width: 0px;" title="Наши соглашения с Pokerstars"></a></li>
          <li> <a href="http://www.money2rent.net/" target="_blank"><img src="/img/banners/money2rent.gif" style="border-width: 0px;" title="Кредиты Webmoney"></a></li>
    </ul>
EOT;
//          <li> <a href="http://www.okwm.com.ua/att.php" target="_blank"><img src="/img/banners/attwm.gif" style="border-width: 0px;" title="Получить персональный аттестат Webmoney"></a></li>
//          <li> <a href="http://www.okwm.com.ua/betfair.asp" target="_blank"><img src="/img/banners/100x100_BETFAIR_02.gif" style="border-width: 0px;" title="Пополнение счетов Betfair наличными"></a></li>
//          <li> <a href="http://www.okwm.com.ua/ukash.asp" target="_blank"><img src="/img/banners/100x100_U_KASH.gif" style="border-width: 0px;" title="Что такое Ukash?"></a></li>
//          <li> <a href="http://www.okwm.com.ua/webmoney.asp" target="_blank"><img src="/img/banners/100x100_WEB_MONEY.gif" style="border-width: 0px;" title="Мы принимаем Webmoney"></a></li>
//          <li> <a href="http://www.change-wm.ru/" target="_blank"><img src="$http/img/banners/ru_100x100.jpg" alt="WEBMONEY IN RUSSIA" border=0 width=100 height=100 /></a></li>
//          <li> <b>Обмен</b><br /><a href="http://www.web-money.co.uk/" target="_blank">Webmoney на MoneyBookers</a><br />Спрашивайте у администраторов.</li>

}


function HTMLAfteBody() {  echo <<<EOT
      </div>
   </td><td class="rsh"></td></tr>
EOT;
}
//
// Prints error message
//
function HTMLError($msg) {
    if (!empty($msg)) {
       echo <<<EOT

<p class="error">
$msg
</p>

EOT;
    }
}


//
// Finishes HTML document
//
function HTMLTail() {
    global $HTTP_SERVER_VARS;
    $http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
    $WMid = WM_ID;
    echo <<<EOT

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
              <!--WebMoney TOP--><script language="JavaScript"><!--
              document.write('<a href="http://top.owebmoney.ru" target=_blank>'+'<img src="http://top.owebmoney.ru/counter.php?site_id=1085&from='+escape(document.referrer)+'&host='+location.hostname+'&rand='+Math.random()+'" alt="WebMoney TOP" '+'border=0 width=88 height=31></a>')//--></script>
              <noscript><a href="http://top.owebmoney.ru" target=_blank>
              <img src="http://top.owebmoney.ru/counter.php?site_id=1085"
              width=88 height=31 alt="WebMoney TOP" border=0></a></noscript>
              <!--/WebMoney TOP-->
              <!-- SpyLOG -->
              <script src="http://tools.spylog.ru/counter2.2.js" type="text/javascript" id="spylog_code" counter="679936" ></script>
              <noscript>
              <a href="http://u6799.36.spylog.com/cnt?cid=679936&f=3&p=0" target="_blank">
              <img src="http://u6799.36.spylog.com/cnt?cid=679936&p=0&f=4" alt='SpyLOG' border='0' width=88 height=31 ></a>
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
  </div>
</body>
</html>
EOT;
}

//
// Return string from SEO-table
//
function GetSEO($code) {    $query = "select value from seo_strings where md5='$code'";
    OpenSQL($query, $rows, $res);
    if ($rows==1) {        GetFieldValue ($res, $row, "value", $str, $IsNull);
        return $str;
    }    return "";
}

//
// Logs error message somewhere
//
function Logger($err, $msg, $file = '', $line = 0) {
    global $HTTP_SERVER_VARS;
    $remote = $HTTP_SERVER_VARS['REMOTE_ADDR'];
    $where = $file ? "(at $file:$line)" : '';
    $when = date("M d H:i:s");
    error_log("[client $remote] $err $msg $where", 0);
    // error_log("$when [client $remote] $err $msg $where\n", 3, ERROR_DESTINATION);
}

//
// Send message to administrator mail box
//
function SendMail ($from, $subject, $msg, $to="") {
    global $HTTP_SERVER_VARS;
    $c_msg  = convert_cyr_string ($msg, 'w', 'k');
    $c_subj = convert_cyr_string ($subject,'w','k');
    if ($to=="") {$to = $HTTP_SERVER_VARS['SERVER_ADMIN']; }
    $success = @mail($to, "=?koi8-r?B?".base64_encode($c_subj)."?=",
                   chunk_split(base64_encode($c_msg)),
                   "From: ".$from."\nMIME-Version: 1.0\nContent-Type: text/plain; ".
                   "charset=koi8-r\nContent-Transfer-Encoding: base64\nX-Mailer: PHP/".
                   phpversion()."\n","-f".$from);
    return $success;
}

//
// Send message to administrator mobil phone
//
function SendSMS ($txt)
{
  // $txt <= 70 char
  $phone = "380676348081@sms.kyivstar.net";
  $subj = convert_cyr_string ("AM",'w','k');
  $txt = convert_cyr_string ($txt,'w','k');
  $success = @mail($phone, "=?koi8-r?B?AM?=", chunk_split($txt),
                   'From: admin@okwm.com.ua'."\r\n".
                   'MIME-Version: 1.0'."\r\n".
                   'Content-Type: text/plain; charset="koi8-r"'."\r\n".
                   'X-Mailer: PHP/'.phpversion()."\r\n");
  return $success;
}

//
// Formats date for HTML output
//
function FormatDate($tm, $sp = 0) {
    return (ereg("([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})", $tm, $x)) ?
        sprintf("%02d.%02d.%02d", $x[3], $x[2], $x[1] % 100) :
            ($sp ? "&nbsp;" : "??.??.??");
}


//
// Formats time for HTML output
//
function FormatTime($tm, $sp = 0) {
    return (ereg("([0-9]{2}):([0-9]{1,2}):([0-9]{1,2})", $tm, $x)) ?
        sprintf("%02d:%02d:%02d", $x[1], $x[2], $x[3]) :
            ($sp ? "&nbsp;" : "??:??:??");
}


//
// Formats date and time for HTML output
//
function FormatDateTime($tm, $sp = 0) {
    return (empty($tm) && $sp) ?
        "&nbsp;" : FormatDate($tm)."&nbsp;".FormatTime($tm);
}


//
// Formats time period in seconds as HH:MM:SS
//
function FormatTimeS2HMS($ss, $hours = 0) {
    $hh = floor($ss / 3600); $ss -= $hh * 3600;
    $mm = floor($ss / 60);   $ss -= $mm * 60;
    return (($hh > 0) || $hours) ?
        sprintf("%02d:%02d:%02d", $hh, $mm, $ss) :
        sprintf("%02d:%02d", $mm, $ss);
}

// Evaluation Hash
function EvalHash ($str) {
   $s = APASSPHRASE;
   $Sign = strtoupper (md5 (APASSPHRASE));
   $str = str_replace (":::::", ":$Sign:", $str);
   $hash = strtoupper (md5 ($str));
   return $hash;
}

// Verify Hash
function HashOk ($str, $v2_hash) {
   $Sign = strtoupper (md5 (APASSPHRASE));
   $str = str_replace ("::::::", ":$Sign:", $str);
   $hash = strtoupper (md5 ($str));
   return ($hash==$v2_hash);
}

function FormYMoney ($PaymentID, $InSum, $title, $ContractID) {
   $title = base64_encode ($title);
   // кодируем данные
   $key = EvalHash ("$PaymentID::");
   /*if (getenv('REMOTE_ADDR')!="93.72.19.17") {       echo <<<EOT
       Прием платежей Яндекс.Денег находится в разработке. Запуск сервиса в ближайшее время.
EOT;
   } else {
   }*/
	$successURL = DOMAIN_HTTP."/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::");
	$failURL = DOMAIN_HTTP;
echo <<<EOT
<form method="POST" action="https://money.yandex.ru/eshop.xml">
	<input type="hidden" name="scid" value="5790">
	<input type="hidden" name="shopID" value="13395">
	<input type="hidden" name="customerNumber" value="$PaymentID. За электронные ваучеры.">
	<input type="hidden" name="orderNumber" value="$ContractID">
	<input type="hidden" name="sum" value="$InSum">
	<input type="hidden" name="shopSuccessURL" value="$successURL">
	<input type="hidden" name="shopFailURL" value="$failURL">

	<input type="hidden" name="ServiceID" value="okwm">
	<input type="hidden" name="PaymentID" value="$PaymentID">
	<input type="hidden" name="ContractID" value="$ContractID">
	<input type="hidden" name="Key" value="$key">
	<input type="hidden" name="TITLE" value="$title">
	<input type="submit" name = "invoice" value = "Оплатить ($InSum Яндекс.Денег)">
</form>
<br>
<!-- for html-ref -->

EOT;
}

//
// Form for Ukash Redemption Voucher
function FormUKASH ($PaymentID, $InSum, $title, $ContractID) {
   $title = base64_encode ($title);
   // кодируем данные
   $key = EvalHash ("$PaymentID::");
echo <<<EOT
<form name="UkashRedeem" method="POST" action="">

<input type=hidden name="PaymentID" value="$PaymentID">
<input type=hidden name="ContractID" value="$ContractID">
<input type=hidden name="Key" value="$key">
<input type=hidden name="TITLE" value="$title">
<input type=submit name = "invoice" value = "Погасить ваучер Ukash ($InSum EUR)">
</form>
EOT;
}

//
// Form for Webmoney Merchant
//
function FormWMT ($PaymentID, $InSum, $inmoney, $title, $ContractID, $descr="") {
   $title = base64_encode ($title);
   $https = DOMAIN_HTTPS;
   switch ($inmoney) {
    case "WMZ": $PAYEE_PURSE = WM_Z; break;
    case "WME": $PAYEE_PURSE = WM_E; break;
    case "WMR": $PAYEE_PURSE = WM_R; break;
    case "WMU": $PAYEE_PURSE = WM_U; break;
   }

   // кодируем данные
   $key = EvalHash ("$PaymentID::");

echo <<<EOT
<div align="center">
<form id="pay_wmt" name="pay_wmt" method="post" action="https://merchant.webmoney.ru/lmi/payment.asp">
<input type="hidden" name="LMI_PAYEE_PURSE" value="$PAYEE_PURSE"/>
<input type="hidden" name="LMI_PAYMENT_NO" value="$ContractID"/>
<input type="hidden" name="LMI_PAYMENT_AMOUNT" value="$InSum"/>
<input type="hidden" name="LMI_PAYMENT_DESC" value="$descr"/>
<input type="hidden" name="PAYMENTID" value="$PaymentID">
<input type="hidden" name="KEY" value="$key">
<input type="hidden" name="TITLE" value="$title">
<br>
<input type="submit" name="PAYMENT_WMT" value="Оплатить $InSum $inmoney">
</div></form>

EOT;
}

?>