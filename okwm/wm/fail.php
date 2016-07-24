<script language="PHP">
#--------------------------------------------------------------------
# ProfService no payment page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");

   foreach ($HTTP_POST_VARS as $fk => $fv) {
       $fv = addcslashes($fv, '"');
       eval("\$$fk = \"$fv\";");
   }

   $TITLE = base64_decode ($TITLE);

   // Create HTML code
   HTMLHead ($TITLE);
   HTMLAfteHead("Оплата не произведена");

   echo <<<EOT

<p>
Вы хотели произвести обмен Webmoney.
Однако оплата не принята, обмен не выполнен.<br>
</p>
<p>
Попробуйте еще раз или свяжитесь с <a href="mailto:admin@okwm.com.ua">
администрацией<a> сайта для выяснения причин ошибки.
</p>

EOT;

   HTMLAfteBody();
   HTMLTail ();
</script>