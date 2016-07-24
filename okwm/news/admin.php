<?php

include ("conf.php");

mysql_connect($host, $bduser, $bdpass) or die ("Ошибка: База данных недоступна.");
mysql_select_db($bd) or die ("Ошибка: База данных не подключена.");

$okk=false;
$pss=$HTTP_POST_VARS['pss'];
$deu=$HTTP_POST_VARS['deu'];
//проверка пароля..
if ($pss=="amafghfhgHJGFfg76876h") {
  $okk=true;
}

if (!($okk)) {
  $pss="";
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
<table width="50%" align="center" border="0">
  <tr>
    <td bgcolor="#F8FAFB" align="center" valign="center" cellpadding="0">
      <form method="POST">
        Пароль:
        <input type="password" name="pss" value="<? echo $pss; ?>" style="border: #E7EBEE solid 1px; background: #FFFFFF;">
        <input type="submit" value="Добавить" name="deu"> &nbsp;
        <input type="submit" value="Удалить" name="deu">
      </form>
    </td>
  </tr>
</table>

<?
if ($okk) {
  $deoll=$deu;
  if ($deu=='Добавить') {
    ?>
    <form method="POST" name="add">
    <table width="50%" align="center" border="0">
      <tr>
        <td>Дата: </td>
        <td><input type="text" name="date" size="50" maxlength="50" style="border: #E7EBEE solid 1px; background: #FFFFFF;"
        value="<? echo date('d.m.Y'); ?>"></td>
      </tr>
      <tr>
        <td>Новость: </td>
        <td><textarea name="text" rows="5" style="width: 70%; border: #E7EBEE solid 1px; background: #FFFFFF;"></textarea></td>
      </tr>
      <tr>
        <td colspan="2" align="center">
          <input type="submit" value="ad" name="add"><br><br>
        </td>
      </tr>
    </table>
    </form>
    <?
  }
}
$add=$HTTP_POST_VARS['add'];
$date=$HTTP_POST_VARS['date'];
$text=addslashes($HTTP_POST_VARS['text']);
if ($add=='ad') {
  mysql_query ("INSERT INTO $table1 (date, text) VALUES ('$date', '$text')");
  echo "<P align=\"center\">Новость добавлена!</P></body></HTML>";
}

if ($okk) {
  $deoll=$deu;
  if ($deu=='Удалить') {
    ?>
    <form method="POST">
    <table width="50%" align="center" border="0" cellpadding="10">
    <?
    $query="select * from $table1 order by id desc limit 0,5";
    $result=mysql_query($query);
    $color_sum=0;
    while ($row=mysql_fetch_array($result)) {
      $id=$row["id"];
      $date=$row["date"];
      $text=$row["text"];
      if ($color_sum==0) {
        $color="#F8FAFB";
      }
      if ($color_sum==1) {
        $color="#FFFFFF";
      }
      echo "
        <tr bgcolor=\"$color\">
          <td style=\"border: 1 solid #F8FAFB;\">$text</td>
          <td align=\"center\" valign=\"middle\" style=\"border: 1 solid #F8FAFB;\">
            <a href=\"ednews.php?id=$id\">Редактировать</a>
          </td>
          <td align=\"center\" valign=\"middle\" style=\"border: 1 solid #F8FAFB;\">
            <a href=\"dlnews.php?id=$id\">Удалить</a>
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
    </body></HTML>
    <?
  }
}

?>