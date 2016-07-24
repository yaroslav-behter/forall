<?php
#--------------------------------------------------------------------
# OKWM specification page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003.
#--------------------------------------------------------------------
# Requires /lib/config.asp
# Requires /lib/currency.asp
# Requires /lib/database.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/currency.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/verifysum.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/matrix_api.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm.inc");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/mb.inc");
// ����������� �������� ����� $In_Val_name, $In_Val_code, $Out_Val_name, $Out_Val_code, $Town_name
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/in_form_val.asp");

 $domain = DOMAIN_HTTPS;
 if (isset($HTTP_POST_VARS['lastname'])) $lastname = htmlspecialchars(trim($HTTP_POST_VARS['lastname'])); else $lastname = "�������";
 if (isset($HTTP_POST_VARS['firstname'])) $firstname = htmlspecialchars(trim($HTTP_POST_VARS['firstname'])); else $firstname = "���";
 if (isset($HTTP_POST_VARS['midlename'])) $midlename = htmlspecialchars(trim($HTTP_POST_VARS['midlename'])); else $midlename = "��������";
 if (isset($HTTP_POST_VARS['passport'])) $passport = htmlspecialchars(trim($HTTP_POST_VARS['passport'])); else $passport = "����� �����";
 $NUAH   = "&nbsp;&nbsp;��������� ����� ���������� �� ��� � ���� � ������� 24 �����.<br>
            ����������:
            <input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
            <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
            <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20><br>
            ��������: <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20><br>
            <u>������ �����������</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $P24   = "&nbsp&nbsp��������� ����� ������������� �� ��������� ���� ��������� �
            ������� 24 �����. ������������ ��������: \"��������� ����������
            � ������ ������� �� ������� ����������� �������� �������� Webmoney (���� Z...)\".<br>
            ���� ������:
            <input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
            <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
            <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20>
            <hr color=#C0C0C0 size=3 noshade>";
 $d      = date ("d.m.Y");
 $n      = rand (21,99);
 $USD    = "&nbsp;&nbsp;��������� ����� ���������� �� ��� � ���� � ������� 24 �����.
      ������ �� �� �������� ���������������� ������� �������, (�� ���������
      ��.44, 64, 386 ������������ ������� �������) ���������� �����������
      ��������� �� ������� ������������� ��� �����  $ � ��������������
      �����:<br>
      <b>������� ��������� � $n  �� $d �.</b><br>
      &nbsp;&nbsp;� (<input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
      <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
      <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20>, ��������
      <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20>) ������� �������������
      OKWM.com.ua �������� ������������� ��� ��� ������ �� ����������� �������
      ��������, �������� ��������, �� ����������� ������ (������� ���) � �����
      �������������� ����� �������.<br>
      &nbsp;&nbsp;������������� OKWM.com.ua ����������� ���������� �������
      ��������� � ������� 24 �����. ��� ������� ��������� � ����������� �������
      ��������� ��� �������� � ������������ ����� ����.<br>
      <u>������� �����������</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $USD_   = "&nbsp;&nbsp;��������� ����� ���������� �� ��� � ���� � ������� 24 �����.
      ������ �� �� �������� ���������������� ������� �������, (�� ���������
      ��.44, 64, 386 ������������ ������� �������) ���������� �����������
      ��������� �� ������� ���������� ���� �����  $ � ��������������
      �����:<br>
      <b>������� ��������� � $n  �� $d �.</b><br>
      &nbsp;&nbsp;� (<input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
      <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
      <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20>, ��������
      <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20>) ������� �������������
      OKWM.com.ua �������� ���������� ���� ��� ����� � ����������� �������
      ��������, �������� ��������, � ����������� ������ (������� ���) � �����
      �������������� ����� �������.<br>
      &nbsp;&nbsp;������������� OKWM.com.ua ����������� ���������� �������
      ��������� � ������� 24 �����. ��� ������� ��������� � ����������� �������
      ��������� ��� �������� � ������������ ����� ����.<br>
      <u>������� �����������</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $EUR    = "&nbsp;&nbsp;��������� ����� ���������� �� ��� � ���� � ������� 24 �����.
      ������ �� �� �������� ���������������� ������� �������, (�� ���������
      ��.44, 64, 386 ������������ ������� �������) ���������� �����������
      ��������� �� ������� ������������� ��� ����� ���� � ��������������
      �����:<br>
      <b>������� ��������� � $n  �� $d �.</b><br>
      &nbsp;&nbsp;� (<input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
      <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
      <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20>, ��������
      <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20>) ������� �������������
      OKWM.com.ua �������� ������������� ��� ��� ������ �� ����������� �������
      ��������, �������� ��������, �� ����������� ������ (����) � �����
      �������������� ����� �������.<br>
      &nbsp;&nbsp;������������� OKWM.com.ua ����������� ���������� �������
      ��������� � ������� 24 �����. ��� ������� ��������� � ����������� �������
      ��������� ��� ��������  � ������������ ����� ����.<br>
      <u>������� �����������</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $EUR_   = "&nbsp;&nbsp;��������� ����� ���������� �� ��� � ���� � ������� 24 �����.
      ������ �� �� �������� ���������������� ������� �������, (�� ���������
      ��.44, 64, 386 ������������ ������� �������) ���������� �����������
      ��������� �� ������� ���������� ���� ����� ���� � ��������������
      �����:<br>
      <b>������� ��������� � $n  �� $d �.</b><br>
      &nbsp;&nbsp;� (<input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
      <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
      <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20>, ��������
      <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20>) ������� �������������
      OKWM.com.ua �������� ���������� ���� ��� ����� � ����������� �������
      ��������, �������� ��������, � ����������� ������ (����) � �����
      �������������� ����� �������.<br>
      &nbsp;&nbsp;������������� OKWM.com.ua ����������� ���������� �������
      ��������� � ������� 24 �����. ��� ������� ��������� � ����������� �������
      ��������� ��� ��������  � ������������ ����� ����.<br>
      <u>������� �����������</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $WarningX19 = "<p class=\"error\">���������� ������ �������� �������� �� ������������ � ������� � ���������. � ������ �������� ������ ����� ������������ �� �����.</p>";
 $WebmoneyToBetfairRules = "<u>�������� �������� Webmoney</u>:<br />
            <input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
            <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
            <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20><br>
            ��������: <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20><br>
            <u>������ �����������</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $WebmoneyToPokerstarsRules = "<u>�������� �������� Webmoney</u>:<br />
            <input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
            <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
            <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20><br>
            ��������: <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20><br>
            <u>������ �����������</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";
 $WebmoneyToGlobalmoney = $WebmoneyToBetfairRules;

 $YandexToBetfairPokerstarsRules = "<u>�������� ����� ������.�����</u>:<br />
            <input type=text name=\"lastname\" value=\"$lastname\" maxlength=25 size=20>
            <input type=text name=\"firstname\" value=\"$firstname\" maxlength=25 size=20>
            <input type=text name=\"midlename\" value=\"$midlename\" maxlength=25 size=20><br>
            ��������: <input type=text name=\"passport\" value=\"$passport\" maxlength=25 size=20><br>
            <u>������ �����������</u>
            <input type=\"checkbox\" name=\"agreement\" value=\"Ok\">
            <hr color=#C0C0C0 size=3 noshade>";

 $vip_flag = "vip";
 $WMid = "";

 function ConvertName ($money) {
         switch ($money) {
            case "NUAH":
               return "������";
            case "PSU":
               return "Pokerstars";
            case "BFU":
               return "Betfair USD";
            case "USD":
               return "USD";
            case "EUR":
               return "����";
            case "UKSH":
               return "Ukash EURO";
            case "YAD":
               return "Yandex RUR";
            case "PCB":
               return "USD ��� �� ϲ�����������";
            case "SBRF":
               return "������";
               //return "�������� ������";
            case "BANK":
               return "USD ������ �����";
            case "P24US":
               return "������24 USD";
            case "P24UA":
               return "������24 ���";
            case "GMU":
               return "VISA Globalmoney, ���";
            default:
               return $money;
         }
 }

 function InDetails ($inmoney) {
      // ��������� ��� ������
      switch ($inmoney) {
         case "WMZ":
         case "WME":
         case "WMR":
         case "WMU":
         // ������� WMid ��� �������� �����
         global $WMid, $outmoney;
         if ($outmoney == "GMU") $protec_msg = "<p>(��� ������ ������ � ����� ��������� ��������� � ��������������� ��� ���������� ������)</p>";
echo <<<EOT

<table width="100%" style="font-size:13px;font-weight:normal;color:#525252;margin-left:15px;">
   <tr>
   <td width="10%">������ ������:&nbsp;&nbsp;</td>
   <td>
       <input type="radio" name="method" value="wmt" id="wmt" checked>
       <label for="wmt">����� Merchant WebMoney</label><br />
       <input type="radio" name="method" value="invc" id="invc">
       <label for="invc">����� ������� �����</label> $protec_msg
   </td>
   </tr>
   </table><br />
<p>
������� WMID ������ �������� ��� <b>������������</b> �������� ������������ ��������� ������ � ����������:<br>
<input type=text name="WMid" value="$WMid" maxlength=12 size=15><br /><br />
</p>

EOT;
            break;
         case "MBU":
         // ������� Moneybookers Account (����) � �������� ������ �������
         global $MBAcc;
echo <<<EOT
<p>������� ��� ���� Moneybookers (e-mail), � �������� �� ������ �������:<br>
<input type=text name="MBAcc" value="$MBAcc" maxlength=40 size=40>
</p>
EOT;
            break;
         case "USD":
         case "EUR":
         case "NUAH":
         // �������� �����, ��� �� ������ �������:
         global $phone, $USD_, $EUR_, $NUAH, $office_addr;
            if ($inmoney == "USD") echo "<br /><br />$USD_";
            if ($inmoney == "EUR") echo "<br /><br />$EUR_";
            if ($inmoney == "NUAH") echo "<br /><br />$NUAH";
            // ��������� ���� ��� ����� ��� � ��������� ��� ������ ������ ���� (�����������) - 20.04.2010 �����
            //require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/js/onclick.js");
echo <<<EOT

<div id="doc" style="width:380;height=0;"></div>
<br />
<p>� ��������� ���� ������ ��� ���� ��������� �� ������:<br />
$office_addr<br />
�������� ������ ����� �� ���������, ��������� �� ��������
<a href="/contacts.asp" title="����� ������ ��������." target="_blank">&quot;��������&quot;</a>
</p>
<p>H���� ������ ����������� ��������:
<input type=text name="phone" value="$phone" maxlength=15 size=20>
</p>

EOT;
            break;
         case "UKSH":
            global $vNumber, $vValue, $InSum;
echo <<<EOT
<p><a href="http://www.ukash.com" target="_blank"><img src="/img/ukash-logo.gif" border="0"></a><br />
<font color="red"><b>��������!</b> ��� �������� Ukash ����������� ����� �������� 10 &euro;.</font><br />
����� �������: <input name="vNumber" type="text" value="$vNumber" size="20" maxlength="19"><br />
������� �������: <input name="vValue" type="text" value="$vValue"><br />
����� c�������:  $InSum &euro;</p>
<p>���� ������� ������ ������� ������ ����� ������, � ����� ������ ��� ����� ����� ����� ������ �� ���������� �����.<br />
��������� ��� � ���� ��� ����������� ������������� Ukash.<br />
����� ������ ������� ����� ������� ��� �� e-mail.<br />
��� ������������� ������ ��������, ����������, ��������������.
</p>
EOT;
            break;
         case "YAD":
            global $yandexAcc, $outmoney;
            if (in_array($outmoney, array("WMZ","WME","WMR","WMU"))){
echo <<<EOT
<p>
��� ������ WebMoney - ������.������ ��� ���� � �������.������� ������ ���� ��������������� � �������� � WMID �� ����� banks.webmoney.ru <br />
���������� � �������� ������ ����������� ��� � ���. ���� ����� ����� �������� ����� ��� ��� ����� �������� ���������
� �������������� ��� ������ WMID � ��������� ������� �������.
����� ���������� ��������� ��� ������� WebMoney � ����� � ������.�������. ��������� ���������� ��������� ���
<a href="http://money.yandex.ru/exchange/wm/about.xml" target="_BLANK">http://money.yandex.ru/exchange/wm/about.xml</a>.<br />
</p>
EOT;
            }
echo <<<EOT
<p>
����� ����� ������.�����: <input name="yandexAcc" type="text" value="$yandexAcc" size="27" maxlength="27"><br />
</p>
EOT;
            break;
         case "P24US":
         case "P24UA":
            global $p24account, $lastname, $firstname, $midlename, $phone;
echo <<<EOT
<p>
��� �������� �� ��� ���� �� ������� ������24 � ���������� ������� �� ������ ����������� �������  &quot;������� ������ �������&quot;.<br />
����� ������� ���������, ��� �� ����������� ������� ������� � ���������������.
</p>
<p>
������ ��������� ����������� �����:<br />
<input type=text name="lastname" value="$lastname" maxlength=25 size=20>
<input type=text name="firstname" value="$firstname" maxlength=25 size=20>
<input type=text name="midlename" value="$midlename" maxlength=25 size=20><br /><br />
H���� ������ ����������� ��������:<br />
<input type=text name="phone" value="$phone" maxlength=15 size=20><br /><br />
����� ����� ��� �������� (16 ��������):<br />
<input type=text name="p24account" value="" maxlength=25 size=20><br /><br />
</p>

EOT;
            break;
      }
 }

 function OutDetails ($outmoney) {
    global $USD, $EUR, $NUAH, $WebmoneyToBetfairRules, $WebmoneyToPokerstarsRules, $WebmoneyToGlobalmoney, $YandexToBetfairPokerstarsRules;

         // ��������� ��� ����������� �����
         switch ($outmoney) {
            case "WMZ":
            // ������� ����� ������ Z-�������� ��� �������� ��� WebMoney:
            global $Z;
            $Z = (!empty($Z))? $Z: "Z";
echo <<<EOT
<p> ������� ����� ������ Z-�������� ��� �������� ��� WebMoney:<br>
<input type=text name="Z" value="$Z" maxlength=13 size=15>
</p>
EOT;
            break;
            // ������� ����� ������ Z-�������� ��� �������� ��� WebMoney:
         case "WME":
            global $E;
            $E = (!empty($E))? $E: "E";
echo <<<EOT
<p> ������� ����� ������ E-�������� ��� �������� ��� WebMoney:<br>
<input type=text name="E" value="$E" maxlength=13 size=15>
</p>
EOT;
            break;
            // ������� ����� ������ R-�������� ��� �������� ��� WebMoney:
         case "WMR":
            global $R;
            $R = (!empty($R))? $R: "R";
echo <<<EOT
<p> ������� ����� ������ R-�������� ��� �������� ��� WebMoney:<br>
<input type=text name="R" value="$R" maxlength=13 size=15>
</p>
EOT;
            break;
            // ������� ����� ������ U-�������� ��� �������� ��� WebMoney:
         case "WMU":
            global $U;
            $R = (!empty($R))? $U: "U";
echo <<<EOT
<p> ������� ����� ������ U-�������� ��� �������� ��� WebMoney:<br>
<input type=text name="U" value="$U" maxlength=13 size=15>
</p>
EOT;
            break;
         case "USD":
         case "EUR":
         case "NUAH":
         case "BANK":
            global $office_addr;
            // ���� ��� � ���������
            if ($outmoney == "NUAH") echo $NUAH;
            if ($outmoney == "USD") echo $USD;
            if ($outmoney == "EUR") echo $EUR;
            if ($outmoney == "BANK") echo $USD;
            // �������� �����, ��� �� ������ �������� ������
echo <<<EOT
<p>� ��������� ���� ������ ��� ���� �������� �� ������:<br>
$office_addr<br />
�������� ������ ����� �� ���������, ��������� �� ��������
<a href="/contacts.asp" title="����� ������ ��������." target="_blank">&quot;��������&quot;</a>
</p>
<p>H���� ������ ����������� ��������:
<input type=text name="phone" value="" maxlength=15 size=20>
</p>

EOT;
            break;
         case "MBU":
            global $MBU;
echo <<<EOT
<p>������� ���� Moneybookers (e-mail), ���� ���������� �������:<br>
<input type=text name="MBAcc" value="$MBAcc" maxlength=40 size=40>
</p>
EOT;
            break;
         case "UKSH":
echo <<<EOT
<p><a href="http://www.ukash.com" target="_blank"><img src="/img/ukash-logo.gif" border="0"></a></p>
<p>����� ������ ������ ����� ������ ������ Ukash &euro;<br>
����� ������� ����� ������� ��� �� e-mail.<br />
��� ������������� ������ �������� ���������� ��������������.
</p>
EOT;
            break;
         case "BFU":
             global $BFacc, $inmoney;
             if (in_array($inmoney,array("WMZ","WME","WMR","WMU"))) {
                 echo $WebmoneyToBetfairRules;
             }
             if ($inmoney == "YAD") {
             	echo $YandexToBetfairPokerstarsRules;
             }
echo <<<EOT
<p>
��� ���������� ������ ����� <b>Betfair</b> ������� ���� ���:<br />
<input type=text name="BFacc" value="$BFacc" maxlength=40 size=40>
</p>
EOT;
            break;
         case "PSU":
             global $PSacc, $inmoney;
             if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))) {                 echo $WebmoneyToPokerstarsRules;
             }
echo <<<EOT
<p>
��� ���������� ������ ����� <b>PokerStars</b> ������� ���� ���:<br />
<input type=text name="PSacc" value="$PSacc" maxlength=40 size=40>
</p>
EOT;
            break;
         case "YAD":
            global $yandexAcc, $inmoney;
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))){
echo <<<EOT
<p>
��� ������ WebMoney - ������.������ ��� ���� � �� ������ ���� ��������������� � �������� � WMID �� ����� banks.webmoney.ru<br />
���������� � �������� ������ ����������� ��� � ���. ���� ����� ����� �������� ����� ��� ��� ����� �������� ���������
� �������������� ��� ������ WMID � ��������� ������� �������.
����� ���������� ��������� ��� ������� WebMoney � ����� � ������.�������. ��������� ���������� ��������� ���
<a href="http://money.yandex.ru/exchange/wm/about.xml" target="_BLANK">http://money.yandex.ru/exchange/wm/about.xml</a>.<br />
</p>
EOT;
            }

echo <<<EOT
<p>
����� ����� ������.�����: <input name="yandexAcc" type="text" value="$yandexAcc" size="27" maxlength="27"><br />
</p>
EOT;
            break;
         case "PCB":
            global $pcb_acc, $lastname, $firstname, $midlename, $inn, $mfo, $egrpou, $cardAcc, $inmoney;
echo <<<EOT
<p>
������ ��������� ����������� ����� ��� ��������:<br />
<input type=text name="lastname" value="$lastname" maxlength=25 size=20>
<input type=text name="firstname" value="$firstname" maxlength=25 size=20>
<input type=text name="midlename" value="$midlename" maxlength=25 size=20><br /><br />
����� � ����� ��������: <input type=text name="passport" value="$passport" maxlength=25 size=20> (��������, �� 982344)<br />
���: <input name="inn" type="text" value="$inn" size="10" maxlength="10"> (10 ����)<br />
��� ����� (���): <input name="mfo" type="text" value="$mfo" size="6" maxlength="6"> (6 ����)<br />
��� ������: <input name="egrpou" type="text" value="$egrpou" size="8" maxlength="8"> (8 ����)<br />
����� ����� ��� ����� �����: <input name="cardAcc" type="text" value="$cardAcc" size="27" maxlength="27"> (12-16 ����)<br />
<input name="card_bank" type="radio" value="cardAcc" checked>��������<br />
<input name="card_bank" type="radio" value="bankAcc">����<br />
EOT;
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))) {
echo <<<EOT

<b>��������!</b> ���� �������� ��� ���� ����������� ������ ���� ���������� � ������ WMID �� �����
<a href="https://cards.webmoney.ru/asp/default.asp" target="_blank">https://cards.webmoney.ru/asp/default.asp</a>
EOT;
            }            echo <<<EOT
<br />��� ������ ������� �� ��� �� &laquo;ϲ�����������&raquo;:<br />
- �� �������, ���������� �� 16-00, ���������� �� ����/����� ���������� � ���� �� ���� � ������� 2 ����� (�� ������� �������� � ����������� ���);<br />
- ������, ���������� ����� 16-00, �������������� �� ��������� ���� �� 12-00.<br />
��������� �������� ������ ������ ������� OKWM � ������� ��������� <a href="$domain/banks.asp" target="_blank">�����</a>.

EOT;
            echo "</p>";
            break;
         case "SBRF":
echo <<<EOT
<p>
� ����������
</p>
EOT;
            break;
         case "BANK":
echo <<<EOT
<p>
����� WMZ �� ���������� ������ �������������� <b>������</b> ��� �������� �� �.�����.<br />
��� ���������� ������ � ��������� ������� ��������� � ������ ����������������:<br />
+380 (97) 479-00-08<br>
+380 (95) 649-00-08<br>
+380 (73) 439-00-08<br><br>
<a href="http://web.icq.com/whitepages/add_me?uin=637139590&action=add" title="�������� � ������ ���������"> <b>ICQ 637139590</b> <img src="img/icq.gif" border=0></a><br><br>
WMId $WMid<br>
</p>
EOT;
            break;
         case "P24US":
         case "P24UA":
            global  $inmoney, $p24account, $lastname, $firstname, $midlename, $phone;
echo <<<EOT
<p>
������� �� ��� ���� �� ������� ������24 �������������� ���������, � �������������� ������, ����� ���������� ������ ������.
</p>
<p>
������ ��������� ����������� �����:<br />
<input type=text name="lastname" value="$lastname" maxlength=25 size=20>
<input type=text name="firstname" value="$firstname" maxlength=25 size=20>
<input type=text name="midlename" value="$midlename" maxlength=25 size=20><br /><br />
H���� ������ ����������� ��������:<br />
<input type=text name="phone" value="$phone" maxlength=15 size=20><br /><br />
����� ����� ��� �������� (16 ��������):<br />
<input type=text name="p24account" value="" maxlength=25 size=20><br /><br />
</p>

EOT;
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))) {
echo <<<EOT

<b>��������!</b> ����� �������������� ������ �� �����, <a href="https://cards.webmoney.ru/asp/default.asp" target="_blank">�������������</a>
� WMID ���������, c �������� ������������ ������.

EOT;
            }
            break;
         case "GMU":
            global $GMaccount, $lastname, $firstname, $midlename, $phone, $passport;
            echo $WebmoneyToGlobalmoney;

echo <<<EOT
<p>
H���� ������ ����������� ��������:<br />
<input type=text name="phone" value="$phone" maxlength=15 size=20><br /><br />
����� ����� VISA Globalmoney ��� �������� (16 ��������):<br />
<input type=text name="GMaccount" value="" maxlength=25 size=20><br /><br />
</p>

EOT;
            break;
      }
 }

 // Verify purchase length and letters
 function VerifyP ($type, $P) {
   if ($type == "z") {      global $WMid;
      if (!preg_match("/^Z[0-9]{12}\$/",$P)) {
         $err = "������: ����� �������� ������ ���������� � ����� Z<br>";
         $err.= "� ��������� 12 ����! ��������: Z619795576359";
      } else {         list($status, $wm_error) = CheckWMIDPurse($WMid, $P);
         if ($status!==1) $err = $wm_error;
      }
   }
   if ($type == "e") {
      global $WMid;
      if (!preg_match("/^E[0-9]{12}\$/",$P)) {
         $err = "������: ����� �������� ������ ���������� � ����� E<br>";
         $err.= "� ��������� 12 ����! ��������: E493920922153";
      } else {
         list($status, $wm_error) = CheckWMIDPurse($WMid, $P);
         if ($status!==1) $err = $wm_error;
      }
   }
   if ($type == "r") {
      global $WMid;
      if (!preg_match("/^R[0-9]{12}\$/",$P)) {
         $err = "������: ����� �������� ������ ���������� � ����� R<br>";
         $err.= "� ��������� 12 ����! ��������: R118454266669";
      } else {
         list($status, $wm_error) = CheckWMIDPurse($WMid, $P);
         if ($status!==1) $err = $wm_error;
      }
   }
   if ($type == "u") {
      global $WMid;
      if (!preg_match("/^U[0-9]{12}\$/",$P)) {
         $err = "������: ����� �������� ������ ���������� � ����� U<br>";
         $err.= "� ��������� 12 ����! ��������: U182522806177";
      } else {
         list($status, $wm_error) = CheckWMIDPurse($WMid, $P);
         if ($status!==1) $err = $wm_error;
      }
   }
   if ($type == "WMid") {
      if (strlen($P)!=12) {
         $err = "������: ����� ������ ������ ��������� 12 ����! ��������: 523133987155";
      } else {
         list($status, $wm_error) = CheckWMIDPurse($P);
         if ($status!==1) $err = $wm_error;
      }
   }
   if ($type == "AuthWMid") {       $sql = "SELECT COUNT(wmid) FROM authwmid WHERE wmid='".mysql_escape_string(trim($P))."'";
       OpenSQL($sql, $rows, $res);
       GetFieldValue ($res, $row, "COUNT(wmid)", $isAuthWMid, $IsNull);
       if ($isAuthWMid==0) {           $err = "����� ������ ��� � ����� ���� ��������.<br />";
           $err.= "��� ���������� ��������� � ��� ���� � ���������� ��� ��������� ����� ������.<br />";
           $err.= "��� ��������� ������� ��������� � ���������������.<br />";
       }
   }
   if ($type == "pu") {
      if (substr($P,0,5)!="41004") {
         $err = "����� ����� ��������.����� ������ ���������� � 41004!";
      }
   }
   if ($type == "fio") {
      if (ereg("�������", $P)) {
         $err = "������� ������� �������! <b>� ������ ������� ������ ����� ���������.</b><br />";
      }
      if (ereg("���", $P)) {
         $err.= "��� ������� �������! <b>� ������ ������� ������ ����� ���������.</b><br />";
      }
      if (ereg("��������", $P)) {
         $err.= "�������� ������� �������! <b>� ������ ������� ������ ����� ���������.</b><br />";
      }
      if ($P=="  ") {
         $err.= "�� �� ����� �������, ��� � ��������! <b>������ �� �������.</b>";
      }
      //$r = preg_match_all('/([0-9a-zA-Z�-��-߳����� -]+)/', $P, $ok);
      //echo $r;
      if (preg_match_all('/([0-9a-zA-Z�-��-߸������� -]+)/', $P, $ok)<>1) {         $err.= "�� ����� ������������ ������� � �������, ����� ��� ��������! <b>������ �� �������.</b>";
      }
   }
   if ($type == "passport") {
      if ($P=="") {
         $err.= "������� ����� � ����� ���������.";
      }
   }
   if ($type == "city") {
      if ($P=="") {
         $err.= "�������� <b>�����</b>, � ������� �� ������ ��������� �����.";
      }
   }
   //if (($type == "mbu")&&(!preg_match('/^(.+@.+\..+|)$/', $P))) {
   //   $err.= "���� Moneybookers (e-mail) ������ �� �����.";
   //}
   if (($type == "uksh_num")&&(!preg_match('/^[0-9]{19}$/', $P))) {       $err.= "������: ����� ������� Ukash ������� �� ������������ ����.";
   }
   if (($type == "uksh_val")&&(!preg_match('/^\d+[\.|\,]?\d*$/', $P))) {       $err.= "������: ������� ������� Ukash �� �������� ������.";
   }
   if ($type == "mbu") {
      $err.= "� ��������� ����� Moneybookers �������� �������������.<br />��� ��������� ����������� � ���������������.";
   }
   //if (($type == "yandex")&&(!preg_match('/^[0-9]{10,16}$/', $P))) {
   //    $err.= "������: ����� ����� ������.����� �� ������ ������ ����������� �� 11 �� 16 ����.";
   //}
   // 03.03.2015
   if ($type == "yandex") {
       $err.= "� ������ ������ ����� ������.����� �������� ��������.";
   }
   if (($type == "mfo")&&(!preg_match('/^[0-9]{6}$/', $P))) {
       $err.= "������: ��� ������� �� 6 ����.";
   }
   if (($type == "inn")&&(!preg_match('/^[0-9]{10}$/', $P))) {
       $err.= "������: ��� ������� �� 10 ����.";
   }
   if (($type == "egrpou")&&(!preg_match('/^[0-9]{8}$/', $P))) {
       $err.= "������: ������ ������� �� 8 ����.";
   }
   if (($type == "bankAcc")&&(!preg_match('/^[0-9]{16}$/', $P))) {
       $err.= "������: ����� �����(��������) ������� ������ �� ����.";
   }
   if (isset($err)) {       if (strlen($P)>0) {           $err.= "<br>�� ����� ".htmlspecialchars($P).".<br>";
       } else {           $err.= "<br>�� ������ �� �����.<br>";
       }
      return $err;
   }
 }

if (isset($HTTP_POST_VARS{'order'})) {  // ������� �� ������ ����� (������ ���� �� ��������)
   // convert all POST vars to locals
   foreach ($HTTP_POST_VARS as $fk => $fv) {
       $fv = addcslashes($fv, '"');
       eval("\$$fk = \"$fv\";");
   }
   // ���������� ��������� POST-���������� �� ����� ����� (26-12-2010)
   // � ������� ����������
   if (isset($inmoney)&&(preg_match('/^[0-9]{1,2}$/', $inmoney))) {       $id_inmoney = $inmoney;
       $inmoney = $In_Val_code[$id_inmoney];
       $InSum = $HTTP_POST_VARS["InSum".$id_inmoney];
   } else {       $inmoney = "";
       $InSum = "";
   }
   if (isset($outmoney)&&(preg_match('/^[0-9]{1,2}$/', $outmoney))) {
       $id_outmoney = $outmoney;
       $outmoney = $Out_Val_code[$id_outmoney];
       $OutSum = $HTTP_POST_VARS["OutSum".$id_outmoney];
   } else {
       $outmoney = "";
       $OutSum = "";
   }

   if (isset($town)&&($towm<1000)&&(preg_match('/^[0-'.(count($Town_name)-1).']{1}$/', $town))) {       $id_town = $town;
       $town = $Town_name[$id_town];
       // �� ������� �������� ��� ��������� �����
       switch ($town) {
           case "����":
              $office_addr = ADDR_Kiev;
              break;
           case "��������������":
              $office_addr = ADDR_Dnepr;
              break;
           case "������":
              $office_addr = ADDR_Odessa;
              break;
       }
   }

   // Change ',' to '.' in InSum and OutSum
   $InSum  = str_replace(',','.',$InSum);
   $OutSum = str_replace(',','.',$OutSum);
   // $action = buy     (������) - � ������ ������ ���� ������-�������. � ����� ������ �������.
   $action = "sell";
   $o = ConvertName($outmoney);
   $i = ConvertName($inmoney);
   $title_page = "����� ".$i." �� ".$o." ";
   // Verify format sum
   if (!VerifyFormatSum($InSum)) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("������");
      HTMLError("������ �� �������! ����� ������ ������� �������.");
      echo <<<EOT

<p>
�� ������ ������� ����� $InSum $i �� $OutSum $o.
������, ����� ��� ������ ������ ���� ������ � ����� ������� ����� �����!<br>
</p>
<p>
���������� ��� ��� ������ ��������� ����� ��� ��������� � <a href="/contacts.asp">
��������������<a> �����.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }
   if (!VerifyFormatSum($OutSum)) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("������");
      HTMLError("������ �� �������! ����� ������� ������� �������.");
      echo <<<EOT

<p>
�� ������ ������� ����� $InSum $i �� $OutSum $o.
������, ����� ������ ���� ������ � ����� ������� ����� �����!<br>
</p>
<p>
���������� ��� ��� ������ ��������� ����� ��� ��������� � <a href="/contacts.asp">
��������������<a> �����.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }

   // ��������� ����������� �� ����������� �������� ����� Ukash
   if (($inmoney=="UKSH")&&($InSum<10)) {
       $InSum = 10;
       VerifySum ($InSum, $inmoney, $OutSum, $outmoney, $NewInSum, $NewOutSum, $action);
       $OutSum = $NewOutSum;
   }

   // ��������� ����������� �� ����������� �������� ����� Pokerstars
   if (($outmoney=="PSU")&&($OutSum<10)) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("������");
      HTMLError("������ �� �������! ����� ���������� Pokerstars ������ ���� ������ $10.");
      echo <<<EOT

<p>
�� ������ ��������� ���� Pokerstars �� $OutSum $o.
������, ����� ������ ���� ������ $10!<br>
</p>
<p>
���������� ������ ������� �����.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }

   // Verify sum of operation
   if (VerifySum ($InSum, $inmoney, $OutSum, $outmoney, $NewInSum, $NewOutSum, $action)) {
      $CorrectSum = "����� � ������: $InSum $i<br>\n ����� � ������: $OutSum $o \n";
   } else {
      $CorrectSum = "����� ���� �����������������!<br>\n
                   � ������: $InSum $i<br>\n
                   � ������: $OutSum $o<br>\n
                   ����� ���������, ����� <br>\n
                   � ������: $NewInSum $i<br>\n
                   � ������: $NewOutSum $o<br>\n";
      $InSum = $NewInSum;
      $OutSum = $NewOutSum;
   }
   //*********************************************************************************************************************************
   //********************************************* TEST ������24 *********************************************************************
   //*********************************************************************************************************************************
   /*if ((($inmoney=="P24US")||($outmoney=="P24US")||($inmoney=="P24UA")||($outmoney=="P24UA"))&&getenv('REMOTE_ADDR')!="178.95.197.15"&&getenv('REMOTE_ADDR')!="93.127.52.55") {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("���� ������24");
      HTMLError("�������� �����.");
      echo <<<EOT

<p>
�������� � ������24 � ������ ������ ���������.
</p>
<p>
������ ������ ����������� �� 29 �������� 2011 �.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();

   }*/

   //*********************************************************************************************************************************
   //*********************************************************************************************************************************
   //*********************************************************************************************************************************

   if (($inmoney==$outmoney)||($NewOutSum==0)||($NewInSum==0)||
      ((in_array($inmoney,array("USD","EUR","NUAH")))&&(in_array($outmoney,array("USD","EUR","NUAH")))))
   {
          // ����������� �����. �������� ������
          HTMLHead($title_page, "", "");
          HTMLAfteHead_noBanner("������");
          HTMLError("��������� ���� ����� ����������!");
          echo <<<EOT

<p>
�� ������ ������� ����� $i �� $o.<br>
��� ���� ���� ���� ������� ������������ �����, ���� ������� ������������ �����������.
</p>
<p>
���������� ��� ��� ������ ��������� ����� � ������� ����������� ������ ��� ��������� � <a href="/contacts.asp">
��������������<a> �����.
</p>

EOT;
          HTMLAfteBody();
          HTMLTail();
          exit();
   }
   // eval("\$explain = \"\$$outmoney\";");
} elseif (isset($HTTP_POST_VARS{'signup'})) {  // ������� �� ������ "��������� ������"
   // convert all POST vars to locals
   foreach ($HTTP_POST_VARS as $fk => $fv) {
       $fv = addcslashes($fv, '"');
       eval("\$$fk = \"$fv\";");
   }

   $o = ConvertName($outmoney);
   $i = ConvertName($inmoney);
   $title_page = "OKWM.com.ua - ������, �������, �������� WMZ WME WMR Ukash (".$i."->".$o.")";
   $Operation = "sell";
   // Verify format sum
   if (!VerifyFormatSum($InSum)) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("������");
      HTMLError("������ �� �������! ����� ������ ������� �������.");
      echo <<<EOT

<p>
�� ������ ������� ����� $InSum $i �� $OutSum $o.
������, ����� ��� ������ ������ ���� ������ � ����� ������� ����� �����!<br>
</p>
<p>
���������� ��� ��� ������ ��������� ����� ��� ��������� � <a href="/contacts.asp">
��������������<a> �����.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }
   if (!VerifyFormatSum($OutSum)) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("������");
      HTMLError("������ �� �������! ����� ������� ������� �������.");
      echo <<<EOT

<p>
�� ������ ������� ����� $InSum $i �� $OutSum $o.
������, ����� ������ ���� ������ � ����� ������� ����� �����!<br>
</p>
<p>
���������� ��� ��� ������ ��������� ����� ��� ��������� � <a href="/contacts.asp">
��������������<a> �����.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }
   // Verify minimal InSum
   if (($inmoney=="WMZ")||($inmoney=="USD")||($inmoney=="P24US")) {
      $v_iCourse = BaseCurr("USD");
   } elseif (($inmoney=="WME")||($inmoney=="EUR")||($inmoney=="UKSH")) {
      $v_iCourse = BaseCurr("EUR");
   } elseif (($inmoney=="WMR")||($inmoney=="YAD")) {
      $v_iCourse = BaseCurr("RUR");
   } else {
      $v_iCourse = 1;
   }
   $InSumUSD = (BaseCurr("USD")!=0)? $InSum*$v_iCourse / BaseCurr("USD") : 0;
   if ($InSumUSD < $Down) {
      HTMLHead($title_page, "", "");
      HTMLAfteHead_noBanner("������");
      HTMLError("������ �� �������! ����� ������ ������ $Down USD.");
      echo <<<EOT

<p>
�� ������ ������� ����� $InSum $i �� $OutSum $o.
������, ����������� ����� ��� ������ ������ ���� ������������ $Down USD!<br>
</p>
<p>
���������� ��� ��� � ������� ������ ��� ��������� � <a href="/contacts.asp">
��������������<a> ����� ��� ���������� ������ ������� �����.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }
   if ($InSumUSD > $Up) {
      HTMLHead($title_page, $class, "", "");
      HTMLAfteHead_noBanner("������");
      HTMLError("������ �� �������! ����� ������ ������ $Up USD.");
      echo <<<EOT

<p>
�� ������ ������� ����� $InSum $i �� $OutSum $o.
������, ����� ��� ������ ������ ���� ����� ����������� $Up USD!<br>
</p>
<p>
���������� ��� ��� � ������� ������ ��� ��������� � <a href="/contacts.asp">
��������������<a> ����� ��� ���������� ������ ������� �����.
</p>

EOT;
      HTMLAfteBody();
      HTMLTail();
      exit();
   }

   // ��������� ����������� �� ����������� �������� ����� Ukash
   if (($inmoney=="UKSH")&&($InSum<10)) {
       $InSum = 10;
       VerifySum ($InSum, $inmoney, $OutSum, $outmoney, $NewInSum, $NewOutSum, $Operation);
       $OutSum = $NewOutSum;
   }

   // Verify sum of operation
//   if (VerifySum ($InSum, $inmoney, $OutSum, $outmoney, $NewSum, $Operation)||($s == $vip_flag)) { - � ������
   if (VerifySum ($InSum, $inmoney, $OutSum, $outmoney, $NewInSum, $NewOutSum, $Operation)) {
      $CorrectSum = "����� � ������: $InSum $i<br>\n ����� � ������: $OutSum $o";
   } else {
      $CorrectSum = "����� ���� �����������������!<br>\n
                   � ������: $InSum $i<br>\n
                   � ������: $OutSum $o<br>\n
                   ����� ���������, ����� <br>\n
                   � ������: $NewInSum $i<br>\n
                   � ������: $NewOutSum $o<br>\n";
      $InSum = $NewInSum;
      $OutSum = $NewOutSum;
   }
   if (($inmoney==$outmoney)||($NewOutSum==0)||($NewInSum==0)||
      ((in_array($inmoney,array("USD","EUR","NUAH","P24US","P24UA")))&&(in_array($outmoney,array("USD","EUR","NUAH","PCB","BANK","P24US","P24UA","GMU")))))
   {
          // ����������� �����. �������� ������
          HTMLHead($title_page, "", "");
          HTMLError("��������� ���� ����� ����������!");
          echo <<<EOT

<p>
�� ������ ������� ����� $i �� $o.<br>
��� ���� ���� ���� ������� ������������ �����, ���� ������� ������������ �����������.
</p>
<p>
���������� ��� ��� ������ ��������� ����� � ������� ����������� ������ ��� ��������� � <a href="/contacts.asp">
��������������<a> �����.
</p>

EOT;
          HTMLAfteBody();
          HTMLTail();
          exit();
   }

   // ������������ ������ ������
   $terms = "������ ����� �������:\r\n";
   switch ($inmoney) {
      case "WMZ":
      case "WME":
      case "WMR":
      case "WMU":
            $errWMid= VerifyP ("WMid", $WMid);
            // Merchant ��� Invoice
            if ($method=="invc") {
               $terms .= $WMid;
            } elseif ($method=="wmt") {               $terms .= "Merchant \r\n";
            } else {               $errWMid = "�� ������ ������ ������!";
            }
         break;
      case "MBU":
            $errI = VerifyP("mbu", "$MBAcc");
            $terms .= "MoneyBookers: $MBAcc\r\n";
            // �������� ����������� MoneyBookers
			//list($res, $data) = MB_CheckMail($MBAcc);
			//if ($res) {
			//    $terms.= "MoneyBookers reg data:";
			//    foreach ($data as $v) $terms.= $v."\r\n";
			//} else {
			//    $errI = "������: ���� MoneyBookers $MBAcc �� ���������������.\r\n";
	        //}
         break;
      case "USD":
      case "EUR":
      case "NUAH":
            $errI = VerifyP("city", $city);
            $errI.= VerifyP("fio", "$lastname $firstname $midlename");
            $errI.= VerifyP("passport", "$passport");
            $terms .= "���: $lastname $firstname $midlename\r\n";
            $terms .= "���: $passport\r\n";
            $terms .= "�����: $city \r\n";
            $terms .= "���: $phone\r\n";
         break;
      case "UKSH":
            // Ukash Redemtion Term:
            // Minimum Voucher Value: 5 GBP, 5 USD, 5 Euro
            // Maximum Voucher Value: 500 GBP, 750 USD, 750 Euro
            // All customers who redeem vouchers above the Maximum Voucher Value should visit one pf our offices to show their passport...
            $errI = VerifyP("uksh_num", $vNumber);
            $errI.= VerifyP("uksh_val", $vValue);
            if ($InSum > 750) {                $errI.= "����� ����� <b>����� 750 &euro;</b> �������� ������ ����� �������������� � ������ ������.<br />";
                $errI.= "��� ���������� ������ ���������� ������������ ��������, �������������� ��������.<br />";
            }
            $terms .= "Ukash voucher: $vNumber\r\n";
            $terms .= "Value: $vValue\r\n";
            $Purse_From = "$vNumber:$vValue";
         break;
      case "YAD":
            $errI = VerifyP("yandex", $yandexAcc);
            $terms.= "Yandex RUR: $yandexAcc\r\n";
            $Purse_From = $yandexAcc;
         break;
      case "P24US":
      case "P24UA":
            $errI = VerifyP("fio", "$lastname $firstname $midlename");
            $errI.= VerifyP("bankAcc", "$p24account");
            if ($inmoney=="P24US") {                $terms.= "������24 USD: $p24account\r\n";
            } else {                $terms.= "������24 ���: $p24account\r\n";
            }
            $terms .= "���: $lastname $firstname $midlename\r\n";
            $terms .= "���: $phone\r\n";
            $Purse_From = $p24account;
         break;
   }
   $terms .= "\r\n���� ���������� ������:\r\n";
   if (empty($WMid)) $WMid="";
   else $WMid_In = $WMid;
   switch ($outmoney) {
      case "WMZ":
            $terms .= $Z;
            $errP = VerifyP ("z", $Z);
            $Purse_To = $Z;
         break;
      case "WME":
            $terms .= $E;
            $errP = VerifyP ("e", $E);
            $Purse_To = $E;
         break;
      case "WMR":
            $terms .= $R;
            $errP = VerifyP ("r", $R);
            $Purse_To = $R;
         break;
      case "WMU":
            $terms .= $U;
            $errP = VerifyP ("u", $U);
            $Purse_To = $U;
         break;
      case "MBU":
            $errP = VerifyP("mbu", $MBAcc);
            $terms .= "MoneyBookers: $MBAcc\r\n";
            // �������� ����������� MoneyBookers
			/*list($res, $data) = MB_CheckMail($MBAcc);
			if ($res) {
			    $terms.= "MoneyBookers reg data:";
			    foreach ($data as $v) $terms.= $v."\r\n";
			} else {
			    $errP = "������: ���� MoneyBookers $MBAcc �� ���������������.\r\n";
	        }*/
            $Purse_To = $MBAcc;
         break;
      case "USD":
      case "EUR":
      case "NUAH":
            $errP = VerifyP("fio", "$lastname $firstname $midlename");
            $terms .= "���: $lastname $firstname $midlename\r\n";
            $terms .= "���: $passport\r\n";
            $terms .= "�����: $city\r\n";
            $terms .= "���: $phone\r\n";
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {                // ��� ������ Webmoney �� �������� �� 15.04.2010�. �������� ��������� ������� �� X19                $resCheckUser = XMLCheckUser(1, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"","","","","","1");
                if ($resCheckUser['retval'] != 0) $errP = $resCheckUser['retdesc'];
            }
            $Purse_To = "";
         break;
      case "UKSH":
            $terms .= "Ukash EUR";
            $Purse_To = "Ukash";
            if ($OutSum > 1000) {                $errP = "����� ������ ����� &euro;1000 ���������� �� ������������ � ��������������.";
                break;
            }
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {
                // 22.11.2010 - ������ ������ �������� WM<->Ukash
                $errP = "��������� �������! ���������� �������� �� ������ Ukash - Webmoney ��������� �������� Webmoney.<br />".
                        "��� ������������ �������� Ukash �� �������� ��������� � ���������������.<br />".
                        "�������� � ICQ ��������������� (��� ���� ����������������):<br>".
                        "+380 (97) 479-00-08<br>".
                        "+380 (95) 649-00-08<br><br>".
                        //"+380 (73) 439-00-08<br><br>".
                        "<b>ICQ 637139590</b> <img src=\"img/icq.gif\" border=0><br><br>";
                break;
            }
            /*if (($inmoney=="WMU")&&$WMid!="") {
                // ��� ������ Webmoney �� Ukash �� �������� �� 15.04.2010�. �������� ���������
                $resCheckWMPassport = XMLGetWMPassport($WMid);
                if ($resCheckWMPassport['retval'] != 0) {                    if (isset($resCheckWMPassport['retdesc'])) {                        $errP = $resCheckWMPassport['retdesc'];
                    } else {                        $errP = "������ ��������� WMid $WMid �� ��������.";
                    }
                } else {                    if ($resCheckWMPassport['recalled'] == 1) {                        $errP = "��� �������� ������� � ��� ������ ������������ ��������� ����������.";
                    } else {                        $yesterday = date ("Y-m-d H:i:s", time()-86400);
                        $sqlUkashSum = "SELECT SUM(GOOD_AMOUNT) AS sumUkash FROM contract
                                         INNER JOIN goods ON (contract.GOOD_ID = goods.GOODS_ID)
                                         WHERE wmid = '$WMid' AND contract.Delivery_Status = 1 AND goods.GOODS_NAME = 'UKSH' AND
                                         contract.Purchase_Order_Time BETWEEN '$yesterday' AND NOW()";
                        OpenSQL ($sqlUkashSum, $rows, $res);
                        $row = NULL;
                        GetFieldValue ($res, $row, "sumUkash", $sumUkash, $IsNull);
                        if (($resCheckWMPassport['att']==110) AND (($sumUkash+$OutSum)> 200)) {                            // ����������
                            $errP = "����� ������� Ukash ��� ������ ��������� �� ����� ��������� 200 EUR � �����.";
                            break;
                        }
                        if (($resCheckWMPassport['att']>=120) AND (($sumUkash+$OutSum)> 500)) {                            // ���������, ������������, �������� ...
                            $errP = "����� ������� Ukash ��� ������ ��������� �� ����� ��������� 500 EUR � �����.";
                            break;
                        }
                        // �������� ����� ���� �������
                        $errP = VerifyP("AuthWMid", $WMid);
                    }
                }
            }*/
         break;
      case "BFU":
            $errP = VerifyP("fio", "$lastname $firstname $midlename");
            $terms .= "���: $lastname $firstname $midlename\r\n";
            $terms .= "���: $passport\r\n";
            $terms .= "Betfair $BFacc";
            $Purse_To = $BFacc;
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {
                // ��� ������ Webmoney �� �������� �� 15.04.2010�. �������� ��������� ������� �� X19
                $resCheckUser = XMLCheckUser(1, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"","","","","","1");
                if ($resCheckUser['retval'] != 0) $errP = $resCheckUser['retdesc'];
            }
         break;
      case "PSU":
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {
                $errP = VerifyP("fio", "$lastname $firstname $midlename");
                $terms .= "���: $lastname $firstname $midlename\r\n";
                $terms .= "���: $passport\r\n";
                // ��� ������ Webmoney �� �������� �� 15.04.2010�. �������� ��������� ������� �� X19
                $resCheckUser = XMLCheckUser(1, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"","","","","","1");
                if ($resCheckUser['retval'] != 0) $errP = $resCheckUser['retdesc'];
            }
            $terms .= "Pokerstars $PSacc";
            $Purse_To = $PSacc;
         break;
      case "YAD":
            $errP = VerifyP("yandex", $yandexAcc);
            $terms .= "Yandex RUR: $yandexAcc\r\n";
            $Purse_To = $yandexAcc;
         break;
      case "PCB":
            // �������� ������ ��� �������� � ���� (���,����� ����� ��������,��� - 10 ����,��� ����� (���) - 6 ����,
            // ��� ������ - 8 ����,����� ����� ��� ����� �����)
            $errP = VerifyP("fio", "$lastname $firstname $midlename");
            $errP.= VerifyP("passport", "$passport");
            $errP.= VerifyP("mfo", "$mfo");
            $errP.= VerifyP("inn", "$inn");
            $errP.= VerifyP("egrpou", "$egrpou");
            $errP.= VerifyP("bankAcc", "$cardAcc");
            $terms.= "���������: $lastname $firstname $midlename\r\n";
            $terms.= "���: $passport\r\n";
            $terms.= "���: $inn\r\n";
            $terms.= "���: $mfo\r\n";
            $terms.= "������: $egrpou\r\n";
            $terms.= "����� �����(�����): $cardAcc\r\n";
            if ($card_bank=="cardAcc")
                $terms.= "���: �����\r\n";
            else
                $terms.= "���: ����\r\n";
            $Purse_To = $cardAcc;
         break;
      case "P24US":
      case "P24UA":
            $errP = VerifyP("fio", "$lastname $firstname $midlename");
            $errP.= VerifyP("bankAcc", "$p24account");
            if ($outmoney=="P24US") {
                $terms.= "������24 USD: $p24account\r\n";
            } else {
                $terms.= "������24 ���: $p24account\r\n";
            }
            $terms .= "���: $lastname $firstname $midlename\r\n";
            $terms .= "���: $phone\r\n";
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {
                // ��� ������ Webmoney �� ������24 �� �������� �� 15.04.2010�. �������� ��������� ������� �� X19
                $resCheckUser = XMLCheckUser(4, $inmoney, $InSum, $WMid, "",$lastname,$firstname,"����������","",$p24account,"","","1");
                if ($resCheckUser['retval'] != 0) $errP = $resCheckUser['retdesc'];
            }
            // ��������� ��������� ����� �� ������24 � ����������� �������� �� ����� �������
            $p24 = new matrix();
            $balance_p24 = $p24->getBalance();
            if ($balance_p24 < $OutSum) {
                $errP.= "���� ����� ��������� ��������� �� ������ ������. ���������� ����� ��� ��������� � ���������������.";
            }

            $check_result = $p24->checkCard($p24account);
            if (!$check_result[0]) {
                $errP.= $p24->getErrMessage();
            } else {                if ($OutSum > $check_result[3]) {                    $errP.= "����� ������ ��������� ����������� ��������� ����� �� ����� ����� (".$check_result[3]." ���.).";
                }
            }
            $Purse_To = $p24account;
         break;
      case "GMU":
            $errP = VerifyP("fio", "$lastname $firstname $midlename");
            $errP.= VerifyP("passport", "$passport");
            $errP.= VerifyP("bankAcc", "$GMaccount");
            $terms.= "Globalmoney ���: $GMaccount\r\n";
            $terms .= "���: $lastname $firstname $midlename\r\n";
            $terms .= "���: $phone\r\n";
            if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&$WMid!="") {
                // ��� ������ Webmoney �� �������� �� 15.04.2010�. �������� ��������� ������� �� X19
                $resCheckUser = XMLCheckUser(1, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"","","","","","1");
                if ($resCheckUser['retval'] != 0) $errP.= $resCheckUser['retdesc'];
            }

            $Purse_To = $GMaccount;
         break;
   }
   // X19 ���� � �������
   if (in_array($inmoney, array("NUAH","USD","EUR"))&&in_array($outmoney, array("WMZ","WME","WMR","WMU"))) {        // ��� ����� Webmoney �� �������� �� 15.04.2010�. �������� ��������� ������� �� X19
        $resCheckUser = XMLCheckUser(1, $outmoney, $OutSum, $WMid, $passport,$lastname,$firstname,"","","","","","2");
        if ($resCheckUser['retval'] != 0)
            $errP = $resCheckUser['retdesc'];
        else
            $terms.= "\r\n$WMid\r\n";
   }
   if (in_array($inmoney, array("P24US","P24UA"))&&in_array($outmoney, array("WMZ","WME","WMR","WMU"))) {
        // ��� ����� Webmoney � ����������� �� �������� �� 15.04.2010�. �������� ��������� ������� �� X19
        $resCheckUser = XMLCheckUser(4, $outmoney, $OutSum, $WMid, "",$lastname,$firstname,"����������","",$p24account,"","","2");
        if ($resCheckUser['retval'] != 0)
            $errP = $resCheckUser['retdesc'];
        else
            $terms.= "\r\n$WMid\r\n";
   }
   // ��������� WM-WM, ����� ������ ������ ��������� WMid
   if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&in_array($outmoney, array("WMZ","WME","WMR","WMU"))&&($WMid_In!=$WMid)) {
        // ��� ���������� Webmoney �� �������� �� 15.04.2010�. �������� ��������� ������� (������ ���� ���� ��������)
        $errP = "WMID ���������� �� ��������� � WMID �����������.";
   }
   // 03.03.2015 - ��������� WM-WM ������ ���� �� ������ ��������
   if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&in_array($outmoney, array("WMZ","WME","WMR","WMU"))) {
        $errP = "��������� �������� ��������.";
   }
   // 22.11.2010 Ukash -> WM
   if ((($inmoney=="UKSH")&&in_array($outmoney,array("WMZ", "WME", "WMR", "WMU")))||
       (($outmoney=="UKSH")&&in_array($inmoney,array("WMZ", "WME", "WMR", "WMU"))))
   {
       // 22.11.2010 - ������ �������� WM<->Ukash ����� �������� �������
       //HTMLError("<b>� 22.11.2010�. ������ �������� ��������� �������� Webmoney.</b><br />����� ������������� �� �����!<br />");
   }
   /*if (($inmoney=="UKSH")&&in_array($outmoney,array("WMZ", "WME", "WMR", "WMU"))) {
       // 22.11.2010 - ������ �������� WM<->Ukash ����� �������� �������
       $errP.= VerifyP("AuthWMid", $WMid);
   }*/
   if (in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&($outmoney=="PCU")) {
        // ��� ������ Webmoney �� ����� ��� ���� �� �������� �� 15.04.2010�. �������� ��������� ������� � ��������(�����) �� X19

        if ($card_bank=="bankAcc") {
            $resCheckUser = XMLCheckUser(3, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"���������",$cardAcc,"","","","1");
        } else {            $resCheckUser = XMLCheckUser(4, $inmoney, $InSum, $WMid, $passport,$lastname,$firstname,"���������","",$cardAcc,"","","1");
        }
        if ($resCheckUser['retval'] != 0)
            $errP = $resCheckUser['retdesc'];
        else
            $terms.= "\r\n$WMid\r\n";
   }
   if ((in_array($inmoney, array("WMZ","WME","WMR","WMU"))&&($outmoney=="YAD")) ||
       (($inmoney=="YAD")&&in_array($outmoney, array("WMZ","WME","WMR","WMU")))){        if ($inmoney=="YAD") {            // ���� WM � �������
            $direction = "2";
        } else {            // ����� WM �� �������            $direction = "1";
        }
        // ��� ������ Webmoney �� ������.������ �� �������� �� 15.04.2010�. �������� �������� ����� ������.����� �� X19
        //if (getenv('REMOTE_ADDR')!="82.207.125.214")
            $resCheckUser = XMLCheckUser(5, $inmoney, $InSum, $WMid, "","","","","","","money.yandex.ru ",$yandexAcc,$direction);
        //else
        //    $resCheckUser['retval']=0; // ��� ������� ��������� ������

        if ($resCheckUser['retval'] != 0)
            $errP = "<br />������ ��� �������� X19.<br />��������� �������� ������ ����� $yandexAcc � �������� Webmoney (WMid $WMid) �� �������� <a href=\"https://banks.webmoney.ru\" target=\"_BLANK\">https://banks.webmoney.ru</a><br />".$resCheckUser['retdesc'];
        else
            $terms.= "\r\n$WMid\r\n";
   }

   if ((empty($errI))&&(empty($errP))&&(empty($errWMid))) {
      // �������� ������ � ����
      // $WMid ����������� � $Purse_To ������� ���������� ��������� �����
      $PaymentSum       = $InSum;
      $PaymentCurrency  = $inmoney;
      $PaymentAccount   = (isset($Purse_From))? $Purse_From : "";
      $PaymentID        = "AU-".$HTTP_SERVER_VARS{'UNIQUE_ID'};
      $ShortDescription = "���� $InSum $inmoney, ����� $OutSum $outmoney.";
      $ContractTerms    = $terms;
      $GoodsAmountReq   = $OutSum;
      $GoodsName        = $outmoney;
      $encode_mail      = base64_encode ($mail);
      $ip               = getenv("REMOTE_ADDR");

      $sqlID = "SELECT GOODS_ID, GOODS_AMOUNT FROM goods where GOODS_NAME='$GoodsName'";
      OpenSQL ($sqlID, $row, $res);
      $row = NULL;
      GetFieldValue ($res, $row, "GOODS_ID", $GoodsID, $IsNull);
      if ($row) {
         GetFieldValue ($res, $row, "GOODS_AMOUNT", $GoodsAmount, $IsNull);
         if ($GoodsAmountReq <= $GoodsAmount) {          if (empty($WMid)) $WMid = "";
            $sql = "INSERT INTO Contract
                       (PAYMENT_ID,
                        SHORT_DESCRIPTION,
                        CONTRACT_TERMS,
                        PURCHASE_ORDER_TIME,
                        PAYMENT_CURRENCY,
                        PAYMENT_SUM,
                        PAYMENT_ACCOUNT,
                        GOOD_ID,
                        GOOD_AMOUNT,
                        wmid,
                        MAIL,
                        IP,
                        Purse_To)
                    VALUES (
                        '$PaymentID',
                        '$ShortDescription',
                        '$ContractTerms',
                        NOW(),
                        '$PaymentCurrency',
                        '$PaymentSum',
                        '$PaymentAccount',
                        '$GoodsID',
                        '$GoodsAmountReq',
                        '$WMid',
                        '$encode_mail',
                        '$ip',
                        '$Purse_To'
                    )";
            ExecSQL ($sql, $row);
            if ($row) {
               // ����� ������ � ���������������� �������
               $ContractID = round(mysql_insert_id() * pi());
               // ������ � ����������������� ��� ������������ �������� ?
               if (($inmoney == "WME")||($inmoney == "WMZ")||($inmoney == "WMR")||($inmoney == "WMU")||($inmoney == "YAD")) {
                  // WME, WMZ, WMR, WMU, YAD - ������������ �����
                  // ������ �������! ����������� ���������� ������.
                  $message = "������ ������� � ���������� ��������������! ����������� ���������� ������ ������.";
                  if (($outmoney == "BFU")||($outmoney=="PSU")) {                      $message.= "<br />��� ���������� ������ ���������� � ��������������� �� ICQ: 637139590<br />".
                                 "��� ���������:<br />".
                                 "+380 (97) 479-00-08 ��������<br />".
                                 "+380 (95) 649-00-08 ���<br />";
                                 //"+380 (73) 439-00-08 Life:)";
                  }
                  $Pay = true;  // ��������� ������ ����� merchant
                  // URL ��� ������ �� ������ ������ �����
                  $mail_msg = "��� ������ ����� ����� ������, ��������� ����� �� ������ �� ������ $domain/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::")."\r\n";
                  if (($outmoney == "BFU")||($outmoney=="PSU")) {
                     $mail_msg.= "��� ���������� ������ ���������� � ��������������� �� ICQ:\r\n";
                     $mail_msg.= "637139590\r\n";
                     $mail_msg.= "��� ���������:\r\n";
                     $mail_msg.= "+380 (97) 479-00-08\r\n";
                     $mail_msg.= "+380 (95) 649-00-08\r\n";
                     //$mail_msg.= "+380 (73) 439-00-08\r\n";
                  }
               } elseif ($inmoney =="MBU") {
                  $message = "������ �������! ����� ����������� � ������ ������. ��� ���������� ������ Moneybookers USD ��������� � ���������������.";
                  $Pay = false;
                  // ����������� � ����������������� �������� ������
                  $mail_msg = "��� ���������� ������ Moneybookers USD ��������� � ���������������. ��������, ICQ � e-mail �� ������� �� �������� http://www.okwm.com.ua/contacts.asp\r\n";
               } elseif ($inmoney =="UKSH") {
                  $message = "������ ������� � ���������� �� ���������!<br />�������� �������� ������� Ukash.";
                  $Pay = true;
                  // URL ��� ������ �� ������ ������ �����
                  $mail_msg = "��� ������ ����� ����� ������, ��������� ����� �� ������ �� ������ $domain/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::")."\r\n";
               } elseif (($inmoney =="P24US")||($inmoney =="P24UA")) {
                  // ������ � ������24
                  $message = "������ ������� � ���������� ��������������! ����� ������ $ContractID.
                  �� �������� ���� e-mail ���� ������� ������ � ��������������.<br />
                  ��� ��������� ���������� ������ � ���������� ������ ��������� � ���������������� ����� � ������� �����:<br />
                  ������ ��� � 10-00 �� 19-00, �������� � 12-00 �� 14-00.<br />
                  ICQ 637139590<br />
                  +380 (97) 479-00-08<br />
                  +380 (95) 649-00-08<br />
                  +380 (73) 439-00-08<br />
                  <br>";
                  $Pay = false;
                  // ����������� � ����������������� �������� ������
                  $mail_msg = "��� ��������� ���������� ������ � ���������� ������ ��������� � ���������������� ����� � ������� �����:\r\n";
                  $mail_msg.= "������ ��� � 10-00 �� 19-00, �������� � 12-00 �� 14-00.\r\n";
                  $mail_msg.= "637139590\r\n";
                  $mail_msg.= "+380 (97) 479-00-08\r\n";
                  $mail_msg.= "+380 (95) 649-00-08\r\n";
                  $mail_msg.= "+380 (73) 439-00-08\r\n";
               } else {
                  // �������� ������������ ��� ������ �������
                  $message = "������ �������! ����� ������ $ContractID. �� �������� ���� e-mail ���� ������� ������ � ��������������. �������� ������ � ����� �����������������.<br />
                  ��� ������ �������� ����� ������ �������������. ������ ���������������� � ����� �� ������ �� ������� �� �������� <a href=\"http://www.okwm.com.ua/contacts.asp\" target=\"_BLANK\">\"��������\"</a><br>";
                  $Pay = false;
                  // ����������� � ����������������� �������� ������
                  $mail_msg = "���� ��� � �����������������. ������ ���������������� � ����� �� ������ �� ������� �� �������� http://www.okwm.com.ua/contacts.asp\r\n";
               }
               // send mail to admin
               $title = "�������� ������ $ContractID.";
               $msg = "$terms\r\n � ������: $PaymentSum ".ConvertName($inmoney)."\r\n";
               $msg.= "� ������: $GoodsAmountReq ".ConvertName($outmoney)."\r\n";
       		   $msg.= "e-mail: $mail\r\n";
               $msg.= "��������� ����� ����� �� ������ $domain/resultpay.asp?act=".substr($PaymentID, 3).EvalHash("$PaymentID::")."\r\n";
               $from = $HTTP_SERVER_VARS['SERVER_ADMIN'];
               $res = SendMail ($from, $title, $msg);
               // send mail to client
               if ($mail!=""){
                  $to = $mail;
                  $client_title = "��������� ������ okwm.com.ua";
                  $client_message = "������������!\r\n���� ������ �������. ����� ������ $ContractID\r\n\r\n";
                  $client_message.= "� ������: $PaymentSum ".ConvertName($inmoney)."\r\n";
                  $client_message.= "� ������: $GoodsAmountReq ".ConvertName($outmoney)."\r\n";
                  if (isset($prot)) $client_message.= "��� ���������: $prot."."\r\n";
                  $client_message.= $mail_msg;
                  $client_message.= "�������, ��� ��������������� ������ ��������.\r\n\r\n";
                  $client_message.= "� ���������,\r\n������������� www.okwm.com.ua\r\n";
                  SendMail ($from, $client_title, $client_message, $to);
               }
            } else {
               // �������� ���������� �� ������ ��������������!
               $message = "������ �� �������!<br> �������� ���������� �� ������ ��������������!<br>";
            }
         } else {
            // �������� ����� ��������� ����������.
            $message = "������ �� �������!<br>�����, ������� �� ������ ��������, ��� � �������.<br>���������� ������ ������� �����.<br>";
         }
      } else {
         // ��������� ������ �������� �� ������������.
         $message = "������ �� �������!<br> ��������� ������ �������� �� ������������.";
      }
   } else {
      $action = "sell";
   }
} else {
   // ������������ ���� �� ��������
   // ����� 15 ��� �������������� ������� �� ������� ��������
   HTMLHead ("������ �� �������� ���������� ������", "", "");
   HTMLAfteHead_noBanner("������ � ���������� ������");
   HTMLError("������ �� �������!");
   echo <<<EOT

<p>
�� ������ ������� �����, ������ �� �����-�� ������� �������� ������ � ���� ������ �� �������!<br>
</p>
<p>

���������� ��� ��� ��� �������� <a href="/contacts.asp">��������������</a> ����� ���
��������� ������ ������.<br>
������� ����������!
</p>
<p>
��������� <a href="$domain/">�� ������� ��������>>></a>
</p>

EOT;

   HTMLAfteBody ();
   HTMLTail();
   exit;
}

// ����������� ������� ������ � ���������
$sql_reserv = "SELECT GOODS_ID, GOODS_AMOUNT FROM goods where GOODS_NAME='$outmoney'";
OpenSQL ($sql_reserv, $rows, $res);
if ($rows) {
    $row = NULL;
    GetFieldValue ($res, $row, "GOODS_AMOUNT", $MaxOutSum, $IsNull);
    $MaxOutSum = (in_array($outmoney,array("WMZ","WME","WMR","WMU")))? (floor(($MaxOutSum - $MaxOutSum*0.008)*100))/100 : $MaxOutSum;
    $ReservMsg = "����������� ��������� ����� � ���������: $MaxOutSum ".ConvertName($outmoney);
}

// Create HTML code
HTMLHead ($title_page);
HTMLAfteHead_noBanner("���� ������ ��� ������");

if (!empty($action)) {
echo <<<EOT
<script language="JavaScript">
  var key_2_press=new Image();
  key_2_press.src='$domain/img/keys/key_2_press.gif';

  function Verify () {      if (document.insert.agreement) {
        if (document.insert.agreement.checked) {
           document.insert.submit ();
        } else {
		   if ((document.insert.inmoney.value == "USD")||
		       (document.insert.inmoney.value == "EUR")||
		       (document.insert.outmoney.value == "USD")||
		       (document.insert.outmoney.value == "EUR")) {
	           alert ("�� �� ����������� ������� � ������!");
	       } else {	           alert ("�� �� ����������� ������!");
	       }
        }
      } else {          document.insert.submit ();
      }  }
</script>
$CorrectSum<br />
$ReservMsg<br /><br />
<form enctype="multipart/form-data" method="post" name="insert" action="$domain/specification.asp">

<input type="hidden" name="title_page" value="$title_page">
<input type="hidden" name="InSum" value="$InSum">
<input type="hidden" name="OutSum" value="$OutSum">
<input type="hidden" name="inmoney" value="$inmoney">
<input type="hidden" name="outmoney" value="$outmoney">
EOT;
   // ����� ������, ���� ����� ������ � ���������
   if (isset($town)) {
       // �� ������� �������� ��� ��������� ����� � ���������� $town
       echo "\n<input type=\"hidden\" name=\"city\" value=\"$town\">\n";
   } else {
       // �� ������ �������� ������������� ����� � ���������� city
       if (isset($city)) echo "\n<input type=\"hidden\" name=\"city\" value=\"$city\">\n";
       // ����������� ������ ����� �� ������ � ���������� city
       switch ($city) {
           case "����":
              $office_addr = ADDR_Kiev;
              break;
           case "��������������":
              $office_addr = ADDR_Dnepr;
              break;
           case "������":
              $office_addr = ADDR_Odessa;
              break;
       }
   }
   // ������, ���� ����
   if (isset($errWMid)) HTMLError ($errWMid);
   if (isset($errI)) HTMLError ($errI);
   if (isset($errP)) HTMLError ($errP);
   // 22.11.2010 Ukash <-> WM
   if ((($inmoney=="UKSH")&&in_array($outmoney,array("WMZ", "WME", "WMR", "WMU")))||
       (($outmoney=="UKSH")&&in_array($inmoney,array("WMZ", "WME", "WMR", "WMU"))))
   {
       // 22.11.2010 - ������ �������� WM<->Ukash ����� �������� �������
       //HTMLError("<b>� 22.11.2010�. ������ �������� ��������� �������� Webmoney.</b><br />����� ������������� �� �����!<br />");
   }

   // ��������� ��� ������
   InDetails ($inmoney);
   // ��������� ��� ����������� �����
   OutDetails ($outmoney);
   // e-mail
   if (!isset($mail)) $mail="";
echo <<<EOT
<p>e-mail:
<input type=text name="mail" value="$mail" maxlength=40 size=40>
</p>
EOT;
   //if (!isset($vip_flag)) $vip_flag="";
   //<input type="hidden" name="s" value="$vip_flag">
   // ���� ����/����� Webmoney, �� ����� �������������� � �������� ������ �� X19
   if ((in_array($inmoney,array("NUAH","USD","EUR","P24US","P24UA"))&&in_array($outmoney, array("WMZ","WME","WMR","WMU")))||
       (in_array($inmoney,array("WMZ","WME","WMR","WMU"))&&in_array($outmoney, array("NUAH","USD","EUR","PCB","P24US","P24UA")))) echo $WarningX19;

   // ��������� ������
   echo <<<EOT
<input type="hidden" name="signup" value="��������� ������">
<img src="$domain/img/keys/key_2_symple.gif" width="136" height="19"
     onMouseOut  = "this.src = '$domain/img/keys/key_2_symple.gif';"
     onMouseOver = "this.src =  key_2_press.src;"
     onClick     = "Verify();">
<br>

</form>

EOT;
} else {
    if (!empty($message)) {
        echo "$message <br>\n";
        echo "$CorrectSum<br>\n";
        if ($Pay) {           if (($inmoney == "WME")||($inmoney == "WMZ")||($inmoney == "WMR")||($inmoney == "WMU"))
	        if ($method=="wmt") {		        // ���������� �������� ����� �� ����������� �� 14.01.2006 �.
		        $descr_merchant = "$ContractID.".chr(13);
		        $descr_merchant.= "$InSum $inmoney => $OutSum $o. ";
		        if (($outmoney == "NUAH")||($outmoney == "USD")||($outmoney == "EUR")) {
		           // ����� �� ��������
		           if (isset($city)) $descr_merchant.= "$city ";
		           $descr_merchant.= "$lastname $firstname $midlename $passport.".chr(13);
		        } elseif (($outmoney == "BFU")||($outmoney == "PSU")||($outmoney == "PCB")) {
		           // ���������� Betfair ��� Pokerstars ��� ���������
		           $descr_merchant.= "$lastname $firstname $midlename $passport.".chr(13);
		           $descr_merchant.= ConvertName($outmoney)." $Purse_To ";
		        } elseif (($outmoney == "P24US")||($outmoney == "P24UA")) {
		           // ����� Webmoney �� ����������
		           $descr_merchant.= "$lastname $firstname $midlename.".chr(13);
		           $descr_merchant.= ConvertName($outmoney)." $Purse_To (����������)";
		        } elseif ($outmoney == "YAD") {
		           // ���������� Yandex RUR
		           $descr_merchant.= "������.������ $Purse_To ";
		        } elseif ($outmoney == "GMU") {
		           // ����� Webmoney �� VISA Globalmoney UAH
		           $descr_merchant.= "Globalmoney $Purse_To ";
		        } else {
		           // �������������� �����
		           $descr_merchant.= "����(�������) ���������� $Purse_To ";
	            }
	            FormWMT($PaymentID, $InSum, $inmoney, $title_page, $ContractID, $descr_merchant);
            } else {
                require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/wm_invc.asp");
            }
            if ($inmoney == "YAD")
                FormYMoney($PaymentID, $InSum, $title_page, $ContractID);
            if ($inmoney == "UKSH")
                require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/uk_paychk.asp");
        } else {
           // ����� 15 ��� �������������� ������� �� ������� ��������
           //require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/js/gotomain.js");
           include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/google_awords.inc");
        }
    }
}

HTMLAfteBody();
HTMLTail ();
?>