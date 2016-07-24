<html>

<head>
  <title>Logs Request Ukash</title>
  <meta http-equiv="Content-type" content="text/html;charset=windows-1251" />
</head>
<style>
table,tr,td {
	border: 1px solid black;
}
table{
	border-collapse: collapse;
}
</style>
<body>
<a href="index.php"><-- Back</a><br /><br />
<?php
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");

$date_from = (isset($_POST['date_from']))? $_POST['date_from'] : date("Y-m-d", mktime(0, 0, 0, date("m")  , date("d")-10, date("Y")));
$date_to   = (isset($_POST['date_to']))?   $_POST['date_to']   : date("Y-m-d");
$s1=$s2=$s3="";
if (isset($_POST['type_op'])&&($_POST['type_op']=="All")) {
    $type_op = "";
    $s1 = "selected";
}
if (isset($_POST['type_op'])&&($_POST['type_op']=="IssueVoucher")) {
    $type_op = " AND script='IssueVoucher'";
    $s2 = "selected";
}
if (isset($_POST['type_op'])&&($_POST['type_op']=="Redemption")) {
    $type_op = " AND script='Redemption'";
    $s3 = "selected";
}
echo <<<EOT

<form method="POST" action="logs.php">
From: <input type="text" name="date_from" value="$date_from"> (YYYY-mm-dd)<br />
To: <input type="text" name="date_to" value="$date_to"> (YYYY-mm-dd)<br />
<select size="1" name="type_op" id="type_op">
<option value="All" $s1>All</option>
<option value="IssueVoucher" $s2>Issue Voucher</option>
<option value="Redemption" $s3>Redemption</option>
</select><br />
<input type="submit" value="Показать">
<br /><br />
</form>

EOT;

$sql = "SELECT * FROM ukash WHERE DATE>'$date_from 00:00:00' AND DATE<'$date_to 23:59:59'$type_op";

$row = OpenSQL ($sql, $rows, $res);
echo "Выбрано $rows строк.";
echo "<table>\n";
echo "<tr><td>#</td><td>Date</td><td>Script</td><td>Query</td><td>Response</td><td>IP</td></tr>\n";

for ($i=0; $i<$rows; $i++) {
	$row = NULL;
	GetFieldValue ($res, $row, "id", $id, $IsNull);
	GetFieldValue ($res, $row, "date", $date, $IsNull);
	GetFieldValue ($res, $row, "script", $script, $IsNull);
	GetFieldValue ($res, $row, "xml_query", $xml_query, $IsNull);
	GetFieldValue ($res, $row, "xml_response", $xml_response, $IsNull);
	GetFieldValue ($res, $row, "ip", $ip, $IsNull);

	$xml_query = htmlentities(base64_decode($xml_query));
	$xml_response = base64_decode($xml_response);
	echo "<tr><td>$id</td><td>$date</td><td>$script</td><td>$xml_query</td><td> $xml_response </td><td>$ip</td></tr>\n";
}
echo "</table>";

?>
</body>

</html>