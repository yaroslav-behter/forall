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
$title = "��������� ���� PokerStars �� Webmoney WMU";
$Keywords = "PokerStars �� WMU, ����������, �����, ��������, ����������� ������, ��������� �������";
$Description = "������ ���������� PokerStars �� wmu, ������� WMU �� ���� Pokerstars ����� �����";
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
       <h1>��������� ���� PokerStars �� WMU</h1>
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
      <p>������ �� ���������� ������ PokerStars �� WMU.</p>
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
		������� ����� WMU <input type="text" name="InSum3" value="" onclick="OutSum9.value=InSum2OutSum('WMU', 'PSU', InSum3.value);" onkeypress="OutSum9.value=InSum2OutSum('WMU', 'PSU', InSum3.value);" onkeyup="OutSum9.value=InSum2OutSum('WMU', 'PSU', InSum3.value);"><br />
		����� Pokerstars <input type="text" name="OutSum9" value="" readonly><br /><br />
		<input type="hidden" name="inmoney" value="3">
		<input type="hidden" name="outmoney" value="9">
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
		<p>��������! ������ ���������� �������� ������������� ����� Webmoney Merchant ��� ����� ������� �����.
		���������� ������ PokerStars ���������� ���������������� ����� � ������ ������. � ������� ���(����) ���������� ����������
		� ������� �������� ���� ����� ����� ������.<br />
		����� ������ ������� �� �������� <a href="/contacts.asp">&quot;��������&quot;</a>. �� �������������� �����������
		����������� � ����� ���������������.
        </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
?>