<html>

<head>
  <title></title>
</head>

<body>
<pre>
<?php

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/ukash/config.php");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/ukash/database.php");

$sql = "SELECT * FROM ukash WHERE 1";
OpenSQL($sql, $rows, $res);
for ($i=0; $i<$rows; $i++) {    $row = NULL;
    GetFieldValue ($res, $row, 'id', $id, $IsNull);
    GetFieldValue ($res, $row, 'date', $datetime, $IsNull);
    GetFieldValue ($res, $row, 'script', $gateway, $IsNull);
    GetFieldValue ($res, $row, 'xml_response', $resp, $IsNull);
    echo "<b>$id $datetime $gateway</b></br>";
    $xml_response = base64_decode($resp);
    if (DEBUG) { var_dump($xml_response); echo "<br />"; }
    include("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/ukash/response.php");
}

?>
</pre>
</body>

</html>