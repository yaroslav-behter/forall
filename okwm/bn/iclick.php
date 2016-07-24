<?php

include ("iconf.php");
global $bduser;
global $table;
global $table2;
global $table3;

/*foreach ($HTTP_GET_VARS as $fk => $fv) {
  eval("\$$fk = \"$fv\";");
}
foreach ($HTTP_POST_VARS as $fk => $fv) {
  eval("\$$fk = \"$fv\";");
}*/

if (isset($HTTP_GET_VARS['ad'])&&is_numeric($HTTP_GET_VARS['ad'])) {    $ad = $HTTP_GET_VARS['ad'];
    $ad=stripslashes(trim($ad));
    mysql_connect($host, $bduser, $bdpass) or die ("Ошибка: База данных недоступна.");
    mysql_select_db($bd) or die ("Ошибка: База данных не подключена.");
    $sql = "SELECT * FROM $table WHERE adt_id='$ad'";
    $result = mysql_query($sql);
    $num = mysql_numrows($result);
    if ($num != "0") {
        $row = mysql_fetch_array($result);
        $adt_link=$row["adt_link"];
        $today=date("Y-m-d");
        mysql_query ("INSERT INTO $table2 (adt_id, adt_clicks_date) VALUES ('$ad', '$today')");
        header ("Location: $adt_link");
    }
} else {    header ("Location: ".DOMAIN_HTTP);
    exit;}

?>