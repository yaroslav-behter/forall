<script language="PHP">
#--------------------------------------------------------------------
# OKWM welcome page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = DOMAIN_HTTP ;

    // SEO strings
    $title = GetSEO("8223f1ec57eb72cb28755abdf349b42a");
    if ($title=="") $title = "Днепропетровск Украина – купить, продать, обменять WebMoney WMZ WMR WME WMU на наличные в Днепре";
    $Description = GetSEO("a80263ceca723d992ef820db9e00dddc");
    if ($Description=="") $description = "Обменный пункт OKWM в Днепропетровске – ввод, вывод, обмен WebMoney WMZ WMR WME WMU, Ukash, Pokerstars, Betfair на наличные. Режим работы: будни с 12-00 до 18-00, сб вс с 12-00 до 14-00.";
    $Keywords = GetSEO("f7b454a41ef4c5f12768436a39783687");
    if ($Keywords=="") $keywords = "обменник в Днепропетровске, обменять Webmoney, обналичить, вывести, ввести, WebMoney, webmoney, вебмани, WMZ, WMR, курс обмена wmz, купить WMZ, продать WMZ, wmz на доллары";


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
       <h1>г.Днепропетровск</h1>
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
          <!--img src="$http/img/map/map_dp.jpg" border="0"><br>
          <small><a href="https://plus.google.com/114722566725710499236#114722566725710499236/about" target="_blank" style="color:#0000FF;text-align:left">Просмотреть увеличенную карту Google</a></small><br /><br>
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
            <link href="greybox/gb_styles.css" rel="stylesheet" type="text/css" /-->


            <!--a href="$http/img/map/ph_dp1.jpg" onclick="return GB_myShow('Здание офиса OKWM.com.ua в Днепропетровске', this.href, 640, 550)">Фото 1</a>
            <a href="$http/img/map/ph_dp2.jpg" onclick="return GB_myShow('Вход в офис OKWM.com.ua в Днепропетровске', this.href, 615, 515)">Фото 2</a-->

          <p>
           г. <b>Днепропетровск, Украина</b>, ул. Владимира Мономаха (Московская), 7 2й этаж, комн. 215.<br>
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