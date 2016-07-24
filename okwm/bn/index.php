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
if (($pss!="")&&(ereg("([0-9a-zA-Z]{0,15})",$pss, $pss_pars))) {
  $pss=$pss_pars[0];
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
        Логин:
        <input type="password" name="pss" value="<? echo $pss; ?>" style="border: #E7EBEE solid 1px; background: #FFFFFF; }">
        <input type="submit" value="Вход" name="deu">
      </form>
    </td>
  </tr>
</table>

<?
if ($okk) {
  $deoll=$deu;
  if ($deu=='Вход') {

    $upass=$pss;

    $sql_login = "SELECT * FROM $table3 WHERE upass='$upass'";
    $result_login = mysql_query($sql_login);
    $row_login = mysql_fetch_array($result_login);
    $id=$row_login["uid"];

    if ($id!="") {

      foreach ($HTTP_GET_VARS as $fk => $fv) {
        eval("\$$fk = \"$fv\";");
      }
      foreach ($HTTP_POST_VARS as $fk => $fv) {
        eval("\$$fk = \"$fv\";");
      }

      $today=date("Y-m-d");

      $sql = "SELECT * FROM $table WHERE adt_id='$id'";
      $result = mysql_query($sql);
      $row = mysql_fetch_array($result);
      $name=$row["adt_name"];
      $link=$row["adt_link"];
      echo "
        <table align=center width=50% border=0>
        <tr>
        <td bgcolor=#E7EBEE><b>Дата</b></td>
        <td colspan=3 bgcolor=#E7EBEE><b>Клики</b></td>
        </tr>";
$sql = "SELECT *, COUNT(clicks_id) AS clicks FROM $table2 WHERE adt_id='$id' GROUP BY adt_clicks_date ORDER BY adt_clicks_date";
      $result = mysql_query($sql);
      $sql3 = "SELECT * FROM $table2 WHERE adt_id='$id'";
      $result3 = mysql_query($sql3);
      $num = mysql_numrows($result3);
      while ($row = mysql_fetch_array($result)) {
        $date=$row["adt_clicks_date"];
        $clicks=$row["clicks"];
        $all=$all+$clicks;
        $pr=$clicks/$num;
        $pr=100*$pr;
        echo "
          <tr>
          <td bgcolor=#F8FAFB>$date</td>
          <td bgcolor=#F8FAFB>$clicks</td>
          <td bgcolor=#F8FAFB align=center>";
          echo (number_format($pr,2));
          echo "
        %</td>
        <td bgcolor=#F8FAFB><img align=left src=red.gif height=12 width=$pr></td>
        </tr>";
      }
      echo "<tr><td align=right><br><b>Итого:</b></td><td align=left><br><b>$all</b></td></tr>";
      echo "</table></body></HTML>";
      break;
    } else {
      echo "<P align=\"center\">Ошибка! Неверный пароль.</P>";
    }
  }
}
?>