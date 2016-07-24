<?php

if (isset($_GET['url_id'])) {
    $id = $_GET['url_id'];
}
if (isset($_GET['str_id'])) {
    $id = $_GET['str_id'];
}

if (!preg_match("/^\d+$/",$id)) {
    echo "Error!";
    exit;
}

include ("conf.php");

mysql_connect($host, $bduser, $bdpass) or die ("Ошибка: База данных недоступна.");
mysql_select_db($bd) or die ("Ошибка: База данных не подключена.");

$okk=false;
if (isset($_SERVER["PHP_AUTH_USER"])) {
   $okk = in_array($_SERVER["PHP_AUTH_USER"], $users) or die ("Не выполнен вход.");
}

echo <<<EOT
<HTML>
<head>
  <title>Страница администратора</title>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
</head>

<body>
<br><br><br><br><br><br>

EOT;

  if (isset($_POST['add_url'])) {
     $url = addslashes($HTTP_POST_VARS['text']);
     if (!preg_match("/^\d+$/",$_GET['url_id'])) {
         echo "Error!";
         exit;
     } else {
         $id=$_GET['url_id'];
     }
     $query="update seo_urls set url='$url' where id=$id";
     $result=mysql_query($query);
     echo "<P align=\"center\">URL изменен!<br>
     <a href=\"admin.php\">Вернуться назад</a></P>";
  }
  if (isset($_POST['add_str'])) {
     $type = strtolower($HTTP_POST_VARS['type']);
     $text = addslashes($HTTP_POST_VARS['text']);
     if (!preg_match("/^\d+$/",$_GET['str_id'])) {
         echo "Error!";
         exit;
     } else {
         $id=$_GET['str_id'];
     }
     $query="update seo_strings set type='$type', value='$text' where id=$id";
     $result=mysql_query($query);
     echo "<P align=\"center\">Строка изменена!<br>
     <a href=\"admin.php\">Вернуться назад</a></P>";
  }


if (isset($_GET['url_id'])&&is_numeric($_GET['url_id'])) {    //is_int($_GET['str_id'])) {
   $query="select * from seo_urls where id=".$_GET['url_id'];
   $result=mysql_query($query);

   $row=mysql_fetch_array($result);
   $date=$row["date"];
   $text=$row["url"];
   $table = "    <table width=\"80%\" align=\"center\" border=\"0\">
      <tr>
        <td width=\"15%\">Дата: </td>
        <td>$date</td>
      </tr>
      <tr>
        <td>URL страницы: </td>
        <td><textarea name=\"text\" rows=\"5\" style=\"width: 70%; border: #E7EBEE solid 1px; background: #FFFFFF;\">$text</textarea></td>
      </tr>
      <tr>
        <td colspan=\"2\" align=\"center\"><input type=\"submit\" value=\"Сохранить\" name=\"add_url\"><br><br></td>
      </tr>
    </table>
";
}
if (isset($_GET['str_id'])&&is_numeric($_GET['str_id'])) {
   $query="select * from seo_strings where id=".$_GET['str_id'];
   $result=mysql_query($query);

   $row=mysql_fetch_array($result);
   $date=$row["date"];
   $type=$row["type"];
   $text=$row["value"];
   $table = "    <table width=\"80%\" align=\"center\" border=\"0\">
      <tr>
        <td width=\"10%\">Дата: </td>
        <td>$date</td>
      </tr>
      <tr>
        <td>Тип: </td>
        <td><input name=\"type\" value=\"$type\" style=\"width: 70%; border: #E7EBEE solid 1px;\"></td>
      </tr>
      <tr>
        <td>Строка: </td>
        <td><textarea name=\"text\" rows=\"5\" style=\"width: 70%; border: #E7EBEE solid 1px; background: #FFFFFF;\">$text</textarea></td>
      </tr>
      <tr>
        <td colspan=\"2\" align=\"center\"><input type=\"submit\" value=\"Сохранить\" name=\"add_str\"><br><br></td>
      </tr>
    </table>
";
}
?>

  <form method="POST">
  <?php
  echo $table;
  ?>
  </form>
</body>
</HTML>

