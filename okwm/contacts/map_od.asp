<script language="PHP">
#--------------------------------------------------------------------
# OKWM welcome page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;


    // SEO strings
    $title = GetSEO("462380fcc55b94878082554c2c44def2");
    if ($title=="") $title = "Одесса Украина – покупка, продажа, обмен WMZ WMR WME WMU на наличные, Ukash ваучеры, Betfair";
    $Description = GetSEO("e976242549f1c286b4fe6fcba0d921c0");
    if ($Description=="") $description = "Обменный пункт OKWM в Одессе – ввод, вывод, обмен WebMoney WMZ WMR WME WMU, Ukash, Pokerstars, Betfair на наличные. Режим работы: будни с 12-00 до 18-00, сб вс с 12-00 до 14-00.";
    $Keywords = GetSEO("7d0a98ec6df0275998f173cd0bc28515");
    if ($Keywords=="") $keywords = "обменник в Одессе, обменять Webmoney, обналичить, ОБМЕНЯТЬ WEBMONEY, вывести, ввести, WebMoney, webmoney, вебмани, WMZ, WMR, курс обмена wmz, купить WMZ, продать WMZ, wmz на доллары";



// Контакты
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
       <h1>г.Одесса</h1>
   </td>
   <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
   </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">

      <table cellpadding=0 cellspacing=0 width=100% border=0>
       <tr>
        <td width=10%>&nbsp;</td>
        <td width=80%>
           <br />
           <!--img src="$http/img/map/map_od.jpg" border="0"><br>
           <small><a href="https://plus.google.com/105135692245641571575#105135692245641571575/about" target="_blank" style="color:#0000FF;text-align:left">Просмотреть увеличенную карту Google</a></small><br /><br>

            <script type="text/javascript">
            var GB_ROOT_DIR = "$http/contacts/greybox/";
            GB_myShow = function(caption, url, /* optional */ height, width, callback_fn) {
              var options = {
                  caption: caption,
                  height: height || 500,
                  width: width || 500,
                  fullscreen: false,
                  show_loading: true,
                  callback_fn: callback_fn
              }
              var win = new GB_Window(options);
              return win.show(url);
            }
            </script>
            <script type="text/javascript" src="greybox/AJS.js"></script>
            <script type="text/javascript" src="greybox/AJS_fx.js"></script>
            <script type="text/javascript" src="greybox/gb_scripts.js"></script>
            <link href="greybox/gb_styles.css" rel="stylesheet" type="text/css" />


            <a href="$http/img/map/ph_od1.jpg" onclick="return GB_myShow('Вход во двор', this.href, 620, 820)">Фото 1</a>
            <a href="$http/img/map/ph_od2.jpg" onclick="return GB_myShow('Вход в офис OKWM.com.ua в Одессе', this.href, 660, 580)">Фото 2</a-->

           <p>
           г. <b>Одесса, Украина</b>, Вознесенский переулок, дом 2а, офис 10.<br>
           Понедельник - пятница с 12<sup><u>00</u></sup> до 18<sup><u>00</u></sup>,<br>
           выходные дни: суббота и воскресенье.
           </p>
        </td>
        <td width=10%>&nbsp;</td>
       </tr>
      </table>

   </td><td class="rsh"></td></tr>
EOT;
HTMLTail();
</script>