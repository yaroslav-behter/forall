<?php

include ("iconf.php");
global $bduser;
global $table;
global $table2;
global $table3;

mysql_connect($host, $bduser, $bdpass) or die ("Ошибка: База данных недоступна.");
mysql_select_db($bd) or die ("Ошибка: База данных не подключена.");

$okk=false;
$pss=$HTTP_POST_VARS['pss'];
$deu=$HTTP_POST_VARS['deu'];
//проверка пароля..
if ($pss=="iamadmin") {
  $okk=true;
}

if (!($okk)) {
  $pss="";
}

?>
<HTML>
<head>
  <title>All Money - cтатистика</title>
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
        <input type="submit" value="Вход" name="deu">
      </form>
    </td>
  </tr>
</table>

<?
if ($okk) {
  $deoll=$deu;
  if ($deu=='Вход') {
    ?>
    <form method="POST">
    <table width="50%" align="center" border="0">
      <tr>
        <td>Название: </td>
        <td><input type=text name=adt_name size=50 maxlength=50 style="border: #E7EBEE solid 1px; background: #FFFFFF;"></td>
      </tr>
      <tr>
        <td>Ссылка: </td>
        <td><input type=text name=adt_link size=50 maxlength=100 style="border: #E7EBEE solid 1px; background: #FFFFFF;"></td>
      </tr>
      <tr>
        <td>Логин: </td>
        <td><input type=text name=adt_login size=50 maxlength=30 style="border: #E7EBEE solid 1px; background: #FFFFFF;"></td>
      </tr>
      <tr>
        <td colspan="2" align="center"><input type="submit" value="Добавить" name="add"><br><br></td>
      </tr>
    </table>
    </form>
    </body></HTML>
    <?
  }
}
$add=$HTTP_POST_VARS['add'];
$adt_name=$HTTP_POST_VARS['adt_name'];
$adt_link=$HTTP_POST_VARS['adt_link'];
$adt_login=$HTTP_POST_VARS['adt_login'];
if ($add=='Добавить') {
  mysql_query ("INSERT INTO $table (adt_name, adt_link) VALUES ('$adt_name', '$adt_link')");
  mysql_query ("INSERT INTO $table3 (ulogin, upass, urank) VALUES ('$adt_login', '$adt_login', '0')");
  echo "<P align=\"center\">Объект добавлен!</P>";
}
?>
