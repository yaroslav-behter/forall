<script language="PHP">
#--------------------------------------------------------------------
# OKWM welcome page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");

// Create HTML code
HTMLHead ("Ошибка на сайте www.okwm.com.ua");
HTMLAfteHead("Ошибка");

echo <<<EOT
<br>
<p>
Произошла ошибка!<br>
Пожалуйста, сообщите администратору о произошедшей ошибке:
</p>
<p align="center">
<a href="mailto:admin@okwm.com.ua" title="Отправить письмо администратору.">admin@okwm.com.ua</a>
</p>
EOT;
HTMLAfteBody();
HTMLTail ();
</script>