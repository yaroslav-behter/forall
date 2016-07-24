<script language="PHP">
#--------------------------------------------------------------------
# OKWM attestat Webmoney page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2012.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;

// Head ��� Webmoney Attestat
HTMLHead("OKWM - ������, �������, �������� WMZ �.������ Ukash",
         "���������� Webmoney, ������������ ��������, ����������� webmoney, �������� ��������",
         "������� ��������� ���������, ������ ������������ ���������");

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
       <h1>��� �������� ������������ �������� Webmoney</h1>
   </td>
   <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
   </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="help">
        <p>
        <B>��������� ������������� ���������: 30WMZ</B><BR><BR><HR>

        </p>
        <p>
        <B>&nbsp;&nbsp;&nbsp;&nbsp;������� ��������� ������������� ���������</B><BR><BR>
        1. ���������� WebMoney Keeper, �� ������� �� ������ �������� ������������ ��������.<BR><BR>
        2. �������� �� ���� <A HREF="https://passport.webmoney.ru/asp/aProcess.asp" TARGET="_BLANK">������� ����������</A> � �������� ���� ����������� �� �����.<BR>
        2.1. 3��������� �����.<BR>
        2.2. ��������� ����� ������������ "��������� �����" WMID#141938915699.<BR>
        2.3. ����������� ��������� ��������� � ������� 30WMZ.<BR><BR>
        3. ���������. � ������������� ����������, ���������� ������ ����� ����������� ��������� ���������:<BR>
        3.1. ��� ������� ���:<BR>
        �) �������� ��������;<BR>
        �) <A HREF="http://passport.webmoney.ru/include/query.html" TARGET="_BLANK">��������� �� ����������</A>, ������� ������ ���� ��������� ����������� ��������������� � ����������� ���������������;<BR>
        �) ������������ ����� �������� (1-�,2-� �������� � ��������/�����������) �� ����� ����� ������� A4 (�������� ����������� ����� �������� �� �����).<BR><BR>
        3.2. ��� ����������� ���:<BR>
        �) �������� �������� �������������� ���������� (����������� ���� ��������);<BR>
        �) <A HREF="http://passport.webmoney.ru/include/query.html" TARGET="_BLANK">��������� �� ����������</A>, ������� ������ ���� ��������� ����������� ��������������� � ����������� ���������������;<BR>
        �) ����� �������� �������������� ���������� (�������� ����������� ����� �������� �� �����);<BR>
        �) ����������� ���������� ����� ������������� ���������� ������������ ����;<BR>
        �) ����������� ���������� ����� ���������, �� ��������� �������� ��������� ��������� ������������ ���� (�����, ������������ � �.�.).<BR><BR>
        4. ��������� � ���� �� ����� <A HREF="http://www.okwm.com.ua/contacts.asp">������</A> �� ����� ������������ �����������<BR><BR>
        5. ����� ��������� ���������� � �� ��������, �� ��������� ������������ ��������.<BR><BR><HR>
        </p>
        <p>
        ���� ��� ���������� ������ ������������, ������ �� <img src="$http/img/admin.png" alt="����� WMZ �� ��������" title="��������� ������ ��������������">
        </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;
HTMLTail();
</script>