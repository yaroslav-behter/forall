<script language="PHP">
#--------------------------------------------------------------------
# OKWM partners page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;

// ��������
$title = "����������� ������, �������� ������� ������ WebMoney, �������, �������, ����� WMZ WMR WME WMU";
$Keywords = "�������� Webmoney, ���� ������ wmz, ������ WMZ, ������� WMZ, wmz �� �������, WMZ �� ��������, ������ wm, WMZ, WME, ������� WebMoney, �����, ��������, ����������� ������";
$Description = "������� ����� ����� ��������� OKWM � Change-WM � ��������� 2%. ����������� ���������� � ���������� �������� ������� Change-WM.ru.";
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
       <h1>�����������</h1>
   </td>
   <td id="pbr">&nbsp;
     </td><td class="rsh"></td>
   </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="news">
    <p>
    <div align="center"><b>���� ��������.</b></div>
    </p>
    <table>
        <tr><td width="15"><a href="http://www.saxon.dp.ua/" target="new"><img src="$http/img/partners/saxon.bmp" width="88" height="31" border="0"alt="������ ������� ������ �� �������� ����� � �������. ������� �� 1 �.�. �� 2 ������! 70 ���� �� FOREX" /></a><br><br></td><td></td>
          <td>�������������� ������������� ������� �������������� ���������� �� ����� FOREX � CFD �����.</td></tr>
        <tr><td><a href="http://www.goldexe.com" target=_blank><img src="$http/img/partners/ge.gif" width=100 height=100 border=0 alt="Monitoring HYIP. goldexe.com" /></a><br><br></td><td></td>
          <td><br><br>�������������� ��������� ������-��������� � ����������.</td></tr>
        <tr><td><a href="http://www.rusbid.com" target=_blank><img src="$http/img/partners/rusbid.gif" width=100 height=35 border=0 alt="������� ���������. ������ ������, ��������, eBay ��������." /></a></td><td></td>
          <td>������� ���������. ������ ������, ��������, eBay ��������.<br><br></td></tr>
      <tr><td></td><td></td><td>�������� ����� � <a href="http://www.wmmoscow.com/" title="WMExpress" target="blank"><b><font color="green">������</font></b></a>.<br><br></td></tr>
      <tr><td><a href="http://www.nexus.ua" target="_blank"><img src="$http/img/partners/nexus.gif" alt="�������� �������." border=0 width=100 height=62 /></a><br><br></td><td></td>
          <td> Nexus&trade; - �������� �������. ������� ��� ���������� �������. �������� ������������ ������!<br><br></td></tr>
      <tr><td><img src="$http/img/partners/zapp.jpg" width=100 height=36 border=0 /></td><td></td><td><a href="http://zapp.ru/" target="blank"><b><font color="green">ZAPP.ru</font></b></a> - ���������� �������� ������� ������, ����� � �����������.<br><br></td></tr>
      <tr><td>
        <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="100" height="100" id="1" align="middle">
      <param name="allowScriptAccess" value="sameDomain" />
      <param name="movie" value="http://forexua.com/images/banners/_baner100_100.swf?link=http://www.forexua.com/" />
      <param name="quality" value="high" />
      <param name="bgcolor" value="#ffffff" />
      <embed src="http://forexua.com/images/banners/_baner100_100.swf?link=http://www.forexua.com/" quality="high" bgcolor="#ffffff" width="100" height="100" name="1" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
      </object><br><br></td>
      <td></td>
          <td>�������� ������ �������. ������ ��������-��������� �� ������ Forex � CFD</td></tr>
      <tr><td><a href="http://www.yandex-money.com.ua/" target="_blank" title="������.������ �������"><img src="http://www.yandex-money.com.ua/yandex-money-88x31.gif" width="88" height="31" alt="������.������ �������" border="0" /></a></td>
          <td></td>
          <td>������� � ������� ������.����� � ������� �� ������.<br><br></td></tr>
      <tr><td><a href="http://dpua.info/" target="_blank" alt="������� ���������������, �������������� ������������ ����"><img src="http://dpua.info/images/logo_100.gif" width="100" height="59" alt="������.������ �������" border="0" /></a></td>
          <td></td>
          <td>���������������� �������������� ������.<br><br></td></tr>
    </table>

      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>
