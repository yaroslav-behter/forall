<?php

if (!preg_match("/^\d+$/",$_GET['id'])) {
    echo "Error!";
    exit;
} else {
    $id=$HTTP_GET_VARS['id'];
};

include ("conf.php");

mysql_connect($host, $bduser, $bdpass) or die ("������: ���� ������ ����������.");
mysql_select_db($bd) or die ("������: ���� ������ �� ����������.");

$query="select * from $table1 where id=".$id;
$result=mysql_query($query);

$row=mysql_fetch_array($result);
$date=$row["date"];
$text=$row["text"];

?>

<HTML>
<head>
  <title>�������� ��������������</title>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
</head>

<body background="#FFFFFF">
<br><br><br><br><br><br>
  <form method="POST">
    <table width="50%" align="center" border="0">
      <tr>
        <td>����: </td>
        <td><input type="text" name="date" size="50" maxlength="50" style="border: #E7EBEE solid 1px; background: #FFFFFF;"
        value="<? echo $date; ?>"></td>
      </tr>
      <tr>
        <td>�������: </td>
        <td><textarea name="text" rows="5" style="width: 70%; border: #E7EBEE solid 1px; background: #FFFFFF;"><? echo $text; ?></textarea></td>
      </tr>
      <tr>
        <td colspan="2" align="center"><input type="submit" value="���������" name="add"><br><br></td>
      </tr>
    </table>
  </form>
  <?
  $add=$HTTP_POST_VARS['add'];
  $date=$HTTP_POST_VARS['date'];
  $text=addslashes($HTTP_POST_VARS['text']);
  if ($add=='���������') {
    $query7="update $table1 set ";
    $query7=$query7."date='$date', text='$text' ";
    $query7=$query7."where id='$id'";
    $result7=mysql_query($query7);
    echo "<P align=\"center\">������� ���������!<br>
    <a href=\"admin.php\">��������� �����</a></P>";
  }
</script>
