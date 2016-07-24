<?php
#--------------------------------------------------------------------
# OKWM partners page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/verifysum.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;

// ��������
$title = "������ ������� OKWM � ����, �����, ����� WebMoney WMZ WMR WME WMU, Ukash, Pokerstars, Betfair";
$Keywords = "�������� Webmoney, ���� ������ wmz, ������ WMZ, ������� WMZ, wmz �� �������, WMZ �� ��������, ������ wm, WMZ, WME, ������� WebMoney, �����, ��������, ����������� ������";
$Description = "������ ��������� ������� OKWM - ������� � ������ �������� WebMoney, Ukash, Pokerstars, Betfair � �����, ������, ���������������.";
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
       <h1>������</h1>
   </td>
   <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
   </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="tarifs">
    <p>
    <div align="center"><b>������ ������� &quot;OKWM&quot;.</b></div>
    </p><br>
        ���� ������ �������� � ����������� �� ����� ������:<br>
        1. �� $100<br>
        2. �� $100 �� $1000<br>
        3. �� $1000 �� $5000<br>
        4. ����� $5000<br><br>

        ��� ������ �����, ��� �������� ������ ������� ������.<br>
        ��� ������� ���� ������, �������� ��������� ������ �� �����������. ������� �� ������ ������ �� ����.
        ��� �������� �� ���� �������� Webmoney (WMZ, WME, WMR � WMU), �� ����� ������ ��������� �������� ������� 0,8%.
        ��� �����, ������ � ������ ������.�����, �������� ������ ���������� � ��� ������ � �������.<br>
        ���� �� ������ �������� ��� ��������� PokerStars, �� ��� �������� �������������� ��� ���������� ��������.<br />
        ����� ����� ��������� ����������� � �������
        <a href="http://www.bank.gov.ua" target=_blank title="����������� ���� ������������� ����� �������.">������������� ����� �������</a>.<br>
        <br>�������� (� ���������) ������ ������� ��������� � �������:<br><br>
EOT;

$k = array_keys($amP);
$v = array_keys($amP[$k[0]]);
echo <<<EOT

<table cellPadding=0 cellSpacing=0>
 <tr><td><div align="right">������� -&gt;</div>
         <div align="left">v ���������</div></td>
EOT;
for ($i=0; $i < count($v); $i++) {
    echo "<td align=middle><b>".GOODS_Name2Descr($v[$i])."</b></td>";
}
echo "</tr>\n";
for ($i=0; $i < count($k); $i++) {
    $str = "<tr><td><b>".GOODS_Name2Descr($k[$i])."</b></td>";
    for ($j=0; $j < count($v); $j++) {
      $z = $amP[$k[$i]][$v[$j]];
      if (($k[$i] == $v[$j])||($z == "100/100/100/100")) {
            $str.= "<td align=middle> X </td>";
        } else {
          $str.= "<td align=middle>".$z."</td>";
        }
    }
    $str.= "</tr>\n ";
    echo $str;
}
echo "</table>";


echo <<<EOT
    </p><br>
        ����� �������, �������������� � ������� �������� ������� ������ ���:<br>
        ��� ���� �� $100 / ��� ���� �� 100$ �� $1000 / ��� ���� �� $1000 �� $5000 / ����� $5000<br /><br />
        ������� ������� � ��������� ������ �� ���� � ����� ���� �� 10000 USD ��������� �
        <a href="http://www.okwm.com.ua/contacts.asp">���������������</a>.
        </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();

function GOODS_Name2Descr ($name) {
  $sql = "SELECT GOODS_DESCRIPTION FROM GOODS WHERE GOODS_NAME = '$name'";
    OpenSQL ($sql, $row, $res);
    if ($row == 1) {
        $row_rec = NULL;
        GetFieldValue ($res, $row_rec, "GOODS_DESCRIPTION", $Descr, $IsNull);
    } else
        $Descr = "";
    return $Descr;
}

?>