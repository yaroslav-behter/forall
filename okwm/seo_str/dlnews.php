<?php
include ("conf.php");

mysql_connect($host, $bduser, $bdpass) or die ("Ошибка: База данных недоступна.");
mysql_select_db($bd) or die ("Ошибка: База данных не подключена.");

$okk=false;
if (isset($_SERVER["PHP_AUTH_USER"])) {
   $okk = in_array($_SERVER["PHP_AUTH_USER"], $users) or die ("Не выполнен вход.");
}

if (isset($_GET['url_id'])&&is_numeric($_GET['url_id'])) {
    $table = "seo_urls";
    if (!preg_match("/^\d+$/",$_GET['url_id'])) {
        echo "Error!";
        exit;
    } else {
        $id=$_GET['url_id'];
    }
    $query = "delete from seo_strings where id_url='$id'";
    $result=mysql_query($query) or die("Invalid query: " . mysql_error());
}
if (isset($_GET['str_id'])&&is_numeric($_GET['str_id'])) {
    $table = "seo_strings";
    if (!preg_match("/^\d+$/",$_GET['str_id'])) {
        echo "Error!";
        exit;
    } else {
        $id=$_GET['str_id'];
    }
}


$query="delete from $table where id='$id'";
$result=mysql_query($query) or die("Invalid query: " . mysql_error());

echo <<<EOT
<HTML>
<head>
  <title>Страница администратора</title>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
</head>

<body background="#FFFFFF">
<br><br><br><br><br><br>
<table width="80%" align="center" border="0">
  <tr>
    <td bgcolor="#F8FAFB" align="center" valign="center" cellpadding="0">
      Запись удалена.
    </td>
  </tr>
  <tr>
    <td bgcolor="#F8FAFB" align="center" valign="center" cellpadding="0">
      <a href="admin.php">Вернуться назад</a>
    </td>
  </tr>
</table>
</body>
</HTML>
EOT;
