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





    // SEO strings
    $title = GetSEO("4b5af7a8ddebd9f5755d50abed72b1ab");
    if ($title=="") $title = "������������������, ������, ��������� ����, ������� ������ ���������� (Pokerstars)";
    $Description = GetSEO("cdac824f1ce0b7f32b08f7c14be7ec61");
    if ($Description=="") $description = "�������� ����������� ��������� � ���������� �����-��� Pokerstars.com.";
    $Keywords = GetSEO("5db31f73edf5ae8c28364482ace86eac");
    if ($Keywords=="") $keywords = "����, ��������������, ������, ���������, Webmoney � �����, �������� ������, ������ wm, WMZ, WME, �������, �����, ��������, ����������� ������, ������, �����������, ������������ �������";


/*
    // SEO strings
    $title = GetSEO("");
    if ($title=="") $title = "";
    $Description = GetSEO("");
    if ($Description=="") $description = "";
    $Keywords = GetSEO("");
    if ($Keywords=="") $keywords = "";

*/






// ��������
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
       <h1>� Pokerstars</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
		<p>
		<div align="center"><b>����������� �������������� &bdquo;PokerStars&ldquo; � &bdquo;OKWM&ldquo;.</b></div>
		<br />
        <p>
        ��������� ������������ ���������� ���������� ����� OKWM � ���������� � ���� �����-�����
        <a href="http://www.pokerstars.com?source=psp12329" target="_blank">PokerStars.com</a>,
        ������� ��������������� ���������� ����������� ���������� �������� ����� ��������� � ���� ������ ��������
        � ����� ������ ��������� ������� Webmoney (WMZ,WMR,WMU). ������� ���������� ������� ������, ������� � ������ ��������
        �������� Webmoney (WMZ, WME, WMR, WMU), ������.�����, �������� Visa, Master, ������24.
        ������������ � ��������� ����������� ����� ����.
        </p>
        <p>
        <u>���������� �����:</u><br />
        - ��������� � ����� �� ������;<br />
        - ����� �������� � ��������� Webmoney (WMZ,WMR,WMU)<br />
        �����: �� $5000 � ����������� � ������� �����, ����� $5000 � � ������� 1 ������ ���.
        </p>
        <p><u>����� �������:</u><br />
        �������� �� ����� �� ����� ����������:<br />
        �� 1000 $ - 5%;<br />
		�� 1000$ �� 5000 $ - 4%;<br />
		�� 5000$ �� 10 000$ - 3.5%;<br />
		�� 10 000$ �� 25 000$ - 3%;<br />
		�� 25 000$ �� 50 000$ - 2.5%;<br />
		�� 50 000 - 2%.<br /><br />
        ���� ��������� �������� � ����� 48 ����� ����� ��������.<br />
        � ����� ��� ��������� ������� ���������� ������� ��� �����, ���� ��������, �����, ����� ����������.<br />
        ����� ������� �������� �� PokerStars, ���������� ���������� � ��������������� ������� (������ <a href="$http/contacts.asp">��������</a>)
        ��� ��������� ���������� �������� � ������ �������.
        </p>
        <p>���� � ��� ��� ����� �� PokerStars, ��������������� �� ������ ���� � �������������� �������� ������ �������.<br />
        <a href="http://www.pokerstars.com/ru/?source=psp12329" target="_blank">����������� �� PokerStars</a>
        </p>
		<p><b>������� ���������� � �������� &quot;PokerStars&quot;.</b></p>
		<p>
		<i>������������:</i> <u>PokerStars</u><br />
		<i>�������� ��� ������������:</i> ������ �����<br />
		<i>�������� ����:</i> ������ ���, ��������������<br />
		<i>������� ����:</i> <a href="http://www.pokerstars.com/ru/?source=psp12329" target="_blank">www.pokerstars.com</a><br /><br />
		PokerStars � ��� ����� ������� �����-��� � ����, ������� ���������� 30 ��������� ������������������ �������.
		�� ����������� ������� ����������� ������� ������, ��� ����� ������ ����. PokerStars, ������� �������� ��������-����������
		��� ���������� �������, ������������� ������ ����������� ����������� � ��������� ������� ������������ �  ���� ������ ������.
		������ ���� �� ����� �������� �������������� �������.<br /><br />
		PokerStars ���������� ���� �������� �������:<br />
		- 300 ���. ������� ������������ �������������� �� �����<br />
		- 65 ��� ������� ����������� � ����� �������<br /><br />
		PokerStars �������� ������������� ����� ���������� � ����� ��������� ����� �������� �������� � ��������� � ���������� ����
		�� ������ ������ (WCOOP), � ����� ��������� ����� �������� �� ������: European Poker Tour (<a href="http://www.ept.com/" target="_blank">www.ept.com</a>),
		PokerStars Caribbean Adventure, Latin American Poker Tour (<a href="http://www.lapt.com" target="_blank">www.lapt.com</a>),
		Asia Pacific Poker Tour (<a href="http://www.appt.com" target="_blank">www.appt.com</a>) � The World Cup of Poker.<br /><br />
		PokerStars � ������ ������ �������� ��� ������� �������������� Team PokerStars Pro, � ������� ������ �������� � ������������� ������
		�� ����� ����. ������� PokerStars Pro ��������� ��������� � ��������. �����-��� ���������� ������� ������ �������
		� ������������� ������������� �� ����� ����.
        </p>
        <p>�������� ������:<br />
        <a href="http://www.pokerstars.com/ru/?source=psp12329" target="_blank">����������� �� PokerStars</a><br />
        <a href="http://www.pokerstars.com/ru/poker/download/" target="_blank">������� ����� ��� ���� �� PokerStars</a><br />
        <a href="http://www.pokerstars.com/ru/poker/room/support/" target="_blank">������ ��������� �������� PokerStars</a><br />
        <a href="http://www.pokerstarsblog.com/ru/" target="_blank">��������� ���� PokerStars</a></p>

      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>