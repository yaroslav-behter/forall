<?php
include ("conf.php");

mysql_connect($host, $bduser, $bdpass) or die ("Ошибка: База данных недоступна.");
mysql_select_db($bd) or die ("Ошибка: База данных не подключена.");

$okk=false;
$deu=$_POST['deu'];

if (isset($_SERVER["PHP_AUTH_USER"])) {
   $okk = in_array($_SERVER["PHP_AUTH_USER"], $users) or die ("Не выполнен вход.");
}

?>
<HTML>
<head>
  <title>Страница администратора</title>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
  <!--<link rel="stylesheet" href="../styles/default.css">-->
</head>

<body background="#FFFFFF">
<br><br><br><br><br><br>
<table width="80%" align="center" border="0">
  <tr>
    <td bgcolor="#F8FAFB" align="center" valign="center" cellpadding="0">
      <form method="POST">
        <input type="submit" value="Добавить адрес страницы" name="deu"> &nbsp;
      </form>
    </td>
  </tr>
</table>

<?
if ($okk) {
  $deoll=$deu;
  if ($deu=='Добавить адрес страницы') {
    ?>
    <form method="POST" name="add">
    <table width="80%" align="center" border="0">
      <tr>
        <td>Дата: </td>
        <td><input type="text" name="date" size="50" maxlength="50" style="border: #E7EBEE solid 1px; background: #FFFFFF;"
        value="<? echo date('Y.m.d G:i:s'); ?>"></td>
      </tr>
      <tr>
        <td>URL страницы: </td>
        <td><textarea name="text" rows="5" style="width: 70%; border: #E7EBEE solid 1px; background: #FFFFFF;"></textarea></td>
      </tr>
      <tr>
        <td colspan="2" align="center">
          <input type="submit" value="add" name="add"><br><br>
        </td>
      </tr>
    </table>
    </form>
    <?
  }
  if ($deu=='Добавить строку') {      if (!preg_match("/^\d+$/",$_GET['id'])) {          echo "Error!";
          exit;
      } else {          $url_id = $_GET['id'];
      }
      $query="select * from seo_urls where id=$url_id order by id desc";
      $result=mysql_query($query) or die("Invalid query: " . mysql_error());
      while ($row=mysql_fetch_array($result)) {
        $date=$row["date"];
        $url=$row["url"];
      }
    ?>
    <form method="POST" name="add">
    <table width="80%" align="center" border="0">
      <tr>
        <td>URL страницы: </td>
        <td><a href="<?php echo $url;?>" target="_blank"><?php echo $url;?></a></td>
      </tr>
      <tr>
        <td>Дата: </td>
        <td><input type="text" name="date" size="50" maxlength="50" style="border: #E7EBEE solid 1px; background: #FFFFFF;"
        value="<? echo date('Y.m.d G:i:s'); ?>"></td>
      </tr>
      <tr>
        <td>Тип: </td>
        <td><input name="type" style="width: 70%; border: #E7EBEE solid 1px;"></td>
      </tr>
      <tr>
        <td>Строка: </td>
        <td><textarea name="text" rows="5" style="width: 70%; border: #E7EBEE solid 1px; background: #FFFFFF;"></textarea></td>
      </tr>
      <tr>
        <td colspan="2" align="center">
          <input type="hidden" value="<?php echo $url_id; ?>" name="url_id"><br><br>
          <input type="submit" value="add string" name="add"><br><br>
        </td>
      </tr>
    </table>
    </form>
    <?
  }
}
$add=$_POST['add'];
$date=$_POST['date'];
$text=addslashes($_POST['text']);

if ($add=='add') {
  mysql_query ("INSERT INTO seo_urls (date, url) VALUES ('$date', '$text')") or die("Invalid query: " . mysql_error());
  echo "<P align=\"center\">URL страницы добавлен!</P></body></HTML>";
}

if ($add=='add string') {  $add_url_id = $_POST['url_id'];
  $type = strtolower($_POST['type']);
  $md5 = md5($date);
  mysql_query ("INSERT INTO seo_strings (id_url, date, type, value, md5) VALUES ($add_url_id, '$date', '$type', '$text', '$md5')") or die("Invalid query: " . mysql_error());
  echo "<P align=\"center\">Строка добавлен!</P></body></HTML>";
}

if ($okk) {
  $deoll=$deu;
    ?>
    <form method="POST">
    <table width="80%" align="center" border="0" cellpadding="10">
    <?
    /* Список страниц */
    $query="select * from seo_urls where 1 order by id desc";
    $result=mysql_query($query) or die("Invalid query: " . mysql_error());
    $color_sum=0;
    while ($row=mysql_fetch_array($result)) {
      $id=$row["id"];
      $date=$row["date"];
      $text=$row["url"];
      if ($color_sum==0) {
        $color="#F8FA8B";
      }
      if ($color_sum==1) {
        $color="#FFFFFF";
      }
      echo "
        <tr bgcolor=\"$color\">
          <td style=\"border: 1 solid #F8FAFB;\">$date</td>
          <td style=\"border: 1 solid #F8FAFB;\">$text</td>
          <td align=\"center\" valign=\"middle\" style=\"border: 1 solid #F8FAFB;\">
            <a href=\"?id=$id\">Строки</a>
          </td>
          <td align=\"center\" valign=\"middle\" style=\"border: 1 solid #F8FAFB;\">
            <a href=\"ednews.php?url_id=$id\">Изменить</a>
          </td>
          <td align=\"center\" valign=\"middle\" style=\"border: 1 solid #F8FAFB;\">
            <a href=\"dlnews.php?url_id=$id\">Удалить</a>
          </td>
        </tr>
      ";
      if ($color_sum==1) {
        $color_sum=0;
      } else {
        $color_sum=1;
      }
    }
    ?>
    </table>
    </form>
    <?php

    if (isset($_GET['id']) && is_int($_GET['id']+0))
    {        /* Вывод строк для выбраной страницы */
      if (!preg_match("/^\d+$/",$_GET['id'])) {
          echo "Error!";
          exit;
      } else {
          $url_id = $_GET['id'];
      }
        ?>
        <table width="80%" align="center" border="0">
          <tr>
            <td bgcolor="#F8FAFB" align="center" valign="center" cellpadding="0">
              <form method="POST">
                <input type="submit" value="Добавить строку" name="deu"><br />
              </form>
            </td>
          </tr>
        </table>
        <form method="POST">
        <table width="80%" align="center" border="0" cellpadding="10">
        <?
        /* Список страниц */
        $query="select * from seo_strings where id_url=$url_id order by id desc";
        $result=mysql_query($query) or die("Invalid query: " . mysql_error());
        $color_sum=0;
        while ($row=mysql_fetch_array($result)) {
          $id=$row["id"];
          $date=$row["date"];
          $type=$row["type"];
          $text=$row["value"];
          $md5=$row["md5"];
          if ($color_sum==0) {
            $color="#C8CA8B";
          }
          if ($color_sum==1) {
            $color="#FFFFFF";
          }
          echo "
            <tr bgcolor=\"$color\">
              <td style=\"border: 1 solid #F8FAFB;\">$date</td>
              <td style=\"border: 1 solid #F8FAFB;\">$type</td>
              <td style=\"border: 1 solid #F8FAFB;\">$text</td>
              <td style=\"border: 1 solid #F8FAFB;\">$md5</td>
              <td align=\"center\" valign=\"middle\" style=\"border: 1 solid #F8FAFB;\">
                <a href=\"ednews.php?str_id=$id\">Изменить</a>
              </td>
              <td align=\"center\" valign=\"middle\" style=\"border: 1 solid #F8FAFB;\">
                <a href=\"dlnews.php?str_id=$id\">Удалить</a>
              </td>
            </tr>
          ";
          if ($color_sum==1) {
            $color_sum=0;
          } else {
            $color_sum=1;
          }
        }
        ?>
        </table>

        </form>
        <?php
    }
}

?>

</body>
</HTML>
