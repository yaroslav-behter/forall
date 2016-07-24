<script language="PHP">

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");

// ��������� �� �������
$strOk               = "Ok\n";
$strBadQuery         = "������������ ����� SQL �������.\n";
$strCanNotGetResult  = "���������� �������� ��������� ���������� �������.\n";
$strCanNotConnect    = "���������� ���������� ���������� � SQL ��������.\n";
$strUnknownFieldName = "����������� ��� ����.\n";
$strCanNotFetchRow   = "������ ���������� ������ �� ���������� ���������� �������.\n";
$strErrorShopDB      = "������ ���� ������ ��������.\n";

// ���� ������
$erOk                = 0;
$erUnknownFieldName  = -1001;

// ���������� � ����� ������
$server = "";

//------------------------------------------------------------------------------
// ������������� ���������� � ����� ������
function ConnectDB()
{
   global $server;

   $HostName = DB_DSN;
   $UserName = DB_USER;
   $Password = DB_PASSWORD;
   $Database = DB_NAME;

   $server = mysql_connect($HostName, $UserName, $Password)
     or die ("Could not connect to server");
              
   mysql_select_db($Database, $server)
     or die ("Could not select database");

   return mysql_errno();
}

//------------------------------------------------------------------------------
// ��������� ���������� � ����� ������
function DisconnectDB()
{
   global $server;

   mysql_close($server);
}

//------------------------------------------------------------------------------
// ��������� ������ � ���� ������ � ���������� ���-�� ����������� (INSERT),
// ����������� (UPDATE) ��� ��������� (DELETE) �����
function ExecSQL($SQLText, &$Rows)
{
   global $server;
   global $strBadQuery;
   global $UnpackerErrorField;

   $Rows = 0;

   // �������� ��������� ������
   $Result = mysql_query($SQLText, $server);

   // ���� ������ ���������� ������, �� ���������� ���-�� �������
   if ($Result)
   {
      $Rows = mysql_affected_rows($server);
   }
   else // ������ �� ����������
   {
      print sprintf("$UnpackerErrorField: %s: %s\n", $strBadQuery, mysql_error());
      return mysql_errno();
   }

   return $Result;
}

//------------------------------------------------------------------------------
// ��������� ������ (SELECT) � ���������� ���-�� ��������� �����
function OpenSQL($SQLText, &$Rows, &$StoreResult)
{
   global $server;
   global $strBadQuery;
   global $strCanNotGetResult;
   global $erOk;
   global $UnpackerErrorField;

   $Rows = 0;

   // �������� ��������� ������
   $Result = mysql_query($SQLText, $server);

   // ���� ������ �� ����������
   if (!$Result)
   {
      print sprintf("$UnpackerErrorField: %s: %s\n", $strBadQuery, mysql_error());
      return mysql_errno();
   }

   // ��������� ���������� ���������� �������
   $StoreResult = $Result;

   // ���������� �� ���������
   if (!$StoreResult)
   {
      print sprintf("$UnpackerErrorField: %s: %s\n", $strCanNotGetResult, mysql_error());
      return mysql_errno();
   }

   // ��������� ���-�� ��������� �������
   $Rows = mysql_num_rows($Result);

   return $erOk;
}


//------------------------------------------------------------------------------
// ���������� �������� ���������� ���� ������� ������ (� ���� ������)
function GetFieldValue($myResult, &$Row, $FieldName, &$Value, &$IsNull)
{
   global $erOk;

   // �������� �������� ���� ����� ������� ������
   if ($Row == NULL)
     $Row = mysql_fetch_assoc($myResult);
   //echo $FieldName;
   $Value  = $Row[$FieldName];
   $IsNull = ($Value == "");

   return $erOk;
}

//------------------------------------------------------------------------------
// ���������� ��������� �� ��������� ������
function DataSeek($myResult, $ToRow, &$IsNull)
{
   global $erOk;

   // �������� �������� ���� ����� ������� ������
   if ($ToRow != NULL)
     $IsNull = mysql_data_seek($myResult, $ToRow);

   return $erOk;
}

//------------------------------------------------------------------------------
// ��������� ����� ������ � ����� (������� GOODS)
function SetGoodAmount($Value, $MoneyName)
{
   // ��������� �������
   //mysql_query("LOCK TABLES goods WRITE");
   // ������ �� ������� ��������� �����
   $sql = "SELECT * FROM goods WHERE GOODS_NAME = '$MoneyName'";
   OpenSQL ($sql, $row, $res);
   GetFieldValue ($res, $row_rec, "GOODS_AMOUNT", $db_BankSum, $IsNull);
   $db_BankSum = $db_BankSum+$Value;
   $sql = "UPDATE goods SET
             GOODS_AMOUNT = $db_BankSum
           WHERE
             GOODS_NAME = '$MoneyName'";
   ExecSQL ($sql, $row);

   if ($row) {
      return $db_BankSum;
   } else {
      return false;
   }
   // ������������ �������
   //mysql_query("UNLOCK TABLES");
}
//------------------------------------------------------------------------------

$conn = ConnectDB();
//DisconnectDB();

</script>