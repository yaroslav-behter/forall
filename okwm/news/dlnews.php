<?php

if (!preg_match("/^\d+$/",$_GET['id'])) {
    echo "Error!";
    exit;
} else {
    $id=$HTTP_GET_VARS['id'];
}

include ("conf.php");

mysql_connect($host, $bduser, $bdpass) or die ("Ошибка: База данных недоступна.");
mysql_select_db($bd) or die ("Ошибка: База данных не подключена.");

$query="delete from $table1 where id='$id'";
$result=mysql_query($query);

echo <<<EOT

<HTML>
<head>
  <title>Страница администратора</title>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
</head>

<body background="#FFFFFF">
<br><br><br><br><br><br>
<table width="50%" align="center" border="0">
  <tr>
    <td bgcolor="#F8FAFB" align="center" valign="center" cellpadding="0">
      Новость удалена.
    </td>
  </tr>
</table>

EOT;
