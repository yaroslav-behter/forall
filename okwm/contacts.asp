<?php
#--------------------------------------------------------------------
# OKWM contacts page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;
$WMid = WM_ID;

/*

// ICQ Status Indicator - 637139590
$curl=curl_init();
curl_setopt($curl, CURLOPT_URL, "http://status.icq.com/online.gif?icq=637139590&img=27");
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
$stat=curl_exec($curl);
curl_close($curl);
if (strstr($stat, "online1")) { $status_637139590 = "Online"; }

*/
// ��������
$title = "�������� ��������������� OKWM ��� ������, ����� � ������ WebMoney, Ukash, Pokerstars, Betfair";
$Keywords = "�������� Webmoney, ���� ������ wmz, ������ WMZ, ������� WMZ, wmz �� �������, WMZ �� ��������, ������ wm, WMZ, WME, ������� WebMoney, �����, ��������, ����������� ������";
$Description = "������� � ������ �������� WebMoney, Ukash, Pokerstars, Betfair � �����, ������, ���������������.";
HTMLHead ($title, $Keywords, $Description);
echo <<<EOT

	 <tr><td></td><td id="phl"><img width="1" height="4" alt="" src="$http/img/0.gif" /></td>
	     <td id="phr"><img width="210" height="4" alt="" src="$http/img/0.gif" /></td><td></td>
	 <td rowspan="5" class="right_banners">
EOT;
    if (!isset($HTTP_SERVER_VARS['HTTPS'])) EchoBaners ();
    echo <<<EOT
	 </td>
	 </tr>
	 <tr><td class="lsh"></td><td id="pbl">
       <h1>��������</h1>
	 </td>
	 <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
	 </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="news">
       <p>
       ������� � ICQ ��������������� (��� ���� ����������������):<br>
       +380 (97) 479-00-08 ��������<br>
       +380 (95) 649-00-08 ���<br><br />
       <!--+380 (73) 439-00-08 Life:)<br><br-->

       <a href="http://web.icq.com/whitepages/add_me?uin=637139590&action=add" title="�������� � ������ ���������"> <b>ICQ 637139590</b> <img src="img/icq.gif" border=0></a> �����<br>
       Skype: okwm-info <script type="text/javascript" src="http://download.skype.com/share/skypebuttons/js/skypeCheck.js"></script>
       <a href="skype:okwm-info?call"><img src="http://mystatus.skype.com/bigclassic/okwm-info" style="border: none;" width="91" height="22" alt="������ OKWM" /></a><br />
       <small><b>��������!</b> ������ Skype: <b>okwm-info</b>. (����� � �����) � <b>okwm_info</b> (������ �������������) - ���������!</small><br />
       <a href="https://twitter.com/OKWMcomua" class="twitter-follow-button" data-show-count="false" data-lang="ru">�������� @OKWMcomua</a>
       <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
       <br /><br />
       WMId $WMid<br>
       �������� ��������: <a href="https://passport.webmoney.ru/asp/CertView.asp?wmid=179209804904" target="_blank">
       ����� ������� ����������</a><br />
       ����� ������� � �������� <a href="http://megastock.ru/searchres.aspx?search=okwm.com.ua">��������</a> 9460<br>
       e-mail: <a href="mailto:admin@okwm.com.ua"><img src="$http/img/admin.png" alt="����� WMZ �� ��������" title="��������� ������ ��������������"></a><br /><br />
       <b>���� � ��� ���� ����������� ��� ��������� �� ������ ������ �������, ���������� ������� <a href="/policy.asp">����</a>.</b>
       </p>
       <hr>
       <p>
       <!-- ������� -->
       <a href="$http/contacts/map_kiev.asp" title="���������" target="_blank">�. <b>����, �������</b></a><br>
       ��.������� ������������� �.65, 3� ����, ��.355. ������� ����� &quot;�����������&quot;.<br>
       ����������� - ������� � 10<sup><u>00</u></sup> �� 18<sup><u>00</u></sup>,<br>
       �������� ���: ������� � �����������.<br><br>


       <a href="$http/contacts/map_dp.asp" title="���������" target="_blank">�. <b>��������������, �������</b></a><br>
       ��. ��������� �������� (����������), 7 2� ����, ����. 215.<br>
       ����������� - ������� � 12<sup><u>00</u></sup> �� 18<sup><u>00</u></sup>,<br>
       �������� ���: ������� � �����������.<br><br>


       <a href="$http/contacts/map_od.asp" title="���������" target="_blank">�. <b>������, �������</b></a><br>
       ������������ ��������, ��� 2�, ���� 10.<br>
       ����������� - ������� � 12<sup><u>00</u></sup> �� 18<sup><u>00</u></sup>,<br>
       �������� ���: ������� � �����������.<br><br>
       </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
?>