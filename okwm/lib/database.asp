<script language="PHP">

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");

// сообщения об ошибках
$strOk               = "Ok\n";
$strBadQuery         = "Некорректный текст SQL запроса.\n";
$strCanNotGetResult  = "Невозможно получить результат выполнения запроса.\n";
$strCanNotConnect    = "Невозможно установить соединение с SQL сервером.\n";
$strUnknownFieldName = "Неизвестное имя поля.\n";
$strCanNotFetchRow   = "Ошибка считывания записи из результата выполнения запроса.\n";
$strErrorShopDB      = "Ошибка базы данных магазина.\n";

// коды ошибок
$erOk                = 0;
$erUnknownFieldName  = -1001;

// соединения с базой данных
$server = "";

//------------------------------------------------------------------------------
// устанавливает соединение с базой данных
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
// разрывает соединение с базой данных
function DisconnectDB()
{
   global $server;

   mysql_close($server);
}

//------------------------------------------------------------------------------
// выполняет запрос к базе данных и возвращает кол-во добавленных (INSERT),
// обновленных (UPDATE) или удаленных (DELETE) строк
function ExecSQL($SQLText, &$Rows)
{
   global $server;
   global $strBadQuery;
   global $UnpackerErrorField;

   $Rows = 0;

   // пытаемся выполнить запрос
   $Result = mysql_query($SQLText, $server);

   // если запрос выполнился удачно, то запоминаем кол-во записей
   if ($Result)
   {
      $Rows = mysql_affected_rows($server);
   }
   else // запрос не выполнился
   {
      print sprintf("$UnpackerErrorField: %s: %s\n", $strBadQuery, mysql_error());
      return mysql_errno();
   }

   return $Result;
}

//------------------------------------------------------------------------------
// выполняет запрос (SELECT) и возвращает кол-во выбранных строк
function OpenSQL($SQLText, &$Rows, &$StoreResult)
{
   global $server;
   global $strBadQuery;
   global $strCanNotGetResult;
   global $erOk;
   global $UnpackerErrorField;

   $Rows = 0;

   // пытаемся выполнить запрос
   $Result = mysql_query($SQLText, $server);

   // если запрос не выполнился
   if (!$Result)
   {
      print sprintf("$UnpackerErrorField: %s: %s\n", $strBadQuery, mysql_error());
      return mysql_errno();
   }

   // сохраняем результаты выполнения запроса
   $StoreResult = $Result;

   // результаты не сохранены
   if (!$StoreResult)
   {
      print sprintf("$UnpackerErrorField: %s: %s\n", $strCanNotGetResult, mysql_error());
      return mysql_errno();
   }

   // сохраняем кол-во выбранных записей
   $Rows = mysql_num_rows($Result);

   return $erOk;
}


//------------------------------------------------------------------------------
// возвращает значение требуемого поля текущей записи (в виде строки)
function GetFieldValue($myResult, &$Row, $FieldName, &$Value, &$IsNull)
{
   global $erOk;

   // получаем значения всех полей текущей записи
   if ($Row == NULL)
     $Row = mysql_fetch_assoc($myResult);
   //echo $FieldName;
   $Value  = $Row[$FieldName];
   $IsNull = ($Value == "");

   return $erOk;
}

//------------------------------------------------------------------------------
// Перемещает указатель на требуемую строку
function DataSeek($myResult, $ToRow, &$IsNull)
{
   global $erOk;

   // получаем значения всех полей текущей записи
   if ($ToRow != NULL)
     $IsNull = mysql_data_seek($myResult, $ToRow);

   return $erOk;
}

//------------------------------------------------------------------------------
// Обновляет сумму валюты в банке (таблица GOODS)
function SetGoodAmount($Value, $MoneyName)
{
   // Блокируем таблицу
   //mysql_query("LOCK TABLES goods WRITE");
   // Запрос на текущее состояние счета
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
   // Разблокируем таблицу
   //mysql_query("UNLOCK TABLES");
}
//------------------------------------------------------------------------------

$conn = ConnectDB();
//DisconnectDB();

</script>