<script language="PHP">
#--------------------------------------------------------------------
# OKWM partners page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;

// Контакты
$title = "Партнерские ссылки, выгодные условия обмена WebMoney, покупка, продажа, обмен WMZ WMR WME WMU";
$Keywords = "комиссия Webmoney, курс обмена wmz, купить WMZ, продать WMZ, wmz на доллары, WMZ на наличные, купить wm, WMZ, WME, продать WebMoney, обмен, обменник, электронная валюта";
$Description = "Быстрый обмен между сервисами OKWM и Change-WM с комиссией 2%. Партнерское соглашение с Московским обменным пунктом Change-WM.ru.";
HTMLHead ($title, $Keywords, $Description);
echo <<<EOT

   <tr><td></td><td id="phl"><img width="1" height="4" alt="" src="$http/img/0.gif" /></td>
       <td id="phr"><img width="210" height="1" alt="" src="$http/img/0.gif" /></td><td></td>
       <td rowspan="5" class="right_banners">
EOT;
    if (!isset($HTTP_SERVER_VARS['HTTPS'])) EchoBaners ();
    echo <<<EOT

   </td>
   </tr>
   <tr><td class="lsh"></td><td id="pbl">
       <h1>Партнерство</h1>
   </td>
   <td id="pbr">&nbsp;
     </td><td class="rsh"></td>
   </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="news">
    <p>
    <div align="center"><b>Наши партнеры.</b></div>
    </p>
    <table>
        <tr><td width="15"><a href="http://www.saxon.dp.ua/" target="new"><img src="$http/img/partners/saxon.bmp" width="88" height="31" border="0"alt="Лучшие условия работы на валютном рынке в Украине. Депозит от 1 у.е. от 2 пипсов! 70 книг по FOREX" /></a><br><br></td><td></td>
          <td>Предоставления качественного сервиса индивидуальным инвесторам на рынке FOREX и CFD акций.</td></tr>
        <tr><td><a href="http://www.goldexe.com" target=_blank><img src="$http/img/partners/ge.gif" width=100 height=100 border=0 alt="Monitoring HYIP. goldexe.com" /></a><br><br></td><td></td>
          <td><br><br>Информационная поддержка форекс-трейдеров и инвесторов.</td></tr>
        <tr><td><a href="http://www.rusbid.com" target=_blank><img src="$http/img/partners/rusbid.gif" width=100 height=35 border=0 alt="Покупки зарубежом. Онлайн сервис, доставка, eBay трэйдинг." /></a></td><td></td>
          <td>Покупки зарубежом. Онлайн сервис, доставка, eBay трэйдинг.<br><br></td></tr>
      <tr><td></td><td></td><td>Обменный пункт в <a href="http://www.wmmoscow.com/" title="WMExpress" target="blank"><b><font color="green">Москве</font></b></a>.<br><br></td></tr>
      <tr><td><a href="http://www.nexus.ua" target="_blank"><img src="$http/img/partners/nexus.gif" alt="Надежные оффшоры." border=0 width=100 height=62 /></a><br><br></td><td></td>
          <td> Nexus&trade; - Надежные оффшоры. Решения для серьезного бизнеса. Защитите заработанное сейчас!<br><br></td></tr>
      <tr><td><img src="$http/img/partners/zapp.jpg" width=100 height=36 border=0 /></td><td></td><td><a href="http://zapp.ru/" target="blank"><b><font color="green">ZAPP.ru</font></b></a> - уникальный Интернет магазин одежды, обуви и аксессуаров.<br><br></td></tr>
      <tr><td>
        <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="100" height="100" id="1" align="middle">
      <param name="allowScriptAccess" value="sameDomain" />
      <param name="movie" value="http://forexua.com/images/banners/_baner100_100.swf?link=http://www.forexua.com/" />
      <param name="quality" value="high" />
      <param name="bgcolor" value="#ffffff" />
      <embed src="http://forexua.com/images/banners/_baner100_100.swf?link=http://www.forexua.com/" quality="high" bgcolor="#ffffff" width="100" height="100" name="1" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
      </object><br><br></td>
      <td></td>
          <td>Компания ФОРЕКС УКРАИНА. Услуги интернет-трейдинга на рынках Forex и CFD</td></tr>
      <tr><td><a href="http://www.yandex-money.com.ua/" target="_blank" title="Яндекс.Деньги Украина"><img src="http://www.yandex-money.com.ua/yandex-money-88x31.gif" width="88" height="31" alt="Яндекс.Деньги Украина" border="0" /></a></td>
          <td></td>
          <td>Покупка и продажа Яндекс.Денег в Украине за гривны.<br><br></td></tr>
      <tr><td><a href="http://dpua.info/" target="_blank" alt="новости Днепропетровска, информационный региональный сайт"><img src="http://dpua.info/images/logo_100.gif" width="100" height="59" alt="Яндекс.Деньги Украина" border="0" /></a></td>
          <td></td>
          <td>Днепропетровский информационный портал.<br><br></td></tr>
    </table>

      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>
