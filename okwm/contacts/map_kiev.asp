<script language="PHP">
#--------------------------------------------------------------------
# OKWM welcome page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = DOMAIN_HTTP;

    // SEO strings
    $title = GetSEO("09663af82a3150fc3b9b236e129c01f9");
    if ($title=="") $title = "���� ������� � �����, ����, ����� WebMoney WMZ WMR WME WMU �� �������� usd, ������, ����";
    $Description = GetSEO("8ee290a5607980131dd559ad9196d73e");
    if ($Description=="") $description = "�������� ����� OKWM � ����� � ����, �����, ����� WebMoney WMZ WMR WME WMU, Ukash, Pokerstars, Betfair �� ��������. ����� ������: ����� � 11-00 �� 19-00, �� �� � 12-00 �� 14-00.";
    $Keywords = GetSEO("3cc6b845dea327cb62d6a54c601d56bd");
    if ($Keywords=="") $keywords = "�������� � �����, �������� Webmoney, �������� WEBMONEY, ����������, �������, ������, WebMoney, webmoney, �������, WMZ, WMR, ���� ������ wmz, ������ WMZ, ������� WMZ, wmz �� �������";


// ��������
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
       <h1>�.����</h1>
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
          <img src="$http/img/map/map_kiev.jpg" border="0"><br>
          <small><a href="https://plus.google.com/u/0/b/111396714940308813799/111396714940308813799#111396714940308813799/about"
          target="_blank" style="color:#0000FF;text-align:left">����������� ����������� ����� Google</a></small><br /><br />

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


            <a href="$http/img/map/ph_kiev1.jpg" onclick="return GB_myShow('��.��������������� 65', this.href, 735, 555)">���� 1</a>
            <a href="$http/img/map/ph_kiev2.jpg" onclick="return GB_myShow('���� � ���� OKWM.com.ua, �.����', this.href, 555, 735)">���� 2</a>


          <p>
          �. <b>����, �������</b>, ��. ������� ������������� (���������������) �.65, 3� ����, ��.355.<br />
          ������� ����� &quot;�����������&quot;<br>
          ����� �� ����� �� ����� ������� ������� ������������� (� ������� �.����� �������), ���� ����������,<br />
          �� ������ ����������� (����������� ��.������� ������������� � ��.�������) ������ - ���� � ������ �� ������� ��.�������<br />
          �� ����� - 3 ���� (����� �� ����� ������ �� ��������).<br />
          ����������� - ������� � 10<sup><u>00</u></sup> �� 18<sup><u>00</u></sup>,<br>
          �������� ���: ������� � �����������.
          </p>
        </td>
        <td width=10%>&nbsp;</td>
       </tr>
      </table>

   </td><td class="rsh"></td></tr>
EOT;
HTMLTail();
</script>