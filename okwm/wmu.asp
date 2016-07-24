<?php
#--------------------------------------------------------------------
# OKWM WMU to Ukash page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
$https= DOMAIN_HTTPS;
// ��������
$title = "������ ������� Ukash �� Webmoney WMU";
$Keywords = "Ukash �� WMU, ������ ������ ukash, �������, �����, ��������, ����������� ������, ��������� �������";
$Description = "������ ����� wmu �� Ukash, ������������ ������� ������� UKASH �� ����� �����";
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
       <h1>������ ������ Ukash �� WMU</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="wmukash">
		<script language="JavaScript">
		  var key_2_press=new Image();
		  key_2_press.src='$domain/img/keys/key_2_press.gif';
		</script>
      <p>������ ������ � ��������� �� ������ WMU �� Ukash &euro;.</p>
      <script src="/js/main.js" type="text/javascript"></script>
      <script>
EOT;
    //include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/js/main.js");
    echo "</script>";
    require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/js/pereschet.js");
    echo <<<EOT
      <p>
      <form enctype="multipart/form-data" method="post" name="makeexchange" id="makeexchange" action="$domain/specification.asp">

		<input type="hidden" name="title_page" value="$title">
		������ ����� WMU <input type="text" name="InSum3" value="" onclick="OutSum7.value=InSum2OutSum('WMU', 'UKSH', InSum3.value);" onkeypress="OutSum7.value=InSum2OutSum('WMU', 'UKSH', InSum3.value);" onkeyup="OutSum7.value=InSum2OutSum('WMU', 'UKSH', InSum3.value);"><br />
		����� ������� Ukash &euro; <input type="text" name="OutSum7" value="" readonly><br /><br />
		<input type="hidden" name="inmoney" value="3">
		<input type="hidden" name="outmoney" value="7">
		<input type="hidden" name="order" value="ukrbuy">
		<img src="$domain/img/keys/key_2_symple.gif" width="136" height="19"
		     onMouseOut  = "this.src = '$domain/img/keys/key_2_symple.gif';"
		     onMouseOver = "this.src =  key_2_press.src;"
		     onClick     = "document.makeexchange.submit();">
		<br>

      </form>
      </p>
      <hr color=#C0C0C0 size=3 noshade>
      </div>
      <div id="help">
		<p><img src="/img/ukash-logo.gif" alt="Ukash" border="0"><br />
		��� ������ ������������� ����������� �������� ������� Ukash ������ ��������, ��������� �� �������� ��� ��� ���������
		(��������� ����� WebMoney ��� �������� ��������).
        </p>
        <p><b>��� ����� Ukash?</b><br /></p>
        <p>������� Ukash - ��� ������������� �������������� ����� ��������, ������������ � ���������.<br />
        ��� ������ �������� Ukash ����� ���������� ��������� ������ � ������, ������� � ������ �����, ������ ������ � ������������ ��������
        � ������, �������� ��������� � ���������� ������� � ���������. ������ �����, ��� ������ ��� ���, ��� �� ����� �������� ���������
        ����� � ���� ����������� ������ (���������, �����������), ��������� ������� ����� � ���������� �������� ��� ������ �� ���� ������
        ��������� ���� �����������.
        </p>
        <p>������������ Ukash ����� ������.<br />
        1.	������ ������ Ukash.<br />
        2.	�������� Ukash � �������� ������ ������.<br />
        3.	������� ����� � ������� ������� - � ��� ������!<br />
        </p>
        <p><b>��� � ��� ������ Ukash ������?</b><br />
        ���������� ��� ������� ������������ ������� ��� ������ ������ �������.<br />
        1.	�������� ������ ������ Ukash ������ ��������, ��������� � �������� ������ ��������� ����� WebMoney (WMZ, WME, WMR, WMU);<br />
        2.	������ � ���� ������ ����������������� � ������ ������ Ukash ������ �������� �� �������� ��������.
        </p>
        <p><b>��� ��������� Ukash ������?</b><br />
        ���������, ������������ �� ��� ������� Ukash ����� �� ����������� ����� Ukash. ��� ����� ����� ������������������ �� �����
        <a href="http://www.ukash.com" target="_blank">www.ukash.com</a> � ������������ � �������
        <a href="http://www.ukash.com/uk/en/mytoolkit/" target="_blank">Tool Kit</a> ("��������������") ������� Comine (���������)
        ��� Split (���������) ������� �������.
        </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
?>