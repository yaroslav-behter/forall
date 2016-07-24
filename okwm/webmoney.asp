<script language="PHP">
#--------------------------------------------------------------------
# OKWM WHITH WEBMONEY page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2010.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = DOMAIN_HTTP;

    // SEO strings
    $title = GetSEO("c3c5d62cecbb014709481767d39a64e7");
    if ($title=="") $title = "���������, ������, �������� ( wmz, wmu, wmr, wme) � ������� | OKWM - �������� ���, ���, ���, ��� ��� ��������";
    $Description = GetSEO("017240a89bf5a7ccf697e220e268fdfc");
    if ($Description=="") $description = "������� � ������ �������� WebMoney WMZ WMR WMU WME, Ukash, Pokerstars, Betfair, �������� � �����, ������, ���������������";
    $Keywords = GetSEO("a5519620408ddfea7d6b2a43da73f4ad");
    if ($Keywords=="") $keywords = "Webmoney, ������� WebMoney, ����� webmoney, �������, ������ ������� WMZ, ����� WMZ, wmz �� �������, WMZ �� ��������, WMZ, WMR, WMU, WME, ��������, ����������� ������";


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
       <h1>OKWM � WebMoney</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
        <p><u><b>��� ������ ������������� �������� ��������� ������ �� ������ ��������� ������ WebMoney:</b></u><br />
        <ul>
        <li>�������������� ����� ��������� ������ ������� WebMoney Transfer, � ������: WMZ, WMR, WME, WMU.<br />
        ����� ����������� ����� WebMoney ����� ����� �������������� ������������� � ������������� �� ����� ��� ������� ���������.<br />
        <a href="$http/help.asp#autoexchange" target="_BLANK">��� ����������� <b>��������� ����������� �����</b></a></li>
        <li>���� � ����� ��������� ������ WebMoney: WMZ, WMR, WME, WMU.<br />
        ����� ����������� ����� �� �������� �������� � �������� �� ����������� �������������� �� ������ �� ����� ����� ���������
        ������� ����������� ��� �����.<br />
        <a href="$http/help.asp#cash" target="_BLANK">��� �������� ������ �� <b>������� WebMoney</b> �� ��� ������� (���� ������� � �������)</a><br />
        <a href="$http/help.asp#emoney" target="_BLANK">��� �������� ������ �� <b>����� WebMoney �� ��������</b> (����� ������� �� �������)</a></li>
        <li>�������������� ����� ��������� ������ WebMoney �� ������� Ukash � ��������. <a href="$http/ukash.asp" target="_BLANK">���������...</a></li>
        <li>����/����� ������� ����� WebMoney �� ����� ������ Betfair. <a href="$http/betfair.asp" target="_BLANK">���������...</a></li>
        <li>���������� ������ �� �������� ����� Pokerstars �� WebMoney. <a href="$http/pokerstars.asp" target="_BLANK">���������...</a></li>
        </ul>
        </p>
        <p><u><b>������ ��� �������� �������� �� ������� ���������� �������� �������� WebMoney</b><br /> � ������������ �
        <a href="https://www.megastock.ru/Doc/exchange_rules.aspx" target="_BLANK">���������� � ������� ������������� ������� WebMoney Transfer
        ��� �������� �������� � ����������� �������������</a> �� 15 ������ 2010�.</u>
        </p>
        <p>
        <ul>
        <li>�������/�������� �������� WebMoney ����� ����� ������ �������� <a href="https://passport.webmoney.ru/asp/WMCertify.asp" target="_BLANK">WM-���������</a>
        ����� ��� ������� ��������, ��� ������� ������� ���. �� ���� ������ � ��������� WebMoney (��� � ����� ����� ��������) � ������ �������
        �� ������ ������ ���������.</li>
        <li>��� WM-�������� ������ ���� �� ���� ����������� (���� � ��� �������� ���������� � ����� ������������� �� �����).
        ���������� �������� �������� ��������� ��������� ������� WebMoney Transfer ����� ����� ���������� ������ �� �����
        <a href="http://passport.webmoney.ru/" target="_BLANK">������ ����������</a>.</li>
        <li>���� �� ������ ������� �������� �� �������, ��� WMID ������ ���� ��������������� �� ����� ��� 7 ����� �����.</li>
        </ul>
        </p>
        <p>
        <b>������� ���������� � ������� WebMoney Transfer</b><br /><br />
        <u>WebMoney Transfer</u> � ������� ������������ ��������-���������, ������� � 1998 ����. ��������� ������� WebMoney
        ������������ ���������� �������� online ����������� ��������� ������ WebMoney.<br /><br />
        ������� ���� ������� � <a href="http://www.webmoney.ru/" target="_BLANK">www.webmoney.ru</a>, ���������� ���� � <a href="http://www.webmoney.ua/" target="_BLANK">www.webmoney.ua</a>.<br />
        �������� WM Transfer Ltd � �������� � ������������� ��������� ������� WebMoney Transfer.<br />
        ������� ������������ ��������� ������� ��������� ��� ��������������� ����� (�. ������).<br /><br />
        ��� ������� WebMoney �� ���������� ������ � ���������� � ��������� �������� � ������������ �������� � ������������
        ����� ��������� ������� �����, �������� � ����� ����� ������� ����. ���������� WebMoney Transfer ����������� � ������
        ����������� ���������� ������������, ������������� � �������� ���������� ����������� ����� ��������. ��� ���������� � �������
        �������� ����������� � ������������, ��� ����������� ��������������� ������ � �������.<br /><br />
        ������� ������ ������� �������� �����.<br />
        ����� ����� ���������� ������� WebMoney Transfer, ���������� ���������� �� ����� ������������ ����������, ��� ��� ��������� ��������
        <a href="http://www.webmoney.ru/rus/about/demo/index.shtml" target="_BLANK">���������� ���������</a>, ������������������ � ������� � �������
        �� �������, ������� ��� ���� WM-������������� � ���������� ����� ������������. ������� ����������� ����� ���������������
        ���� ������������ ������ � ������������� �� ������������� ����� ������ <a href="https://passport.webmoney.ru/asp/pasMain.asp" target="_BLANK">WM-����������</a>.
        ������ ������������ ����� <a href="https://passport.webmoney.ru/asp/wmcertify.asp" target="_BLANK">WM-��������</a> � �������� �������������,
        ������������ �� ��������� ��������������� �� ������������ ������.<br /><br />
        ������� ������������ ��������� ����� ��������� ������ WM, ������������ ���������� �������� � ���������� �� ���������������
        ����������� ���������.
        </p>
        <p>
        <u>��� �������� ������ �������� � �������� ������ ���������, � ������:</u>
        <ul>
        <li>WMZ � ���������� �������� ��� (������� ���� Z);</li>
        <li>WMU � ���������� ���������� ������ (������� ���� U);</li>
        <li>WMR � ���������� ���������� ������ (������� ���� R);</li>
        <li>WME � ���������� ���� (������� ���� �).</li>
        </ul>
        </p>
        <p>
        ������� ��������� ������ ������������� ���� ������������ ������ - �����������, ����������� ������������ �������, ���������������
        ���������� ������ �� ���������� ������������� �����, �������������� ���������� �������� �������� � ������������� ������
        ��������� ������ �������������� ���� � ������������ � �������� ������ �����������.
        </p>
        <p>
        ��� ������������ ������� ������� � ������ ����������� � ������� ������������� �������������� �������, ����������� ����������
        <a href="http://www.webmoney.ru/rus/services/security.shtml" target="_BLANK">������������ ����������� ������� ������������ ��������</a>,
        <a href="http://www.webmoney.ru/rus/services/budget.shtml" target="_BLANK">���������������� �������</a>, ����� ����, ���������
        <a href="http://www.exchanger.ru/asp/about.asp">����� ��������� ��������� �������</a>, ���������� ��������
        <a href="http://geo.webmoney.ru/users/" target="_BLANK">��������� � ����� �������</a>, �� ������ �� ������ ����������. ����� �������� ������
        � �������� WebMoney ����� <a href="http://www.webmoney.ru/rus/services/index.shtml" target="_BLANK">�����</a>.<br /><br />
        ������������ �������� � ��������� �������� WebMoney Transfer �� ������ �� �����
        <a href="http://webmoney.ru/rus/about/index.shtml" target="_BLANK">www.webmoney.ru</a>.
        </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>