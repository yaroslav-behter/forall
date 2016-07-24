<script language="PHP">
#--------------------------------------------------------------------
# OKWM help page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;

// ��������
$title = "OKWM.com.ua � ������, �������, �������� WebMoney WMZ WMR WME WMU, Ukash, Pokerstars, Betfair";
$Keywords = "����, ��������������, ������, �������� Webmoney, ���� ������ wmz, ������ WMZ, ������� WMZ, wmz �� �������, WMZ, WME, ������� WebMoney, ��������";
$Description = "������� � ������ �������� WebMoney, Pokerstars, Ukash, Betfair � �����, ������, ���������������.";
HTMLHead ($title, $Keywords, $Description);
echo <<<EOT

	 <tr><td></td><td id="phl"><img width="1" height="4" alt="" src="$http/img/0.gif" /></td>
	     <td id="phr"><img width="210" height="4" alt="" src="$http/img/0.gif" /></td>
	     <td></td>
	 <td rowspan="5" class="right_banners">
EOT;
    if (!isset($HTTP_SERVER_VARS['HTTPS'])) EchoBaners ();
    echo <<<EOT

	 </td>
	 </tr>
	 <tr><td class="lsh"></td><td id="pbl">
       <h1>������� � ������</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
		<p>
		<div align="center"><b>��������� ������� ������� OKWM.com.ua!</b></div>
		</p>
		<p><b>��� ���� ���������� ��� �������� �����?</b><br>
		������ <a href="$http" title="�������� �����" target="_blank" >OKWM.com.ua</a>
		���������� ��� ������������� ������ ������ ��������� ������ �������
		<a href="http://webmoney.ru/rus/about/index.shtml" target="_blank">WebMoney Transfer</a> ����� ����� � �� �������� ��������
		� ���� ������� �������. ����� �� ������������� ������ �� �����/������ ������� � ����� ������
		<a href="http://www.betfair.com/" target="_blank">Betfair</a>. ����� �������� �� ���� � ������ ������� ����� ���������
		<a href="$http/help.asp">�����</a>.
		</p>
		<p><b>����� �������� �� ��������������?</b><br>
		��� ������ �������� � ����������� �������� �������� ������� ������� WebMoney Transfer
		<a href="http://www.megastock.ru/Resources.aspx?gid=19" target="_blank">MegaStock.ru</a>, �� �����
		<a href="http://wiki.webmoney.ru/wiki/list/����������">�������� ��������</a> � ��� ���������� � ���, ������� ���������� ������
		��������� ���������, ��������� � �������� � ���� ������ ������� WebMoney Transfer.
		</p>
		<p><b>��� ����� WebMoney?</b><br>
		����������� ��������� ������� <a href="http://webmoney.ru/rus/about/index.shtml target="_blank"">WebMoney Transfer</a> ������������
		���������� �������� online ����������� ��������� ������ WebMoney. ���������� ��������� ��������� ������ �������������� ��������������
		� ������� ���������� ��������� WebMoney Keeper.
		<a href="http://webmoney.ru/rus/about/index.shtml" target="_blank" title="�������� ������� WebMoney Transfer" target="_blank">��������� � ������� WebMoney.</a>
		</p>
		<p><b>��� ������������������ � ������� WebMoney?</b><br>
        ����� ������� ������� � ������� ��� ���������� ����� �� ����
        <a href="http://stat.webmoney.ru/" target="_blank" title="���� ������� WebMoney Transfer" target="_blank">WebMoney.ru</a>,
        ������ ��������� <a href="http://stat.webmoney.ru/" target="_blank" title="���� ������� WebMoney Transfer" target="_blank">�����������</a>,
        ������� ��������� WebMoney Keeper � ����������, ������ ����������� ������������.
		</p>
		<p><b>����� �� ������� ������� WebMoney � ����� �����������������?</b><br>
		���, �� ������ ���� ������������������ �� ����� ������� <a href="http://start.webmoney.ru/"  target="_blank">WebMoney.ru</a>,
		�.�. ����� �� ����������� ��������� �� �� �������������.
		</p>
		<p><b>��� ����� Betfair?</b><br>
		�������� <a href="http://www.betfair.com/" target="_blank">Betfair.com</a> �������������� ����� ������ online, �� �������,
		� ������� �� ������������ �������, ������ ����������� �������� ����� ��������. ��������� ������������ ���������� ����� ��������
		�������� OKWM � ��������� Betfair, ��� �������� ����� ��������� � �������� �������� ��������� � ����� ������� ��������� OKWM
		� ��������� 0% ��� ���������� ������������ <a href="$http/betfair.asp" target="_blank">������</a>.
		</p>
		<p><b>����� �� ���������������� �� ����� �����?</b><br>
		���� �� ������ �������� ��������� ����� WebMoney, �� ����������� �� �����. ���� �� ������ ��������������� �������� �� �����/������
		������� Betfair, �� ���������� ������ ����������� �� ���� <a href="$http/bf/" target="_blank">������</a>.
		</p>
		<p><b>���� �� � �������� ���� ����������� ������ �� ������ �� ����� �����?</b><br>
		��, ����� ����������� ����� WebMoney ����� ����� �������������� �� <a href="$http/help.asp#autoexchange" target="_blank">�������</a>
		������������� � ������������� ��� ������� ���������.
		</p>
		<p><b>��� �������������� ����� ����� � ����� ������������������?</b><br>
		���������� ������ �� <a href="$http/help.asp#cash" target="_blank">����</a> ���
		<a href="$http/help.asp#emoney" target="_blank">�����</a> ����������� ������ � ������������ ��������� ��������� ������. �������
		���������� ������ ����� ���������� <a href="$http/help.asp" target="_blank">�����</a>.
		</p>
		<p><b>���� �� � �������� � ��� � ���� � ����� ���������� ����������� ��� �����?</b><br>
		��, �� ������ ����� ������������ � ��������������� � ��� ������� ����������� ��������� ������� ��� ���������� ������
		(�������, ���, ��������� ������� � �.�.).
		</p>
		<p><b>������ ����������� � ������������ ����� ��� ������?</b><br>
		����������� ����� ������ ���������� ���������� 5 USD. ������������ ����� ������������ �������� ������� �� ������ ������,
		�� ������ �������� �� � �������������� ����� ����������� ������.
		</p>
		<p><b>����� ��� ����� ��� ���������� ������ (������ ������� ���������) ��� ���������� ������?</b><br>
		��� <a href="http://www.megastock.ru/Doc/exchange_agreement.aspx" target="_blank">���������� ��������� ������� WebMoney</a>
		� �������� ������� ��� �������������� �������������. ��������������� ���� ������ ���������� ��� ������������� ����� ��������
		� ����� ����� � �� ���������� ������� �����.
		</p>
		<p><b>��������� �� � ����� �������� ������ ������������� ������?</b><br>
		���� ����� ���������� ��������, �� ������ �������� ������������ ������ �� ������� ����� ��� �� ���������� ������ �� ��������������
		� ���������������. ��� ���� ������������� ����� ��������� �� ����� ����� �������� ��������������� ������ ����� ������������
		�������������, ����������� ��� �� ���� ����� ����������� ������.
		</p>
		<p><b>���� �� �� ����� ����� �� ���� ������, ���������� � ������� <a href="$http/help.asp" target="_blank">������</a> ��� ��������
		� <a href="$http/contacts.asp">���������������</a>:</b>
		<ul>
		<li>�� e-mail, WMID � ICQ � ������� ��� � 11-00 �� 19-00, � ������� � ����������� � 12-00 �� 14-00;</li>
		<li>�� ��������� � �������������.</li>
        <ul>
        </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>