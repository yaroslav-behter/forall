<script language="PHP">
#--------------------------------------------------------------------
# OKWM help page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
$https= DOMAIN_HTTPS;
// ��������
$title = "��� ��� �ϲ����������ʻ";
$Keywords = "����� Webmoney � ϲ�����������, ����� � ���������, �� �����, �������� �� ���� � �����, �����, ��������, ����������� ������";
$Description = "������� ������ WebMoney �� ��������� ���� � ����������, �������� ����� ����� �� ���� � ������ ���������.";
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
       <h1>��� &laquo;�� &laquo;����������&raquo;</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <p>
         <div align="center"><b>��������� ������� ������� OKWM.com.ua!</b></div>
      </p>
      <div id="help">
		<p>�� ���� ���������� ��� ����� ������ � ����� ��������� ������ WebMoney �� ����� � ����� ������-���������:
		��� &laquo;�� &laquo;����������&raquo;.    �� ��� ��
		</p>
		<p>�������� � ������� �������� ����� ����� ������ �������� �������� WebMoney (WMZ, WMR, WME, WMU). �� �� ������� ����������������
		� �� �������� � ���������� ������.�����, ���� �� ������ �� ������ ��� �������. ��� ������������� �������� ��� �����, ���������
		� ������ � ������� Betfair, PokerStars �� ������ ��������� �� ������ ������� ������ � ���������� �������, �� � ������� ��������.
		������������ ������, ��������� � ������, � ����������� ������� ������� ����������� ���������������. ��� ����� ������ ������
		������������ �������������� ����� ������ ��������.
		� ������ ������������ ������ �������� ����� ���������� �� ������� ����������� �� ������� �������� �������.</p>

        <p><u><i><b>��� &laquo;�� &laquo;����������&raquo;</b></i></u></p>
        <p>
        1. ���������� � ������������������ ����� �� ��������: <a href="http://maps.privatbank.ua/" target="_blank">http://maps.privatbank.ua/</a>.<br />
        2. ���������� � ��������� ������ <a href="http://privatbank.ua/html/5_4r.html" target="_blank">http://privatbank.ua/html/5_4r.html</a>.<br />
        3. ������ �� ������ �������� ������ <a href="http://privatbank.ua/info/index1.stm?fileName=5_4_10_5r.html" target="_blank">http://privatbank.ua/info/index1.stm?fileName=5_4_10_5r.html</a>.<br />
        4. ���������� � ���, ��� ������������ � ������24 <a href="http://privatbank.ua/html/5_8_1_2r.html" target="_blank">http://privatbank.ua/html/5_8_1_2r.html</a>.<br />
        5. ���������� ������ � ������� MobileBanking <a href="http://privatbank.ua/html/5_6_8r.html" target="_blank">http://privatbank.ua/html/5_6_8r.html</a>.<br />
        6. ������ ������ ����� <a href="http://privatbank.ua/html/3r.html" target="_blank">http://privatbank.ua/html/3r.html</a>.<br />
        </p>
        <p>������ � �������� ���������� ��������� ������:<br />
        <u>����� &quot;������&quot;</u><br />
        - ���������� �� 10 �����;<br />
        - ���������� ���������� �����;<br />
        - �������� ��������� 25 ��� / 5 USD.<br /><br />

        <u>������ �������� �����</u><br />
        - ������������������� ������������� ����� VISA Classic ��� MasterCard Standard;<br />
        - ���������� ���������� �����;<br />
        - �������� ��������� 150 ��� / 30 USD.<br />
        </p>

      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>