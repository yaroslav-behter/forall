<?php

include ("conf.php");

mysql_connect($host, $bduser, $bdpass) or die ("Ошибка: База данных недоступна.");
mysql_select_db($bd) or die ("Ошибка: База данных не подключена.");

$query="select * from $table1 order by id desc limit 0,5";
$result=mysql_query($query);

while ($row=mysql_fetch_array($result)) {
  $date=$row["date"];
  $text=$row["text"];
  echo "       <h2>$date</h2>\n";
  echo "       <p>$text</p>\n";
}
?>