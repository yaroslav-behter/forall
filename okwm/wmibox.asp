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
    /*$title = GetSEO("4b5af7a8ddebd9f5755d50abed72b1ab");
    if ($title=="") $title = "������������������, ������, ��������� ����, ������� ������ ���������� (Pokerstars)";
    $Description = GetSEO("cdac824f1ce0b7f32b08f7c14be7ec61");
    if ($Description=="") $description = "�������� ����������� ��������� � ���������� �����-��� Pokerstars.com.";
    $Keywords = GetSEO("5db31f73edf5ae8c28364482ace86eac");
    if ($Keywords=="") $keywords = "����, ��������������, ������, ���������, Webmoney � �����, �������� ������, ������ wm, WMZ, WME, �������, �����, ��������, ����������� ������, ������, �����������, ������������ �������";
    */


    // SEO strings
    $title = GetSEO("");
    if ($title=="") $title = "";
    $Description = GetSEO("");
    if ($Description=="") $description = "";
    $Keywords = GetSEO("");
    if ($Keywords=="") $keywords = "";








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
       <h1>����������� WMZ �������� WebMoney �� ����������</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
		<div align="center"><b>����������� WMZ �������� WebMoney �� ����������.</b></div>
		<br />

		<p>
			������� �� ���������� ������� � ���� ���������� <a href="https://bnk24.com.ua/map" target="_blank">���
			&bdquo;���� 24 ������������ ������&ldquo;</a> ��������� ����������� ��������� WMZ-��������
			����� ������� WMZ �� �������� WebMoney ����� �� ��������� - �������������.<br /><br />

	        �� ����������� ���� �������� ���� ����� ������� ������������ ������ �������� ��� ��������� �������������.
	        ������������ ���� ��� &bdquo;���� 24 �������� � ���� ����� 4500 ��������� �� ������ ��������,
	        �� ���� �������� �������.<br /><br />

			������������� ��������� ������� �������� �� �������� �������� ������� �� ����� ����������� ��������
			�� ����������� � ��������������� ��������� ������, �� ���� ��������� ����� WMZ
			� �������� ���������� ����� � ������.<br /><br />

        </p>

        <p>��� ���������� ������ Z-�������� ���������� ������� WMZ � ������� ���� ������ ��������� ���� ��� &quot;���� ������������ ������&quot;
        �������� � ������� &laquo;��ز ������в�&raquo; ������� &laquo;����i&raquo; � �������� ��� ������ &laquo;WebMoney WMZ&raquo;.</p>
        <div align="center"><img src="/img/ibox/1.png" width="400" height="321" alt="" border="0"></div>
        <p>����� ������ ����� &laquo;WMZ&raquo; ��� ��������� ������������ � ��������� ��������� ������.</p>
        <div align="center"><img src="/img/ibox/2.png" width="400" height="321" alt="" border="0"></div>
        <p>������������ � ��������� �������, �� ������ ��������������� ���������� � ���������� ������ Z-��������. ��� ����� ���� ������ �����
        ������ �������� � ����� ���� ����� ����� &laquo;Z&raquo; - ����� 12 ����. ����� ���� �� ������ �������� ������ ���������� � ����� �������,
        ������� ����� ��������� ��� �� �������, ���������������� ������ &laquo;�����������&raquo;, ����� ����.</p>
        <div align="center"><img src="/img/ibox/3.png" width="400" height="321" alt="" border="0"></div>
        <p>����� ����� ������ ��������, �� ���������� � ����� ����, � ������� ����� ������������� ����� ��������� ���� �����
        ����� �������������� ���������.</p>
        <div align="center"><img src="/img/ibox/4.png" width="400" height="321" alt="" border="0"></div>
        <p>��������� ���� ��������� ��� �������: ����� �� ��� ��� ��� ���.</p>
        <div align="center"><img src="/img/ibox/5.png" width="400" height="321" alt="" border="0"></div>
        <p>� ��������� ����� �������� ������ ��������� ���� � ������������ �� �������� ��������� ���������� � ����� ���������� Z-��������.</p>
        <div align="center"><img src="/img/ibox/6.png" width="400" height="321" alt="" border="0"></div>

      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>