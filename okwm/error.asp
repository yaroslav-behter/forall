<script language="PHP">
#--------------------------------------------------------------------
# OKWM welcome page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");

// Create HTML code
HTMLHead ("������ �� ����� www.okwm.com.ua");
HTMLAfteHead("������");

echo <<<EOT
<br>
<p>
��������� ������!<br>
����������, �������� �������������� � ������������ ������:
</p>
<p align="center">
<a href="mailto:admin@okwm.com.ua" title="��������� ������ ��������������.">admin@okwm.com.ua</a>
</p>
EOT;
HTMLAfteBody();
HTMLTail ();
</script>