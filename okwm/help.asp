<script language="PHP">
#--------------------------------------------------------------------
# OKWM help page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;

// ��������
$title = "������ � ������� ������ ������� � ���������, ����, ����� WebMoney, Pokerstars, Betfair";
$Keywords = "�������� Webmoney, ���� ������ wmz, ������ WMZ, ������� WMZ, wmz �� �������, WMZ �� ��������, ������ wm, WMZ, WME, ������� WebMoney, �����, ��������, ����������� ������";
$Description = "������� � ������ �������� WebMoney, Betfair, Pokerstars � �����, ������, ���������������.";
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
      <div id="help">
    <p>
    <div align="center"><b>��������� ������� ������� OKWM.com.ua!</b></div>
    </p>
    <p align="justify">
    ������ ��� �������� �������� �� <b>��������� ������ ������</b> ������ ��������� ������ � ������������ �
    <a href="https://www.megastock.ru/Doc/exchange_rules.aspx" target="_blank">���������� � ������� ������������� ������� WebMoney Transfer ���
    �������� �������� � ����������� �������������</a> �� 15 ������ 2010�. ���� �������� �������� ����������, ����������� ���
    �����/������ ������� WebMoney ��� ������ ������ �������.
    <ul>
    <li>�������/�������� �������� WebMoney ������ �������� (WMZ, WME, WMR, WMU) ����� ����� ������ �������� ��������� ��� ������� ��������, ��� ������� ������� ���.
    �� ���� ������ � ��������� (��� � ����� ����� ��������) � ������ ������� �� ������ ������ ���������.
    <li>��� WMID ������ ����� �������� �� ���� ����������� (�.�. ��� ������� ��������� ���������� ����� ������������� �� �����).
    ���������� �������� �������� ��������� ��������� ������� WebMoney Transfer ����� ����� �� ���������� ������. � ������ WM-���������� �
    ��������� �� ��������� �� ������ ������������ �� <a href="http://passport.webmoney.ru/" target="_blank">����� ������ ����������</a>.
    <li>���� �� ������ ������� �������� �� �������, ��� WMID ������ ���� ��������������� �� ����� ��� 7 ����� �����.
    <li>����� ������� � ����� ��������, ��� Teletrade, Alpari � ������, ����� �� ��� ������� ����������. ������� ��� ����������
    �������� �������� �� ��� �������. ��� �� ��������� � � ��������� ���� Paymer � ���������� �������� ��� �� ���� �������.
    <li>����� �� ������ ������������ � &quot;<a href="http://www.wmtransfer.com/rus/cooperation/legal/syagreement1.shtml#3" target="_blank">������������
    � ������</a>&quot;, ���������� � ���������� 3 � <a href="http://www.wmtransfer.com/rus/cooperation/legal/syagreement1.shtml" target="_blank">����������
    � ��������� ������������� ���� ��������� ���������� �������</a>.
    </ul>
    </p>
    <p align="justify" style="padding:0 0 0 50px">
    ����������� � ������<br />
    ������������ ������ � ������ ��������������� �� �� ������ ���� ���� �����������, ���������������� ������� WebMoney Transfer.
    �� �������� ����������� ������������, ����������� ������, � �������������� ��������� ������� � ����� � ������������. �����������,
    ��������������� ������� WebMoney Transfer, �� �������� ������������ �������������� ��� ���� �������������� �� �������
    � �������������� ����� � �� ����� ������� ��������������� �� ���� ������������.<br />
    ����������, ������������� �� ������� WebMoney Transfer, ���� ������������ ���� ��������� ��� ����� � ������������ ��������.
    ��� �������������� �� ������ ������� � �� ��������, ��� �� �����-���� ������� ������� � ��������� ���������� ������� WebMoney.
    </p>
    <p align="justify">
    ���� �� ������� ����������� ������ �������� �/��� ��� �� ������ ������� ������� ������,
    ����������� ������������ � �������� ������ ������ ������� � ��������� ���������� ������, ������������ ����.
    </p>
    <p align="justify">������������ ����������� ��������� ��� ���� ��� ���������� ������. ��������� ����������� ������ �������� ���������
    �� ��������� ������ ��� ������, � ��� ������������� �������� � ��������� ����������� ����������� ��������� � ����
    ��� ��������� �������. �������� ���������� ���������� �� ����������� ������ � �� �������� ������� �����. ��� ������
    � �������� ������ ���������������, ����� �������, ���� ����������� ������ �������
    <a href="http://arbitrage.webmoney.ru/asp/default.asp" target="_blank">����������� ������ ������� WebMoney Transfer</a>.</p>
    <p align="justify">�������� ����������� <a href="http://www.megastock.ru/Doc/exchange_agreement.aspx" target="_blank">&laquo;������� ���������� ����������
    �� �������� WM-������ �� ������ ������� WebMoney Transfer&raquo;</a>,
    ����� �� ������ � �������� �������, ���������� ��� �� ��������� ���������� ������� ���������� ������������� �� �����,
    �������� ����� ���������� ����������� ��� �������������� � ������������ � ���.</p>
    <p><b><a name="Up"><b><u>��� ������ ������������� ��������� ������:</u></b></a></b></p>
    <ul>
        <li>�������������� ����� ��������� ������ ������� WebMoney Transfer, � ������: WMZ, WMR, WME, WMU.<br />
            ����� ����������� ����� WebMoney ����� ����� �������������� ������������� � ������������� �� ����� ��� ������� ���������.<br />
            <a href="#autoexchange">������� ���������� ������ �� <b>��������� ����������� �����</b></a>
        </li><br />
        <li>���� � ����� ��������� ������ ������� WebMoney Transfer: WMZ, WMR, WME, WMU.<br />
            ����� ����������� ����� �� �������� ������� � �������� �� ����������� �������������� �� ������ �� ����� ���� �����
            <a href="$http/contacts.asp">���������������</a> � ������ ������ ����� ��������� ������� ����������� ��� �����.<br />
            <a href="#cash">������� ���������� ������ �� <b>����� �������� ������� �� ����������� ������</b> (���� � ������� WebMoney Transfer)</a><br />
            <a href="#emoney">������� ���������� ������ �� <b>����� ����������� ����� �� �������� ��������</b> (����� �� ������� WebMoney Transfer)</a>
        </li><br />
        <li>���� � ����� ������� �� ����� ������ Betfair.com � ��������� 0% ��� ������� ����������� ����� ��� ����.<br />
            <a href="$http/betfair.asp">����������� ��������� OKWM.com.ua � BETFAIR.com</a><br />
            <a href="$http/bf/">����������� �� ����� ������ Betfair.com</a>
        </li><br />
        <li>���� ������� �� ���� ������� Pokerstars � ��������� 0%.<br />
        <a href="http://www.okwm.com.ua/pokerstars.asp" target="_blank">����������� �������������� OKWM.com.ua � Pokerstars.com.</a><br />
        <a href="http://www.pokerstars.com/ru/ target="_blank"">����������� �� ����� Pokerstars.com.</a>
        </li><br />
        <li>�������������� ���������� �� ������ ����� � ������� <a href="$http/faq.asp">������� � ������</a>
            ��� �������� � <a href="$http/contacts.asp">���������������</a>:
            <ul type="circle">
            <li>�� e-mail, WMID � ICQ � ������� ��� � 10-00 �� 18-00, � ������� � ����������� � 12-00 �� 14-00;</li>
            <li>�� ��������� � �������������.</li>
            </ul>
        </li>
    </ul>
    <p><b><u><a name="autoexchange">������� ���������� ������ �� ��������� ����������� �����:</a></u></b></p>
    <ol>
        <li>�� <a href="$http">�������</a> �������� ������� ����������� ������ � ����-������� ����:
            <ul>
               <li>� ����� ������ ��� ��̻ �������� ������, ������� �� ������ ��������. �������� ��������� ������: Webmoney (WMZ, WMR, WMU, WME).</li>
               <li>� ������� ������ ��� ��̻ �������� ������, ������� �� ������ �������� � ���������� ������.</li>
               <li>��������� ������ �������� ����� ������ � ������������� ������������ ���������.
               �� ����������, ������� �� �������� - ���������� ��������� ��������� ������.<br />
               ��������: ���� ���������� �������������� �����, ���� � ����� ������.����� �� Webmoney (WMZ, WMR, WMU, WME) �
               �������������� �������� �������� ��� ������� �������.
               </li>
            </ul>
        </li><br />
        <li>������� ����� ������ � ���� �� ����� ��� ��̻ ��� ��� ��̻. �� ������ ������ ������������� ����� ���������� �����
            � ������ <a href="$http/tarifs.asp">�������</a> � ������ (�� ������� ����) ������ ��������� ������.<br /><br />
            ����������� ����� ������ ���������� ���������� 5 USD.<br />
            <u>����������:</u> �� ���������� ������ ���������� �������� WebMoney ���������
            <a href="http://webmoney.ru/rus/about/fees/index.shtml" target="_blank">��������</a> � ������� 0.8% �� ����� �������,
            �� �� ����� 0.01 WM � �� ����� 50 WM ��� ��������� ���� Z � E, �� ����� 1500 WM ��� ��������� ���� R,
            �� ����� 250 WM ��� ��������� ���� U.
        </li><br />
        <li>����� ����, ��� �� ������� ����������� � ����� ������, ��������� &laquo;��&raquo;.</li><br />
        <li>������� ����� �������� � ������� WebMoney Transfer, �� ������� �� ������ �������� �������� ����� ������, � ���� e-mail.<br />
            �������� ���������� ��� ������ ������ ������:
            <ul>
               <li>����� ������� �����:<br />
               <p>��� ����� ������� ��� <a href="http://webmoney.ru/rus/about/demo/help/classic/resp1_09_lost_wmid.shtml" target="_blank">WMID</a> ��� �������� ��� ����� �� ������;<br />
               ���� ������������ ���������, ����� ��������� ���������� ������ �������� ������ � ��������� WebMoney Keeper (�������� ������ F5), � ��� ����� ��������� ���� �� ������;<br />
               ������ ������ ���� ��������� ��� ���� ���������.</p></li>
               <li>����� WebMoney Merchant:<br />
               <p>� ���� ������ ������ �������������� ����� �� ����� ���
               <a href="http://webmoney.ru/rus/about/demo/help/common/resp2_02_protection.shtml" target="_blank">���� ���������</a>.</p>
               </li>
            </ul>
        </li><br />
        <li>��������� &laquo;��������� ������&raquo;. �� ��� e-mail ����� ������� ������, �������������� ������. �� ���������� ��������
            �������� ������. ���� �� �����-���� �������� �������� ���� �������, �� ������ ������� �� ��� �� ������ � ������,
            ������������ �� ��� e-mail.<br />
            <u>����������:</u> ���� ����� �������� ������ ������ ����� ��������� &laquo;������ �� �������! �����, ������� �� ������ ��������,
            ��� � �������&raquo;, ���������� � <a href="$http/contacts.asp">���������������</a> ��� ��������� �����, ��������� ��� ������.
        </li><br />
        <li>����������� ������ �� ������. ����� ������ ��������� &laquo;����������&raquo; � ���� �������� ������. ����� ����������
            ������������� � �� ��� e-mail ����� ������� ������, �������������� ��������� ������. �������� ������ � ���������
            WebMoney Keeper ��� ��������� ������� �� ��� �������. ���� �������� ������ � ������ �� �����������, ��������� �
            <a href="$http/contacts.asp">���������������</a> �� ��������, ICQ ��� e-mail.
        </li><br />
    </ol>
    <center><p><a href="#Up"><< ��������� � ������ ����� >></a></p></center><br />
    <p><b><u><a name="#cash">������� ���������� ������ �� ����� �������� ������� �� ����������� ������ (���� � ������� WebMoney Transfer)</a></u></b></p>
    <ol>
        <li>�� <a href="$http">�������</a> �������� ������� ����������� ������ � ����-������� ����:
            <ul>
               <li>� ����� ������ ��� ��̻ �������� ������, ������� �� ������ ��������. �� ������ ������� ���� � ����� ��������� ��������� Webmoney (WMZ, WMR, WMU, WME) � ������� ����, ��������������, ������.</li>
               <li>� ������� ������ ��� ��̻ �������� ������, ������� �� ������ �������� � ���������� ������.</li>
               <li>����� ��������� �����, �������� �� ������ �������� ���� Webmoney ���������:<br />
               - �������� ������;<br />
               - �������� �������;<br />
               - �������� ����;<br />
               - �������� Visa, Mastercard.</li>
            </ul>
        </li><br />
        <li>������� ����� ������ � ���� �� ����� ��� ��̻ ��� ��� ��̻. �� ������ ������ ������������� ����� ���������� �����
            � ������ <a href="$http/tarifs.asp">�������</a> � ������ (�� ������� ����) ������ ��������� ������.<br />
            ����������� ����� ������ ���������� ���������� 5 USD.<br />
        </li><br />
        <li>����� ����, ��� �� ������� ����������� � ����� ������, ��������� &laquo;��&raquo;.</li><br />
        <li>������� �����, ��� ����� ������������� ������ ��������, ��������� ���� � ����� ��������� ������ �����, ����� ����������� ��������,
        e-mail, <a href="http://wiki.webmoney.ru/wiki/show/WM-%D0%BA%D0%BE%D1%88%D0%B5%D0%BB%D0%B5%D0%BA?q=%D0%BA%D0%BE%D1%88%D0%B5%D0%BB" target="_blank">����� ��������</a>
        � ������� WebMoney ��� �������� ��� �������.<br />
        �������� ����� �������� ������, ���������� ��������� ����� ��������� ������: �.�.�. ��������� (�����������), ����� � ����� ��������
        (�����������), ����������� � ������� (���� �� ����� � �������� ���� ������),
        <a href="http://webmoney.ru/rus/about/demo/help/common/resp2_02_protection.shtml" target="_blank">��� ���������</a> (���� �� ����� � �������� ���� ������).
        </li><br />
        <li>��������� &laquo;��������� ������&raquo;. �� ��� e-mail ����� ������� ������ � ������� ������, �������������� ��� �����.<br />
            <u>����������:</u> ���� ����� �������� ������ ������ ����� ��������� &laquo;������ �� �������! �����, ������� �� ������ ��������,
            ��� � �������&raquo;, ���������� � <a href="$http/contacts.asp">���������������</a> ��� ��������� �����, ��������� ��� ������.</li><br />
        <li>� ��������� � ������ ����� ������ �������� � �����������������, �������� ����� ������ � ���������� ������ ������.
        ������� ��������� ��� ������� �����������, �������� ����������� ������� WebMoney.<br />
        ���������� ������� �� ��������� ���������� �������������� � ������� �������� ���� ����� � ������� ������ ������
        </li><br />
    </ol>
    <center><p><a href="#Up"><< ��������� � ������ ����� >></a></p></center><br />
    <p><b><u><a name="emoney">������� ���������� ������ �� ����� ����������� ����� �� �������� �������� (����� �� ������� WebMoney Transfer)</a></u></b></p>
    <ol>
        <li>�� <a href="$http">�������</a> �������� ������� ����������� ������ � ����-������� ����:
            <ul>
               <li>� ����� ������ ��� ��̻ �������� ������, ������� �� ������ ��������. �� ������ ������� ����� Webmoney ��������� ��������� - WMZ, WMR, WME, WMU � �����, ������ � ���������������.</li>
               <li>� ������� ������ ��� ��̻ �������� ������, ������� �� ������ �������� � ���������� ������.</li>
               <li>� ���������� ������ (������) Webmoney �� ������ �������� ��������� ������:<br />
               - �������� ������;<br />
               - �������� �������;<br />
               - �������� ����;<br />
               - �������� Visa, Mastercard.</li>
            </ul>
        </li><br />
        <li>������� ����� ������ � ���� �� ����� ��� ��̻ ��� ��� ��̻. �� ������ ������ ������������� ����� ���������� �����
            � ������ <a href="$http/tarifs.asp">�������</a> � ������ (�� ������� ����) ������ ��������� ������.<br />
            ����������� ����� ������ ���������� ���������� 5 USD.<br />
            <u>����������:</u> �� ���������� ������ ���������� �������� WebMoney ���������
            <a href="http://webmoney.ru/rus/about/fees/index.shtml" target="_blank">��������</a> � ������� 0.8% �� ����� �������,
            �� �� ����� 0.01 WM � �� ����� 50 WM ��� ��������� ���� Z � E, �� ����� 1500 WM ��� ��������� ���� R,
            �� ����� 250 WM ��� ��������� ���� U.
        </li><br />
        <li>����� ����, ��� �� ������� ����������� � ����� ������, ��������� &laquo;��&raquo;.</li><br />
        <li>������� �.�.�. ���������, ����� � ����� ��������, ����� ��������� �������� �������, ��������� ���� �
            ����� ��������� ������ �����, ����� ����������� ��������, e-mail.
            �������� ���������� ��� ������ ������ ������:
            <ul>
               <li>����� ������� �����:<br />
               <p>��� ����� ������� ��� <a href="http://webmoney.ru/rus/about/demo/help/classic/resp1_09_lost_wmid.shtml" target="_blank">WMID</a> ��� �������� ��� ����� �� ������;<br />
               ���� ������������ ���������, ����� ��������� ���������� ������ �������� ������ � ��������� WebMoney Keeper (�������� ������ F5), � ��� ����� ��������� ���� �� ������;<br />
               ��� ������ ����� ������� ����� �� ������ ������� ��� ���������.</p></li>
               <li>����� WebMoney Merchant:<br />
               <p>� ���� ������ ������ �������������� ����� �� ����� ���
               <a href="http://webmoney.ru/rus/about/demo/help/common/resp2_02_protection.shtml" target="_blank">���� ���������</a>.</p>
               </li>
            </ul>
            <u>����������:</u> ���� �� ���������� ������� � ���������� �� �������, �� �������� ��� �� ������� ������ �� ���������
            ������� ���������.
        </li><br />
        <li>��������� &laquo;��������� ������&raquo;. �� ��� e-mail ����� ������� ������ � ������� ������, �������������� ��� �����.<br />
            <u>����������:</u> ���� ����� �������� ������ ������ ����� ��������� &laquo;������ �� �������! �����, ������� �� ������ ��������,
            ��� � �������&raquo;, ���������� � <a href="$http/contacts.asp">���������������</a> ��� ��������� �����, ��������� ��� ������.</li><br />
        <li>� ��������� � ������ ����� ������ �������� � ���� �� ���������������� � �. ����, ������, ��������������,
            �������� ����� ������ � ������������ ������ Webmoney (WMZ, WME, WMR, WMU), ������.������ � ������, ����������� �������,
            <a href="http://webmoney.ru/rus/about/demo/help/common/resp2_02_protection.shtml" target="_blank">��� ���������</a>
            (���� ������� ��� � �����) � �������� ��������. �������� �������� ������ ��� ������� ��������, ���������� � ������,
            � ������ ��������� ��������, � �������� ���� ����������� ������.
        </li>
    </ol><br />
    <center><p><a href="#Up"><< ��������� � ������ ����� >></a></p></center><br />
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();
</script>