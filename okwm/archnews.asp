<?php
#--------------------------------------------------------------------
# OKWM help page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;

// ��������
$title = "����� �������� � �������, ���������, ����, ����� WebMoney, Ukash, Pokerstars, Betfair";
$Keywords = "�������� Webmoney, ���� ������ wmz, ������ WMZ, ������� WMZ, wmz �� �������, WMZ �� ��������, ������ wm, WMZ, WME, ������� WebMoney, �����, ��������, ����������� ������";
$Description = "������� � ������ �������� Ukash, WebMoney, Betfair, Pokerstars � �����, ������, ���������������.";
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
       <h1>����� ��������</h1>
   </td>
   <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
   </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
EOT;

    // ����� ��������
    include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/news/archnews.php");
    echo <<<EOT

      </div>
   </td><td class="rsh"></td></tr>

EOT;

HTMLTail();
?>