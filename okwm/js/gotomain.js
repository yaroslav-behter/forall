<script language="PHP">
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");

$domain = DOMAIN_HTTP;

echo <<<EOT
<!-- Go to main page -->
<script language="JavaScript">
   function delay () {
      top.location.href="$domain";
   }
   top.setTimeout("delay();",60000);
</script>
EOT;
</script>
