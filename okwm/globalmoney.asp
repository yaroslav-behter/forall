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
    $title = GetSEO("9aa2614f84c0601f34548e7079a74762");
    if ($title=="") $title = "������, �������, �������� Ukash. ������� Ukash ������ �������� �� WebMoney � �������� � �������";
    $Description = GetSEO("13865a8560d3077d4c88194c333567a8");
    if ($Description=="") $description = "������ ����� Ukash �� WebMoney, ������� ������� Ukash �� ����� ����� �� ��������.";
    $Keywords = GetSEO("1c96e282b8a37a6acca820a8e169826b");
    if ($Keywords=="") $keywords = "������ ���� � �������, ������ Ukash, Ukash � �����, ������ ������ ukash, ������� Ukash, ����, Ukash, �����, ��������, ����������� ������";


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
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <p>
         <div align="center"><img src="/img/visa.png" width="390" height="192" alt="" border="0"><br /><b>��������� ����� VISA &laquo;����������&raquo;</b></div>
      </p>
      <div id="help">
		<p>��������� ����� VISA ����������� - ��� ���������� ���������� ������� ������������ �������� ����� POS-��������� � � ���� ��������,
		� ����� ������� ������ ��������� ������ ����������� ������ �� �������� � ������� ����������.<br /><br />
		������ ����� �� �������, ��� ��������� ��������� ����������� �� ���������. ��� ���������� ����� ��� �������������
		������������� ������� ��� ����������������� ��� � ����, ��������� ��������. ��� ������ Webmoney �� VISA Globalmoney
		����������� ����� � ������ WMID �� �����.<br /><br />

		����������� �����:<br />
		- ������ ����� � ����� ���������, ������� ��������� �������� ������������� ��������� ������� MasterCard/VISA,
		�� ���� ������� � � ����.<br />
		- ������ ������ � �������� ����� ����� POS-���������.<br />
		- ������ � ���� �������� ����� ������� ��������-����������.<br /><br />

		��������� ��������� �����: 50 ���.
		</p>

      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>