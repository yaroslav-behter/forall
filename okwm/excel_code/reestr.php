<?php
require_once "Spreadsheet/Excel/Writer.php";
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/excel_code/config.php");

// Create workbook
$filename = "report".date("ymdHis").".xls";
$xls =& new Spreadsheet_Excel_Writer($filename);
//$xls->_codepage = 0x04E3; // Windows-1251
$query_data  = "";//" AND($group.closed>'".$start_date."' AND $group.closed<'".$end_date."')";


// ================================================================
// Create worksheet ПРИХОД
// ================================================================
$cart =& $xls->addWorksheet('prihod');

# Add the title
// Some text to use as a title for the worksheet
$titleText = 'Реестр приходов ' . date('dS M Y');

// Create a format object
$titleFormat =& $xls->addFormat(array('Size' => 13, 'Align' => 'merge', 'Color' => 'navy',
                                      'Bold'  => '1', 'Bottom'=> '2', 'BottomColor' => 'navy'));

// Set the font family - Helvetica works for OpenOffice calc too...
$titleFormat->setFontFamily('Helvetica');
$cart->write(1,0,$titleText,$titleFormat);
$cart->write(1,1,'',$titleFormat);
$cart->write(1,2,'',$titleFormat);
//$cart->write(1,3,'',$titleFormat);

// Высота строки
$cart->setRow(1,30);
// Формат для заголовка
$colHeadingFormat =& $xls->addFormat(array('Size' => 10, 'Align' => 'center', 'Border'  => '1', 'Bottom'=> '2'));
$colHeadingFormat->setFontFamily('Helvetica');
$colHeadingFormat->setVAlign('vcenter');
$colHeadingFormat->setTextWrap();
// Ширина колонок
$cart->setColumn(0,0,7); // A - Номер п/п
$cart->setColumn(1,1,18); // B - Дата операции
$cart->setColumn(2,2,50); // C - Примечание
$cart->setColumn(3,14,10); // D-L валюты
$cart->setColumn(15,24,12); // E - Логин ...

# Вставка заголовка
// An array with the data for the column headings
$colNames = array('N п/п','Дата','Примечание',"грн","Доллар","Евро","Справочно $","WMU", "WMZ","WME","WMR",
                  "Betfair \$", "Betfair EUR", "Wire \$", "Wire EUR", "Справочно $",
                  "Логин", "Клиент", "Кто добавил", "Когда добавил", "Кто закрыл", "Когда закрыл", "Результат", "грн", "EUR", "руб");

// Add all the column headings with a single call
// leaving a blank row to look nicer
$cart->writeRow(3,0,$colNames,$colHeadingFormat);//,$colHeadingFormat);

// Группа ячеек для замораживания
// 1-ый Аргумент - позиция вертикального обьединения
// 2-ой Аргумент - позиция горизонтального обьединения (0 = нет горизонтального обьединения)
// 3-ий Аргумент - верхняя видимая строка внизу вертикального объединения
// 4-ий Аргумент - левый видимый столбец после горизнотального объединения
// Сделать всегда видимыми 4 сверзу, 1 слева
$freeze = array(4,1,4,1);

// Заморозить эти ячейки!
$cart->freezePanes($freeze);

//============= SQL ==================================================
   $sqlSumField = "";
   for ($i=0; $i<count($sumFields); $i++)   	  $sqlSumField.= "SUM(".$sumFields[$i]."), ";
   $sqlSumField = substr($sqlSumField, 0, -2);

   // Выбор всех закрытых групп операций для ПРИХОДА (iUAN||iUSD||iEUR<>0), кроме групп Офис(9) и групп Игорь(15)
   $sql = "SELECT *, MIN(Descr), $sqlSumField FROM $table
           LEFT OUTER JOIN $group ON ($table.group_id = $group.id)
           INNER JOIN $client ON ($table.id_client = $client.id_client)
           WHERE error Is NULL AND ($table.group_id IS NOT NULL) AND ($group.closed IS NOT NULL) AND ($table.id_client<>9) AND ($table.id_client<>15)
           $query_data
           GROUP BY $table.group_id
           ORDER BY DateTS";
           // ((iUAH<>'')OR(iUSD<>'')OR(iEUR<>'')) AND

   $closed_group_row = OpenSQL ($sql, $closed_group_rows, $closed_group_res);


// Формат для заголовка
$colDataFormat =& $xls->addFormat(array('Border'  => '1'));
$colDataFormat->setTextWrap();
$colDataFormat->setVAlign('vequal_space');
// Формат для сумм
$colSumFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00'));
// Формат для формул
$colFormula =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00', 'locked' => 1, 'FgColor' => 22));
// Табличка для строки
$rowFormat =& $xls->addFormat(array('Border'  => '1'));
$rowFormat->setVAlign('vequal_space');
//Формат для курсов (5 знаков после запятой)
$colCourseFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00000'));

// Use this to keep track of the current row number
$currentRow = 4;

if (!$closed_group_row) {	for ($i=0; $i<$closed_group_rows; $i++) {        $row = NULL;
        $cart->setRow($currentRow,30, $rowFormat);
        // Проверка на тип операции (Приход)  -- относительно
		GetFieldValue ($closed_group_res, $row, 'SUM(iUAH)', $SUMiUAH, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oUAH)', $SUMoUAH, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oUSD)', $SUMoUSD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(iUSD)', $SUMiUSD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(iEUR)', $SUMiEUR, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oEUR)', $SUMoEUR, $IsNull);
        // Курсы валют
		GetFieldValue ($closed_group_res, $row, 'USD', $USD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'EUR', $EUR, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'RUR', $RUR, $IsNull);
		$SUM_CASH = ($SUMiUAH-$SUMoUAH)/$USD+$SUMiUSD-$SUMoUSD+($SUMiEUR-$SUMoEUR)*$EUR/$USD;
		if ($SUM_CASH>0) {			// Приход нала больше чем расход, следовательно операция ПРИХОДНАЯ
			// N п/п | Дата | Примечание | грн | Доллар | Евро | Справочно, доллар | WMU| WMZ | WME | ... | Логин | Клиент | кто открыл | когда открыл | кто закрыл | когда закрыл	        // N п/п
			GetFieldValue ($closed_group_res, $row, 'group_id', $group_id, $IsNull);
			$cart->writeUrl($currentRow,0,"$http/s/editgroup.asp?do=edit&group_id=".md5($group_id+$group_id),$group_id, $colDataFormat);
			// Дата закрытия группы
			GetFieldValue ($closed_group_res, $row, 'closed', $closed, $IsNull);
	        $cart->write($currentRow,1,$closed, $colDataFormat);
	        // Описание (В примечании к ячейке описание всех строк, т.е. полное описание группы)
			GetFieldValue ($closed_group_res, $row, 'MIN(Descr)', $Descr, $IsNull);
	        $Descr = str_replace("!","",$Descr);
	        $Descr = str_replace("Спасибо за выбор нашего сервиса","",$Descr);
	        $Descr = str_replace("Комиссия Webmoney. ","",$Descr);
	        $cart->writeString($currentRow,2,$Descr, $colDataFormat);
	        // Формирование полного описания группы по строкам
	        $sql_descr = "SELECT descr FROM $table WHERE group_id = $group_id";
	        $descr_row = OpenSQL ($sql_descr, $descr_rows, $descr_res);
	        if (!$descr_row) {	        	$all_descr = "";	        	for ($j=0; $j<$descr_rows; $j++) {	        		$row_descr = NULL;	        		GetFieldValue ($descr_res, $row_descr, 'descr', $Descr_transaction, $IsNull);
	        		if (!ereg("Комиссия Webmoney", $Descr_transaction)) {	        			$Descr_transaction = str_replace("Спасибо за выбор нашего сервиса","",$Descr_transaction);
	        			$Descr_transaction = str_replace("!","",$Descr_transaction);
	        			$all_descr.= $Descr_transaction."\r\n";
	        		}
	            }
	            $cart->writeNote($currentRow,2,$all_descr);
	        }
	        // Входящий нал
	        if ($SUMoUAH-$SUMiUAH<>0) $cart->write($currentRow,3,$SUMiUAH-$SUMoUAH, $colSumFormat);
	        if ($SUMoUSD-$SUMiUSD<>0) $cart->write($currentRow,4,$SUMiUSD-$SUMoUSD, $colSumFormat);
	        if ($SUMoEUR-$SUMiEUR<>0) $cart->write($currentRow,5,$SUMiEUR-$SUMoEUR, $colSumFormat);
	        // Справочно, Доллар
			$excelRow = $currentRow + 1;
			$formula = "=(D$excelRow/X$excelRow) + E$excelRow + (F$excelRow*Y$excelRow/X$excelRow)" ;
			$cart->writeFormula($currentRow,6, $formula, $colFormula);
	        // Исходящая валюта
			GetFieldValue ($closed_group_res, $row, 'SUM(iWMU)', $SUMiWMU, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oWMU)', $SUMoWMU, $IsNull);
	        if ($SUMoWMU-$SUMiWMU<>0) $cart->write($currentRow,7, $SUMoWMU-$SUMiWMU, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iWMZ)', $SUMiWMZ, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oWMZ)', $SUMoWMZ, $IsNull);
	        if ($SUMoWMZ-$SUMiWMZ<>0) $cart->write($currentRow,8, $SUMoWMZ-$SUMiWMZ, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iWME)', $SUMiWME, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oWME)', $SUMoWME, $IsNull);
	        if ($SUMoWME-$SUMiWME<>0) $cart->write($currentRow,9, $SUMoWME-$SUMiWME, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iWMR)', $SUMiWMR, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oWMR)', $SUMoWMR, $IsNull);
	        if ($SUMoWMR-$SUMiWMR<>0) $cart->write($currentRow,10, $SUMoWMR-$SUMiWMR, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iBFU)', $SUMiBFU, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oBFU)', $SUMoBFU, $IsNull);
	        if ($SUMoBFU-$SUMiBFU<>0) $cart->write($currentRow,11, $SUMoBFU-$SUMiBFU, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iBFE)', $SUMiBFE, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oBFE)', $SUMoBFE, $IsNull);
	        if ($SUMoBFE-$SUMiBFE<>0) $cart->write($currentRow,12, $SUMoBFE-$SUMiBFE, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iBWU)', $SUMiBWU, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oBWU)', $SUMoBWU, $IsNull);
	        if ($SUMoBWU-$SUMiBWU<>0) $cart->write($currentRow,13, $SUMoBWU-$SUMiBWU, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iBWE)', $SUMiBWE, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oBWE)', $SUMoBWE, $IsNull);
	        if ($SUMoBWE-$SUMiBWE<>0) $cart->write($currentRow,14, $SUMoBWE-$SUMiBWE, $colSumFormat);
	        // Справочно, Доллар
			$formula = "=(H$excelRow/X$excelRow) + I$excelRow + (J$excelRow*Y$excelRow/X$excelRow) + (K$excelRow*Z$excelRow/X$excelRow)".
			           "+ L$excelRow + (M$excelRow*Y$excelRow/X$excelRow) + N$excelRow + (O$excelRow*Y$excelRow/X$excelRow)" ;
			$cart->writeFormula($currentRow,15, $formula, $colFormula);

            // Вспомогательная информация
			GetFieldValue ($closed_group_res, $row, 'login', $login, $IsNull);
			$cart->write($currentRow,16, $login, $colDataFormat);
			GetFieldValue ($closed_group_res, $row, 'name_client', $name_client, $IsNull);
			$cart->write($currentRow,17, $name_client, $colDataFormat);
			GetFieldValue ($closed_group_res, $row, 'whoadded', $whoadded, $IsNull);
			$cart->write($currentRow,18, $whoadded, $colDataFormat);
			GetFieldValue ($closed_group_res, $row, 'added', $added, $IsNull);
			$cart->write($currentRow,19, $added, $colDataFormat);
			GetFieldValue ($closed_group_res, $row, 'whoclosed', $whoclosed, $IsNull);
			$cart->write($currentRow,20, $whoclosed, $colDataFormat);
			GetFieldValue ($closed_group_res, $row, 'closed', $closed, $IsNull);
			$cart->write($currentRow,21, $closed, $colDataFormat);

			$formula = "=G$excelRow-P$excelRow" ;
			$cart->writeFormula($currentRow,22, $formula, $colFormula);

	        // Курсы валют НБУ
	        $cart->write($currentRow,23,$USD, $colCourseFormat);
	        $cart->write($currentRow,24,$EUR, $colCourseFormat);
	        $cart->write($currentRow,25,$RUR, $colCourseFormat);
	        $currentRow++;
	    }
    }
}
// The first row as Excel knows it - $currentRow was 4 at the start
$startingExcelRow = 5;

// The final row as Excel
// (which is the same as the currentRow once the loop ends)
$finalExcelRow = $currentRow;

// Excel formal to sum all the item totals to get the grand total
$dTFormula = '=SUM(D'.$startingExcelRow.':D'.$finalExcelRow.')';
$eTFormula = '=SUM(E'.$startingExcelRow.':E'.$finalExcelRow.')';
$fTFormula = '=SUM(F'.$startingExcelRow.':F'.$finalExcelRow.')';
$gTFormula = '=SUM(G'.$startingExcelRow.':G'.$finalExcelRow.')';
$hTFormula = '=SUM(H'.$startingExcelRow.':H'.$finalExcelRow.')';
$iTFormula = '=SUM(I'.$startingExcelRow.':I'.$finalExcelRow.')';
$jTFormula = '=SUM(J'.$startingExcelRow.':J'.$finalExcelRow.')';
$kTFormula = '=SUM(K'.$startingExcelRow.':K'.$finalExcelRow.')';
$lTFormula = '=SUM(L'.$startingExcelRow.':L'.$finalExcelRow.')';
$mTFormula = '=SUM(M'.$startingExcelRow.':M'.$finalExcelRow.')';
$nTFormula = '=SUM(N'.$startingExcelRow.':N'.$finalExcelRow.')';
$oTFormula = '=SUM(O'.$startingExcelRow.':O'.$finalExcelRow.')';
$pTFormula = '=SUM(P'.$startingExcelRow.':P'.$finalExcelRow.')';
$wTFormula = '=SUM(W'.$startingExcelRow.':W'.$finalExcelRow.')';

// Some more formatting for the grand total cells
$gTFormat =& $xls->addFormat(array("NumFormat"=>"0.00", 'locked' => 1, 'bottom'=> '1','top'=>'1','left'=>'1','right'=>'1', 'FgColor' => 11));
$gTFormat->setFontFamily('Helvetica');
$gTFormat->setBold();

// Add some text plus formatting
$cart->write($currentRow,0,'Всего:',$gTFormat);

// Add the grand total formula along with the format
$cart->writeFormula($currentRow,3,$dTFormula,$gTFormat);
$cart->writeFormula($currentRow,4,$eTFormula,$gTFormat);
$cart->writeFormula($currentRow,5,$fTFormula,$gTFormat);
$cart->writeFormula($currentRow,6,$gTFormula,$gTFormat);
$cart->writeFormula($currentRow,7,$hTFormula,$gTFormat);
$cart->writeFormula($currentRow,8,$iTFormula,$gTFormat);
$cart->writeFormula($currentRow,9,$jTFormula,$gTFormat);
$cart->writeFormula($currentRow,10,$kTFormula,$gTFormat);
$cart->writeFormula($currentRow,11,$lTFormula,$gTFormat);
$cart->writeFormula($currentRow,12,$mTFormula,$gTFormat);
$cart->writeFormula($currentRow,13,$nTFormula,$gTFormat);
$cart->writeFormula($currentRow,14,$oTFormula,$gTFormat);
$cart->writeFormula($currentRow,15,$pTFormula,$gTFormat);
$cart->writeFormula($currentRow,22,$wTFormula,$gTFormat);
$sumRowPrihod = $currentRow+1;

// ================================================================
// Create worksheet РАСХОД
// ================================================================
$cart =& $xls->addWorksheet('rashod');

# Add the title
// Some text to use as a title for the worksheet
$titleText = 'Реестр расходов ' . date('dS M Y');

// Create a format object
$titleFormat =& $xls->addFormat(array('Size' => 13, 'Align' => 'merge', 'Color' => 'navy',
                                      'Bold'  => '1', 'Bottom'=> '2', 'BottomColor' => 'navy'));

// Set the font family - Helvetica works for OpenOffice calc too...
$titleFormat->setFontFamily('Helvetica');
$cart->write(1,0,$titleText,$titleFormat);
$cart->write(1,1,'',$titleFormat);
$cart->write(1,2,'',$titleFormat);
//$cart->write(1,3,'',$titleFormat);

// Высота строки
$cart->setRow(1,30);
// Формат для заголовка
$colHeadingFormat =& $xls->addFormat(array('Size' => 10, 'Align' => 'center', 'Border'  => '1', 'Bottom'=> '2'));
$colHeadingFormat->setFontFamily('Helvetica');
$colHeadingFormat->setVAlign('vcenter');
$colHeadingFormat->setTextWrap();
// Ширина колонок
$cart->setColumn(0,0,7); // A - Номер п/п
$cart->setColumn(1,1,18); // B - Дата операции
$cart->setColumn(2,2,50); // C - Примечание
$cart->setColumn(3,14,10); // D-L валюты
$cart->setColumn(15,24,12); // E - Логин ...

# Вставка заголовка
$colNames = array('N п/п','Дата','Примечание',"WMU", "WMZ","WME","WMR", "Betfair \$", "Betfair EUR", "Wire \$", "Wire EUR", "Справочно $",
                  "грн","Доллар","Евро","Справочно $",
                  "Логин", "Клиент", "Кто добавил", "Когда добавил", "Кто закрыл", "Когда закрыл", "Результат", "грн", "EUR", "руб");

$cart->writeRow(3,0,$colNames,$colHeadingFormat);

$freeze = array(4,1,4,1);

// Заморозить эти ячейки!
$cart->freezePanes($freeze);

//============= SQL ==================================================
   $sqlSumField = "";
   for ($i=0; $i<count($sumFields); $i++)
   	  $sqlSumField.= "SUM(".$sumFields[$i]."), ";
   $sqlSumField = substr($sqlSumField, 0, -2);

   // Выбор всех закрытых групп операций для ПРИХОДА (iUAN||iUSD||iEUR<>0), кроме групп Офис(9) и групп Игорь(15)
   $sql = "SELECT *, MIN(Descr), $sqlSumField FROM $table
           LEFT OUTER JOIN $group ON ($table.group_id = $group.id)
           INNER JOIN $client ON ($table.id_client = $client.id_client)
           WHERE error Is NULL AND ($table.group_id IS NOT NULL) AND ($group.closed IS NOT NULL) AND ($table.id_client<>9) AND ($table.id_client<>15)
           $query_data
           GROUP BY $table.group_id
           ORDER BY DateTS";
           // ((iUAH<>'')OR(iUSD<>'')OR(iEUR<>'')) AND

   $closed_group_row = OpenSQL ($sql, $closed_group_rows, $closed_group_res);


// Формат для заголовка
$colDataFormat =& $xls->addFormat(array('Border'  => '1'));
$colDataFormat->setVAlign('vequal_space');
$colDataFormat->setTextWrap();
// Формат для сумм
$colSumFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00'));
// Формат для формул
$colFormula =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00', 'locked' => 1, 'FgColor' => 22));
// Табличка для строки
$rowFormat =& $xls->addFormat(array('Border'  => '1'));
//Формат для курсов (5 знаков после запятой)
$colCourseFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00000'));

// Use this to keep track of the current row number
$currentRow = 4;

if (!$closed_group_row) {
	for ($i=0; $i<$closed_group_rows; $i++) {
        $row = NULL;
        $cart->setRow($currentRow,30, $rowFormat);
        // Проверка на тип операции (Приход)  -- относительно
		GetFieldValue ($closed_group_res, $row, 'SUM(iUAH)', $SUMiUAH, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oUAH)', $SUMoUAH, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oUSD)', $SUMoUSD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(iUSD)', $SUMiUSD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(iEUR)', $SUMiEUR, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oEUR)', $SUMoEUR, $IsNull);
        // Курсы валют
		GetFieldValue ($closed_group_res, $row, 'USD', $USD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'EUR', $EUR, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'RUR', $RUR, $IsNull);
		$SUM_CASH = ($SUMiUAH-$SUMoUAH)/$USD+$SUMiUSD-$SUMoUSD+($SUMiEUR-$SUMoEUR)*$EUR/$USD;
		if ($SUM_CASH<0) {
			// Расход нала больше чем приход, следовательно операция РАСХОДНАЯ

			// N п/п | Дата | Примечание | грн | Доллар | Евро | Справочно, доллар | WMU| WMZ | WME | ... | Логин | Клиент | кто открыл | когда открыл | кто закрыл | когда закрыл
	        // N п/п
			GetFieldValue ($closed_group_res, $row, 'group_id', $group_id, $IsNull);
			$cart->writeUrl($currentRow,0,"$http/s/editgroup.asp?do=edit&group_id=".md5($group_id+$group_id),$group_id, $colDataFormat);
			// Дата закрытия группы
			GetFieldValue ($closed_group_res, $row, 'closed', $closed, $IsNull);
	        $cart->write($currentRow,1,$closed, $colDataFormat);
	        // Описание (В примечании к ячейке описание всех строк, т.е. полное описание группы)
			GetFieldValue ($closed_group_res, $row, 'MIN(Descr)', $Descr, $IsNull);
	        $Descr = str_replace("!","",$Descr);
	        $cart->writeString($currentRow,2,$Descr, $colDataFormat);
	        // Формирование полного описания группы по строкам
	        $sql_descr = "SELECT descr FROM $table WHERE group_id = $group_id";
	        $descr_row = OpenSQL ($sql_descr, $descr_rows, $descr_res);
	        if (!$descr_row) {
	        	$all_descr = "";
	        	for ($j=0; $j<$descr_rows; $j++) {
	        		$row_descr = NULL;
	        		GetFieldValue ($descr_res, $row_descr, 'descr', $Descr_transaction, $IsNull);
	        		if (!ereg("Комиссия Webmoney", $Descr_transaction)) {
	        			$Descr_transaction = str_replace("Спасибо за выбор нашего сервиса","",$Descr_transaction);
	        			$Descr_transaction = str_replace("!","",$Descr_transaction);
	        			$all_descr.= $Descr_transaction."\r\n";
	        		}
	            }
	            $cart->writeNote($currentRow,2,$all_descr);
	        }
	        // Входящая валюта
			GetFieldValue ($closed_group_res, $row, 'SUM(iWMU)', $SUMiWMU, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oWMU)', $SUMoWMU, $IsNull);
	        if ($SUMiWMU-$SUMoWMU<>0) $cart->write($currentRow,3, $SUMiWMU-$SUMoWMU, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iWMZ)', $SUMiWMZ, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oWMZ)', $SUMoWMZ, $IsNull);
	        if ($SUMiWMZ-$SUMoWMZ<>0) $cart->write($currentRow,4, $SUMiWMZ-$SUMoWMZ, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iWME)', $SUMiWME, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oWME)', $SUMoWME, $IsNull);
	        if ($SUMiWME-$SUMoWME<>0) $cart->write($currentRow,5, $SUMiWME-$SUMoWME, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iWMR)', $SUMiWMR, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oWMR)', $SUMoWMR, $IsNull);
	        if ($SUMiWMR-$SUMoWMR<>0) $cart->write($currentRow,6, $SUMiWMR-$SUMoWMR, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iBFU)', $SUMiBFU, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oBFU)', $SUMoBFU, $IsNull);
	        if ($SUMiBFU-$SUMoBFU<>0) $cart->write($currentRow,7, $SUMiBFU-$SUMoBFU, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iBFE)', $SUMiBFE, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oBFE)', $SUMoBFE, $IsNull);
	        if ($SUMiBFE-$SUMoBFE<>0) $cart->write($currentRow,8, $SUMiBFE-$SUMoBFE, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iBWU)', $SUMiBWU, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oBWU)', $SUMoBWU, $IsNull);
	        if ($SUMiBWU-$SUMoBWU<>0) $cart->write($currentRow,9, $SUMiBWU-$SUMoBWU, $colSumFormat);
			GetFieldValue ($closed_group_res, $row, 'SUM(iBWE)', $SUMiBWE, $IsNull);
			GetFieldValue ($closed_group_res, $row, 'SUM(oBWE)', $SUMoBWE, $IsNull);
	        if ($SUMiBWE-$SUMoBWE<>0) $cart->write($currentRow,10, $SUMiBWE-$SUMoBWE, $colSumFormat);
	        // Справочно, Доллар
			$formula = "=(D$excelRow/X$excelRow) + E$excelRow + (F$excelRow*Y$excelRow/X$excelRow) + (G$excelRow*Z$excelRow/X$excelRow)".
			           "+ H$excelRow + (I$excelRow*Y$excelRow/X$excelRow) + J$excelRow + (K$excelRow*Y$excelRow/X$excelRow)" ;
			$cart->writeFormula($currentRow,11, $formula, $colFormula);
	        // Исходящий нал
	        if ($SUMiUAH-$SUMoUAH<>0) $cart->write($currentRow,12,$SUMoUAH-$SUMiUAH, $colSumFormat);
	        if ($SUMiUSD-$SUMoUSD<>0) $cart->write($currentRow,13,$SUMoUSD-$SUMiUSD, $colSumFormat);
	        if ($SUMiEUR-$SUMoEUR<>0) $cart->write($currentRow,14,$SUMoEUR-$SUMiEUR, $colSumFormat);
	        // Справочно, Доллар
			$excelRow = $currentRow + 1;
			$formula = "=(M$excelRow/X$excelRow) + N$excelRow + (O$excelRow*Y$excelRow/X$excelRow)" ;
			$cart->writeFormula($currentRow,15, $formula, $colFormula);

            // Вспомогательная информация
			GetFieldValue ($closed_group_res, $row, 'login', $login, $IsNull);
			$cart->write($currentRow,16, $login, $colDataFormat);
			GetFieldValue ($closed_group_res, $row, 'name_client', $name_client, $IsNull);
			$cart->write($currentRow,17, $name_client, $colDataFormat);
			GetFieldValue ($closed_group_res, $row, 'whoadded', $whoadded, $IsNull);
			$cart->write($currentRow,18, $whoadded, $colDataFormat);
			GetFieldValue ($closed_group_res, $row, 'added', $added, $IsNull);
			$cart->write($currentRow,19, $added, $colDataFormat);
			GetFieldValue ($closed_group_res, $row, 'whoclosed', $whoclosed, $IsNull);
			$cart->write($currentRow,20, $whoclosed, $colDataFormat);
			GetFieldValue ($closed_group_res, $row, 'closed', $closed, $IsNull);
			$cart->write($currentRow,21, $closed, $colDataFormat);

			$formula = "=L$excelRow-P$excelRow" ;
			$cart->writeFormula($currentRow,22, $formula, $colFormula);

	        // Курсы валют НБУ
	        $cart->write($currentRow,23,$USD, $colCourseFormat);
	        $cart->write($currentRow,24,$EUR, $colCourseFormat);
	        $cart->write($currentRow,25,$RUR, $colCourseFormat);
	        $currentRow++;
	    }
    }
}

// The first row as Excel knows it - $currentRow was 4 at the start
$startingExcelRow = 5;

// The final row as Excel
// (which is the same as the currentRow once the loop ends)
$finalExcelRow = $currentRow;

// Excel formal to sum all the item totals to get the grand total
$dTFormula = '=SUM(D'.$startingExcelRow.':D'.$finalExcelRow.')';
$eTFormula = '=SUM(E'.$startingExcelRow.':E'.$finalExcelRow.')';
$fTFormula = '=SUM(F'.$startingExcelRow.':F'.$finalExcelRow.')';
$gTFormula = '=SUM(G'.$startingExcelRow.':G'.$finalExcelRow.')';
$hTFormula = '=SUM(H'.$startingExcelRow.':H'.$finalExcelRow.')';
$iTFormula = '=SUM(I'.$startingExcelRow.':I'.$finalExcelRow.')';
$jTFormula = '=SUM(J'.$startingExcelRow.':J'.$finalExcelRow.')';
$kTFormula = '=SUM(K'.$startingExcelRow.':K'.$finalExcelRow.')';
$lTFormula = '=SUM(L'.$startingExcelRow.':L'.$finalExcelRow.')';
$mTFormula = '=SUM(M'.$startingExcelRow.':M'.$finalExcelRow.')';
$nTFormula = '=SUM(N'.$startingExcelRow.':N'.$finalExcelRow.')';
$oTFormula = '=SUM(O'.$startingExcelRow.':O'.$finalExcelRow.')';
$pTFormula = '=SUM(P'.$startingExcelRow.':P'.$finalExcelRow.')';
$wTFormula = '=SUM(W'.$startingExcelRow.':W'.$finalExcelRow.')';

// Some more formatting for the grand total cells
$gTFormat =& $xls->addFormat(array("NumFormat"=>"0.00", 'locked' => 1, 'bottom'=> '1','top'=>'1','left'=>'1','right'=>'1', 'FgColor' => 11));
$gTFormat->setFontFamily('Helvetica');
$gTFormat->setBold();

// Add some text plus formatting
$cart->write($currentRow,0,'Всего:',$gTFormat);

// Add the grand total formula along with the format
$cart->writeFormula($currentRow,3,$dTFormula,$gTFormat);
$cart->writeFormula($currentRow,4,$eTFormula,$gTFormat);
$cart->writeFormula($currentRow,5,$fTFormula,$gTFormat);
$cart->writeFormula($currentRow,6,$gTFormula,$gTFormat);
$cart->writeFormula($currentRow,7,$hTFormula,$gTFormat);
$cart->writeFormula($currentRow,8,$iTFormula,$gTFormat);
$cart->writeFormula($currentRow,9,$jTFormula,$gTFormat);
$cart->writeFormula($currentRow,10,$kTFormula,$gTFormat);
$cart->writeFormula($currentRow,11,$lTFormula,$gTFormat);
$cart->writeFormula($currentRow,12,$mTFormula,$gTFormat);
$cart->writeFormula($currentRow,13,$nTFormula,$gTFormat);
$cart->writeFormula($currentRow,14,$oTFormula,$gTFormat);
$cart->writeFormula($currentRow,15,$pTFormula,$gTFormat);
$cart->writeFormula($currentRow,22,$wTFormula,$gTFormat);
$sumRowRashod = $currentRow+1;

// ================================================================
// Create worksheet ОФИС
// ================================================================
$cart =& $xls->addWorksheet('office');

# Add the title
// Some text to use as a title for the worksheet
$titleText = 'Реестр расходов по офисам ' . date('dS M Y');

// Create a format object
$titleFormat =& $xls->addFormat(array('Size' => 13, 'Align' => 'merge', 'Color' => 'navy',
                                      'Bold'  => '1', 'Bottom'=> '2', 'BottomColor' => 'navy'));

// Set the font family - Helvetica works for OpenOffice calc too...
$titleFormat->setFontFamily('Helvetica');
$cart->write(1,0,$titleText,$titleFormat);
$cart->write(1,1,'',$titleFormat);
$cart->write(1,2,'',$titleFormat);
//$cart->write(1,3,'',$titleFormat);

// Высота строки
$cart->setRow(1,30);
// Формат для заголовка
$colHeadingFormat =& $xls->addFormat(array('Size' => 10, 'Align' => 'center', 'Border'  => '1', 'Bottom'=> '1','top'=>'1','left'=>'1','right'=>'1'));
$colHeadingFormat->setFontFamily('Helvetica');
$colHeadingFormat->setVAlign('vcenter');
$colHeadingFormat->setTextWrap();
// Ширина колонок
$cart->setColumn(0,0,7); // A - Номер п/п
$cart->setColumn(1,1,18); // B - Дата операции
$cart->setColumn(2,2,50); // C - Примечание
$cart->setColumn(3,26,10); // D-L валюты
$cart->setColumn(27,38,12); // E - Логин ...

# Вставка заголовка
$colNames1 = array('N п/п','Дата','Примечание');
$colNames2 = array("Логин", "Клиент", "Кто добавил", "Когда добавил", "Кто закрыл", "Когда закрыл", "грн", "EUR", "руб");
$colNames3 = array("грн","Доллар","Евро", "WMU", "WMZ","WME","WMR","Betfair \$", "Betfair EUR", "Wire \$", "Wire EUR", "Справочно, \$");
$cart->writeRow(4,0,$colNames1,$colHeadingFormat);$cart->write(5,0,"",$colHeadingFormat);$cart->write(5,1,"",$colHeadingFormat);$cart->write(5,2,"",$colHeadingFormat);
$cart->write(4,3,"Приход",$colHeadingFormat);for ($i=0; $i<count($colNames3)-1; $i++) $cart->write(4,4+$i,"",$colHeadingFormat);
$cart->write(4,15,"Расход",$colHeadingFormat);for ($i=0; $i<count($colNames3)-1; $i++) $cart->write(4,16+$i,"",$colHeadingFormat);
$cart->writeRow(4,27,$colNames2,$colHeadingFormat);
$cart->writeRow(5,3,$colNames3,$colHeadingFormat);
$cart->writeRow(5,15,$colNames3,$colHeadingFormat);
for ($i=0; $i<count($colNames2); $i++) $cart->write(5,27+$i,"",$colHeadingFormat);
$cart->mergeCells(4,3,4,14);
$cart->mergeCells(4,15,4,26);
$cart->mergeCells(4,0,5,0);$cart->mergeCells(4,1,5,1);$cart->mergeCells(4,2,5,2);
$cart->mergeCells(4,27,5,27);$cart->mergeCells(4,28,5,28);$cart->mergeCells(4,29,5,29);$cart->mergeCells(4,30,5,30);
$cart->mergeCells(4,31,5,31);$cart->mergeCells(4,32,5,32);$cart->mergeCells(4,33,5,33);$cart->mergeCells(4,34,5,34);
$cart->mergeCells(4,35,5,35);$cart->mergeCells(4,36,5,36);

// Заморозить эти ячейки
$freeze = array(6,2,6,2);
$cart->freezePanes($freeze);

//============= SQL ==================================================
   $sqlSumField = "";
   for ($i=0; $i<count($sumFields); $i++)
   	  $sqlSumField.= "SUM(".$sumFields[$i]."), ";
   $sqlSumField = substr($sqlSumField, 0, -2);

   // Выбор всех закрытых групп операций для ПРИХОДА и РАСХОДА по группам Офис(9)
   $sql = "SELECT *, MIN(Descr), $sqlSumField FROM $table
           LEFT OUTER JOIN $group ON ($table.group_id = $group.id)
           INNER JOIN $client ON ($table.id_client = $client.id_client)
           WHERE error Is NULL AND ($table.group_id IS NOT NULL) AND ($table.id_client=9)
           $query_data
           GROUP BY $table.group_id
           ORDER BY DateTS";

   $closed_group_row = OpenSQL ($sql, $closed_group_rows, $closed_group_res);


// Формат для заголовка
$colDataFormat =& $xls->addFormat(array('Border'  => '1'));
$colDataFormat->setTextWrap();
$colDataFormat->setVAlign('vequal_space');
// Формат для сумм
$colSumFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00'));
// Формат для формул
$colFormula =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00', 'locked' => 1, 'FgColor' => 22));
// Табличка для строки
$rowFormat =& $xls->addFormat(array('Border'  => '1'));
//Формат для курсов (5 знаков после запятой)
$colCourseFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00000'));

// Use this to keep track of the current row number
$currentRow = 6;

if (!$closed_group_row) {
	for ($i=0; $i<$closed_group_rows; $i++) {
        $row = NULL;
        for ($cell=3; $cell<=35; $cell++) $cart->write($currentRow,$cell,"",$rowFormat);
        // Проверка на тип операции (Приход)  -- относительно
		GetFieldValue ($closed_group_res, $row, 'SUM(iUAH)', $SUMiUAH, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oUAH)', $SUMoUAH, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oUSD)', $SUMoUSD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(iUSD)', $SUMiUSD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(iEUR)', $SUMiEUR, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oEUR)', $SUMoEUR, $IsNull);
        // Курсы валют
		GetFieldValue ($closed_group_res, $row, 'USD', $USD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'EUR', $EUR, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'RUR', $RUR, $IsNull);

		// N п/п | Дата | Примечание | грн | Доллар | Евро | Справочно, доллар | WMU| WMZ | WME | ... | Логин | Клиент==Офис | кто открыл | когда открыл | кто закрыл | когда закрыл
        // N п/п
		GetFieldValue ($closed_group_res, $row, 'group_id', $group_id, $IsNull);
		$cart->writeUrl($currentRow,0,"$http/s/editgroup.asp?do=edit&group_id=".md5($group_id+$group_id),$group_id, $colDataFormat);
		// Дата закрытия группы
		GetFieldValue ($closed_group_res, $row, 'closed', $closed, $IsNull);
        $cart->write($currentRow,1,$closed, $colDataFormat);
        // Описание (В примечании к ячейке описание всех строк, т.е. полное описание группы)
		GetFieldValue ($closed_group_res, $row, 'MIN(Descr)', $Descr, $IsNull);
        $Descr = str_replace("!","",$Descr);
        $cart->writeString($currentRow,2,$Descr, $colDataFormat);
        // Формирование полного описания группы по строкам
        $sql_descr = "SELECT descr FROM $table WHERE group_id = $group_id";
        $descr_row = OpenSQL ($sql_descr, $descr_rows, $descr_res);
        if (!$descr_row) {
        	$all_descr = "";
        	for ($j=0; $j<$descr_rows; $j++) {
        		$row_descr = NULL;
        		GetFieldValue ($descr_res, $row_descr, 'descr', $Descr_transaction, $IsNull);
        		if (!ereg("Комиссия Webmoney", $Descr_transaction)) {
        			$Descr_transaction = str_replace("Спасибо за выбор нашего сервиса","",$Descr_transaction);
        			$Descr_transaction = str_replace("!","",$Descr_transaction);
        			$all_descr.= $Descr_transaction."\r\n";
        		}
            }
            $cart->writeNote($currentRow,2,$all_descr);
        }
        // Полученый нал
        if ($SUMiUAH<>0) $cart->write($currentRow,3,$SUMiUAH, $colSumFormat);
        if ($SUMiUSD<>0) $cart->write($currentRow,4,$SUMiUSD, $colSumFormat);
        if ($SUMiEUR<>0) $cart->write($currentRow,5,$SUMiEUR, $colSumFormat);
        // Входящая валюта
		GetFieldValue ($closed_group_res, $row, 'SUM(iWMU)', $SUMiWMU, $IsNull);
        if ($SUMiWMU<>0) $cart->write($currentRow,6, $SUMiWMU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iWMZ)', $SUMiWMZ, $IsNull);
        if ($SUMiWMZ<>0) $cart->write($currentRow,7, $SUMiWMZ, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iWME)', $SUMiWME, $IsNull);
        if ($SUMiWME<>0) $cart->write($currentRow,8, $SUMiWME, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iWMR)', $SUMiWMR, $IsNull);
        if ($SUMiWMR<>0) $cart->write($currentRow,9, $SUMiWMR, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iBFU)', $SUMiBFU, $IsNull);
        if ($SUMiBFU<>0) $cart->write($currentRow,10, $SUMiBFU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iBFE)', $SUMiBFE, $IsNull);
        if ($SUMiBFE<>0) $cart->write($currentRow,11, $SUMiBFE, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iBWU)', $SUMiBWU, $IsNull);
        if ($SUMiBWU<>0) $cart->write($currentRow,12, $SUMiBWU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iBWE)', $SUMiBWE, $IsNull);
        if ($SUMiBWE<>0) $cart->write($currentRow,13, $SUMiBWE, $colSumFormat);

        // Выданый нал
        if ($SUMoUAH<>0) $cart->write($currentRow,15,$SUMoUAH, $colSumFormat);
        if ($SUMoUSD<>0) $cart->write($currentRow,16,$SUMoUSD, $colSumFormat);
        if ($SUMoEUR<>0) $cart->write($currentRow,17,$SUMoEUR, $colSumFormat);
        // Исходящая валюта
		GetFieldValue ($closed_group_res, $row, 'SUM(oWMU)', $SUMoWMU, $IsNull);
        if ($SUMoWMU<>0) $cart->write($currentRow,18, $SUMoWMU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oWMZ)', $SUMoWMZ, $IsNull);
        if ($SUMoWMZ<>0) $cart->write($currentRow,19, $SUMoWMZ, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oWME)', $SUMoWME, $IsNull);
        if ($SUMoWME<>0) $cart->write($currentRow,20, $SUMoWME, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oWMR)', $SUMoWMR, $IsNull);
        if ($SUMoWMR<>0) $cart->write($currentRow,21, $SUMoWMR, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oBFU)', $SUMoBFU, $IsNull);
        if ($SUMoBFU<>0) $cart->write($currentRow,22, $SUMoBFU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oBFE)', $SUMoBFE, $IsNull);
        if ($SUMoBFE<>0) $cart->write($currentRow,23, $SUMoBFE, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oBWU)', $SUMoBWU, $IsNull);
        if ($SUMoBWU<>0) $cart->write($currentRow,24, $SUMoBWU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oBWE)', $SUMoBWE, $IsNull);
        if ($SUMoBWE<>0) $cart->write($currentRow,25, $SUMoBWE, $colSumFormat);

        // Справочно, Доллар - Приход
		$excelRow = $currentRow + 1;
		$formula = "=D$excelRow/AH$excelRow+E$excelRow+F$excelRow*AI$excelRow/AH$excelRow+G$excelRow/AH$excelRow+H$excelRow+".
		           "I$excelRow*AI$excelRow/AH$excelRow+J$excelRow*AJ$excelRow/AH$excelRow+K$excelRow+L$excelRow*AI$excelRow/AH$excelRow+".
		           "M$excelRow+N$excelRow*AI$excelRow/AH$excelRow" ;
		$cart->writeFormula($currentRow,14, $formula, $colFormula);
        // Справочно, Доллар - Расход
		$formula = "=P$excelRow/AH$excelRow+Q$excelRow+R$excelRow*AI$excelRow/AH$excelRow+S$excelRow/AH$excelRow+T$excelRow+".
		           "U$excelRow*AI$excelRow/AH$excelRow+V$excelRow*AJ$excelRow/AH$excelRow+W$excelRow+X$excelRow*AI$excelRow/AH$excelRow+".
		           "Y$excelRow+Z$excelRow*AI$excelRow/AH$excelRow";
		$cart->writeFormula($currentRow,26, $formula, $colFormula);

           // Вспомогательная информация
		GetFieldValue ($closed_group_res, $row, 'login', $login, $IsNull);
		$cart->write($currentRow,27, $login, $colDataFormat);
		GetFieldValue ($closed_group_res, $row, 'name_client', $name_client, $IsNull);
		$cart->write($currentRow,28, $name_client, $colDataFormat);
		GetFieldValue ($closed_group_res, $row, 'whoadded', $whoadded, $IsNull);
		$cart->write($currentRow,29, $whoadded, $colDataFormat);
		GetFieldValue ($closed_group_res, $row, 'added', $added, $IsNull);
		$cart->write($currentRow,30, $added, $colDataFormat);
		GetFieldValue ($closed_group_res, $row, 'whoclosed', $whoclosed, $IsNull);
		$cart->write($currentRow,31, $whoclosed, $colDataFormat);
		GetFieldValue ($closed_group_res, $row, 'closed', $closed, $IsNull);
		$cart->write($currentRow,32, $closed, $colDataFormat);

        // Курсы валют НБУ
        $cart->write($currentRow,33,$USD, $colCourseFormat);
        $cart->write($currentRow,34,$EUR, $colCourseFormat);
        $cart->write($currentRow,35,$RUR, $colCourseFormat);
        $currentRow++;
    }
}

// The first row as Excel knows it - $currentRow was 4 at the start
$startingExcelRow = 7;

// The final row as Excel
// (which is the same as the currentRow once the loop ends)
$finalExcelRow = $currentRow;


// Some more formatting for the grand total cells
$gTFormat =& $xls->addFormat(array("NumFormat"=>"0.00", 'locked' => 1, 'FgColor' => 11));
$gTFormat->setFontFamily('Helvetica');
$gTFormat->setBold();
$gTFormat->setTop(1); // Top border
$gTFormat->setBottom(1); // Bottom border

// Add some text plus formatting
$cart->write($currentRow,0,'Всего:',$gTFormat);

for ($i=4; $i<=27; $i++) {
	// Excel formal to sum all the item totals to get the grand total
	$gTFormula = '=SUM('.__numtoalpha($i).$startingExcelRow.':'.__numtoalpha($i).$finalExcelRow.')';
	$cart->writeFormula($currentRow, $i-1, $gTFormula, $gTFormat);
}
$sumRowOffice = $currentRow+1;

// ================================================================
// Create worksheet ИГОРЬ
// ================================================================
$cart =& $xls->addWorksheet('Igor');

# Add the title
// Some text to use as a title for the worksheet
$titleText = 'Реестр Игорь ' . date('dS M Y');

// Create a format object
$titleFormat =& $xls->addFormat(array('Size' => 13, 'Align' => 'merge', 'Color' => 'navy',
                                      'Bold'  => '1', 'Bottom'=> '2', 'BottomColor' => 'navy'));

// Set the font family - Helvetica works for OpenOffice calc too...
$titleFormat->setFontFamily('Helvetica');
$cart->write(1,0,$titleText,$titleFormat);
$cart->write(1,1,'',$titleFormat);
$cart->write(1,2,'',$titleFormat);
//$cart->write(1,3,'',$titleFormat);

// Высота строки
$cart->setRow(1,30);
// Формат для заголовка
$colHeadingFormat =& $xls->addFormat(array('Size' => 10, 'Align' => 'center', 'Border'  => '1', 'Bottom'=> '1','top'=>'1','left'=>'1','right'=>'1'));
$colHeadingFormat->setFontFamily('Helvetica');
$colHeadingFormat->setVAlign('vcenter');
$colHeadingFormat->setTextWrap();
// Ширина колонок
$cart->setColumn(0,0,7); // A - Номер п/п
$cart->setColumn(1,1,18); // B - Дата операции
$cart->setColumn(2,2,50); // C - Примечание
$cart->setColumn(3,26,10); // D-L валюты
$cart->setColumn(27,38,12); // E - Логин ...

# Вставка заголовка
$colNames1 = array('N п/п','Дата','Примечание');
$colNames2 = array("Логин", "Клиент", "Кто добавил", "Когда добавил", "Кто закрыл", "Когда закрыл", "грн", "EUR", "руб");
$colNames3 = array("грн","Доллар","Евро", "WMU", "WMZ","WME","WMR","Betfair \$", "Betfair EUR", "Wire \$", "Wire EUR", "Справочно, \$");
$cart->writeRow(4,0,$colNames1,$colHeadingFormat);$cart->write(5,0,"",$colHeadingFormat);$cart->write(5,1,"",$colHeadingFormat);$cart->write(5,2,"",$colHeadingFormat);
$cart->write(4,3,"Приход",$colHeadingFormat);for ($i=0; $i<count($colNames3)-1; $i++) $cart->write(4,4+$i,"",$colHeadingFormat);
$cart->write(4,15,"Расход",$colHeadingFormat);for ($i=0; $i<count($colNames3)-1; $i++) $cart->write(4,16+$i,"",$colHeadingFormat);
$cart->writeRow(4,27,$colNames2,$colHeadingFormat);
$cart->writeRow(5,3,$colNames3,$colHeadingFormat);
$cart->writeRow(5,15,$colNames3,$colHeadingFormat);
for ($i=0; $i<count($colNames2); $i++) $cart->write(5,27+$i,"",$colHeadingFormat);
$cart->mergeCells(4,3,4,14);
$cart->mergeCells(4,15,4,26);
$cart->mergeCells(4,0,5,0);$cart->mergeCells(4,1,5,1);$cart->mergeCells(4,2,5,2);
$cart->mergeCells(4,27,5,27);$cart->mergeCells(4,28,5,28);$cart->mergeCells(4,29,5,29);$cart->mergeCells(4,30,5,30);
$cart->mergeCells(4,31,5,31);$cart->mergeCells(4,32,5,32);$cart->mergeCells(4,33,5,33);$cart->mergeCells(4,34,5,34);
$cart->mergeCells(4,35,5,35);$cart->mergeCells(4,36,5,36);

// Заморозить эти ячейки
$freeze = array(6,2,6,2);
$cart->freezePanes($freeze);

//============= SQL ==================================================
   $sqlSumField = "";
   for ($i=0; $i<count($sumFields); $i++)
   	  $sqlSumField.= "SUM(".$sumFields[$i]."), ";
   $sqlSumField = substr($sqlSumField, 0, -2);

   // Выбор всех закрытых групп операций для ПРИХОДА и РАСХОДА по группам Офис(9)
   $sql = "SELECT *, MIN(Descr), $sqlSumField FROM $table
           LEFT OUTER JOIN $group ON ($table.group_id = $group.id)
           INNER JOIN $client ON ($table.id_client = $client.id_client)
           WHERE error Is NULL AND ($table.group_id IS NOT NULL) AND ($table.id_client=15)
           $query_data
           GROUP BY $table.group_id
           ORDER BY DateTS";

   $closed_group_row = OpenSQL ($sql, $closed_group_rows, $closed_group_res);


// Формат для заголовка
$colDataFormat =& $xls->addFormat(array('Border'  => '1'));
$colDataFormat->setTextWrap();
$colDataFormat->setVAlign('vequal_space');
// Формат для сумм
$colSumFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00'));
// Формат для формул
$colFormula =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00', 'locked' => 1, 'FgColor' => 22));
// Табличка для строки
$rowFormat =& $xls->addFormat(array('Border'  => '1'));
//Формат для курсов (5 знаков после запятой)
$colCourseFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00000'));

// Use this to keep track of the current row number
$currentRow = 6;

if (!$closed_group_row) {
	for ($i=0; $i<$closed_group_rows; $i++) {
        $row = NULL;
        for ($cell=3; $cell<=35; $cell++) $cart->write($currentRow,$cell,"",$rowFormat);
        // Проверка на тип операции (Приход)  -- относительно
		GetFieldValue ($closed_group_res, $row, 'SUM(iUAH)', $SUMiUAH, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oUAH)', $SUMoUAH, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oUSD)', $SUMoUSD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(iUSD)', $SUMiUSD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(iEUR)', $SUMiEUR, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'SUM(oEUR)', $SUMoEUR, $IsNull);
        // Курсы валют
		GetFieldValue ($closed_group_res, $row, 'USD', $USD, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'EUR', $EUR, $IsNull);
		GetFieldValue ($closed_group_res, $row, 'RUR', $RUR, $IsNull);

		// N п/п | Дата | Примечание | грн | Доллар | Евро | Справочно, доллар | WMU| WMZ | WME | ... | Логин | Клиент==Офис | кто открыл | когда открыл | кто закрыл | когда закрыл
        // N п/п
		GetFieldValue ($closed_group_res, $row, 'group_id', $group_id, $IsNull);
		$cart->writeUrl($currentRow,0,"$http/s/editgroup.asp?do=edit&group_id=".md5($group_id+$group_id),$group_id, $colDataFormat);
		// Дата закрытия группы
		GetFieldValue ($closed_group_res, $row, 'closed', $closed, $IsNull);
        $cart->write($currentRow,1,$closed, $colDataFormat);
        // Описание (В примечании к ячейке описание всех строк, т.е. полное описание группы)
		GetFieldValue ($closed_group_res, $row, 'MIN(Descr)', $Descr, $IsNull);
        $Descr = str_replace("!","",$Descr);
        $cart->writeString($currentRow,2,$Descr, $colDataFormat);
        // Формирование полного описания группы по строкам
        $sql_descr = "SELECT descr FROM $table WHERE group_id = $group_id";
        $descr_row = OpenSQL ($sql_descr, $descr_rows, $descr_res);
        if (!$descr_row) {
        	$all_descr = "";
        	for ($j=0; $j<$descr_rows; $j++) {
        		$row_descr = NULL;
        		GetFieldValue ($descr_res, $row_descr, 'descr', $Descr_transaction, $IsNull);
        		if (!ereg("Комиссия Webmoney", $Descr_transaction)) {
        			$Descr_transaction = str_replace("Спасибо за выбор нашего сервиса","",$Descr_transaction);
        			$Descr_transaction = str_replace("!","",$Descr_transaction);
        			$all_descr.= $Descr_transaction."\r\n";
        		}
            }
            $cart->writeNote($currentRow,2,$all_descr);
        }
        // Полученый нал
        if ($SUMiUAH<>0) $cart->write($currentRow,3,$SUMiUAH, $colSumFormat);
        if ($SUMiUSD<>0) $cart->write($currentRow,4,$SUMiUSD, $colSumFormat);
        if ($SUMiEUR<>0) $cart->write($currentRow,5,$SUMiEUR, $colSumFormat);
        // Входящая валюта
		GetFieldValue ($closed_group_res, $row, 'SUM(iWMU)', $SUMiWMU, $IsNull);
        if ($SUMiWMU<>0) $cart->write($currentRow,6, $SUMiWMU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iWMZ)', $SUMiWMZ, $IsNull);
        if ($SUMiWMZ<>0) $cart->write($currentRow,7, $SUMiWMZ, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iWME)', $SUMiWME, $IsNull);
        if ($SUMiWME<>0) $cart->write($currentRow,8, $SUMiWME, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iWMR)', $SUMiWMR, $IsNull);
        if ($SUMiWMR<>0) $cart->write($currentRow,9, $SUMiWMR, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iBFU)', $SUMiBFU, $IsNull);
        if ($SUMiBFU<>0) $cart->write($currentRow,10, $SUMiBFU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iBFE)', $SUMiBFE, $IsNull);
        if ($SUMiBFE<>0) $cart->write($currentRow,11, $SUMiBFE, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iBWU)', $SUMiBWU, $IsNull);
        if ($SUMiBWU<>0) $cart->write($currentRow,12, $SUMiBWU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(iBWE)', $SUMiBWE, $IsNull);
        if ($SUMiBWE<>0) $cart->write($currentRow,13, $SUMiBWE, $colSumFormat);

        // Выданый нал
        if ($SUMoUAH<>0) $cart->write($currentRow,15,$SUMoUAH, $colSumFormat);
        if ($SUMoUSD<>0) $cart->write($currentRow,16,$SUMoUSD, $colSumFormat);
        if ($SUMoEUR<>0) $cart->write($currentRow,17,$SUMoEUR, $colSumFormat);
        // Исходящая валюта
		GetFieldValue ($closed_group_res, $row, 'SUM(oWMU)', $SUMoWMU, $IsNull);
        if ($SUMoWMU<>0) $cart->write($currentRow,18, $SUMoWMU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oWMZ)', $SUMoWMZ, $IsNull);
        if ($SUMoWMZ<>0) $cart->write($currentRow,19, $SUMoWMZ, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oWME)', $SUMoWME, $IsNull);
        if ($SUMoWME<>0) $cart->write($currentRow,20, $SUMoWME, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oWMR)', $SUMoWMR, $IsNull);
        if ($SUMoWMR<>0) $cart->write($currentRow,21, $SUMoWMR, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oBFU)', $SUMoBFU, $IsNull);
        if ($SUMoBFU<>0) $cart->write($currentRow,22, $SUMoBFU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oBFE)', $SUMoBFE, $IsNull);
        if ($SUMoBFE<>0) $cart->write($currentRow,23, $SUMoBFE, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oBWU)', $SUMoBWU, $IsNull);
        if ($SUMoBWU<>0) $cart->write($currentRow,24, $SUMoBWU, $colSumFormat);
		GetFieldValue ($closed_group_res, $row, 'SUM(oBWE)', $SUMoBWE, $IsNull);
        if ($SUMoBWE<>0) $cart->write($currentRow,25, $SUMoBWE, $colSumFormat);

        // Справочно, Доллар - Приход
		$excelRow = $currentRow + 1;
		$formula = "=D$excelRow/AH$excelRow+E$excelRow+F$excelRow*AI$excelRow/AH$excelRow+G$excelRow/AH$excelRow+H$excelRow+".
		           "I$excelRow*AI$excelRow/AH$excelRow+J$excelRow*AJ$excelRow/AH$excelRow+K$excelRow+L$excelRow*AI$excelRow/AH$excelRow+".
		           "M$excelRow+N$excelRow*AI$excelRow/AH$excelRow" ;
		$cart->writeFormula($currentRow,14, $formula, $colFormula);
        // Справочно, Доллар - Расход
		$formula = "=P$excelRow/AH$excelRow+Q$excelRow+R$excelRow*AI$excelRow/AH$excelRow+S$excelRow/AH$excelRow+T$excelRow+".
		           "U$excelRow*AI$excelRow/AH$excelRow+V$excelRow*AJ$excelRow/AH$excelRow+W$excelRow+X$excelRow*AI$excelRow/AH$excelRow+".
		           "Y$excelRow+Z$excelRow*AI$excelRow/AH$excelRow";
		$cart->writeFormula($currentRow,26, $formula, $colFormula);

           // Вспомогательная информация
		GetFieldValue ($closed_group_res, $row, 'login', $login, $IsNull);
		$cart->write($currentRow,27, $login, $colDataFormat);
		GetFieldValue ($closed_group_res, $row, 'name_client', $name_client, $IsNull);
		$cart->write($currentRow,28, $name_client, $colDataFormat);
		GetFieldValue ($closed_group_res, $row, 'whoadded', $whoadded, $IsNull);
		$cart->write($currentRow,29, $whoadded, $colDataFormat);
		GetFieldValue ($closed_group_res, $row, 'added', $added, $IsNull);
		$cart->write($currentRow,30, $added, $colDataFormat);
		GetFieldValue ($closed_group_res, $row, 'whoclosed', $whoclosed, $IsNull);
		$cart->write($currentRow,31, $whoclosed, $colDataFormat);
		GetFieldValue ($closed_group_res, $row, 'closed', $closed, $IsNull);
		$cart->write($currentRow,32, $closed, $colDataFormat);

        // Курсы валют НБУ
        $cart->write($currentRow,33,$USD, $colCourseFormat);
        $cart->write($currentRow,34,$EUR, $colCourseFormat);
        $cart->write($currentRow,35,$RUR, $colCourseFormat);
        $currentRow++;
    }
}

// The first row as Excel knows it - $currentRow was 4 at the start
$startingExcelRow = 7;

// The final row as Excel
// (which is the same as the currentRow once the loop ends)
$finalExcelRow = $currentRow;

// Some more formatting for the grand total cells
$gTFormat =& $xls->addFormat(array("NumFormat"=>"0.00", 'locked' => 1, 'FgColor' => 11));
$gTFormat->setFontFamily('Helvetica');
$gTFormat->setBold();
$gTFormat->setTop(1); // Top border
$gTFormat->setBottom(1); // Bottom border

// Add some text plus formatting
$cart->write($currentRow,0,'Всего:',$gTFormat);

for ($i=4; $i<=27; $i++) {
	// Excel formal to sum all the item totals to get the grand total
	$gTFormula = '=SUM('.__numtoalpha($i).$startingExcelRow.':'.__numtoalpha($i).$finalExcelRow.')';
	$cart->writeFormula($currentRow, $i-1, $gTFormula, $gTFormat);
}
$sumRowIgor = $currentRow+1;

// ================================================================
// Create worksheet СВОДНЫЙ ОСТАТОК
// ================================================================
$cart =& $xls->addWorksheet('свод_остаток');

# Add the title
// Some text to use as a title for the worksheet
$titleText = 'Сводная таблица - остатки денежных средств ';

// Create a format object
$titleFormat =& $xls->addFormat(array('Size' => 13, 'Align' => 'left', 'Color' => 'navy',
                                      'Bold'  => '1', 'Bottom'=> '2', 'BottomColor' => 'navy'));

// Set the font family - Helvetica works for OpenOffice calc too...
$titleFormat->setFontFamily('Helvetica');
$cart->write(1,1,$titleText,$titleFormat);
$cart->write(1,2,$titleText,$titleFormat);
$cart->write(1,3,$titleText,$titleFormat);
$cart->write(1,4,$titleText,$titleFormat);
$cart->write(1,5,$titleText,$titleFormat);
$cart->mergeCells(1,1,1,5);

// Высота строки
$cart->setRow(1,30);
// Формат для заголовка
$colHeadingFormat =& $xls->addFormat(array('Size' => 11, 'Align' => 'center', 'Border'  => '1', 'Bottom'=> '1','top'=>'1','left'=>'1','right'=>'1'));
$colHeadingFormat->setBold();
$colHeadingFormat->setFontFamily('Calibri');
$colHeadingFormat->setVAlign('vcenter');

// Ширина колонок
$cart->setColumn(0,0,2); // Отступ
$cart->setColumn(1,1,18); // B - Статья
$cart->setColumn(2,35,14); // D-AI валюты


# Вставка заголовка
$colNames = array("грн","Доллар","Евро", "WMU", "WMZ","WME","WMR","Betfair \$", "Betfair EUR", "Wire \$", "Wire EUR");
$cart->write(4,1,"Статья",$colHeadingFormat);$cart->write(5,1,"",$colHeadingFormat);
$cart->write(4,2,"Приход",$colHeadingFormat);for ($i=0; $i<count($colNames); $i++) $cart->write(4,3+$i,"",$colHeadingFormat);
$cart->write(4,13,"Расход",$colHeadingFormat);for ($i=0; $i<count($colNames); $i++) $cart->write(4,14+$i,"",$colHeadingFormat);
$cart->write(4,24,"Остаток",$colHeadingFormat);for ($i=0; $i<count($colNames)-1; $i++) $cart->write(4,25+$i,"",$colHeadingFormat);

$cart->writeRow(5,2,$colNames,$colHeadingFormat);
$cart->writeRow(5,13,$colNames,$colHeadingFormat);
$cart->writeRow(5,24,$colNames,$colHeadingFormat);

$cart->mergeCells(4,1,5,1);
$cart->mergeCells(4,2,4,12);
$cart->mergeCells(4,13,4,23);
$cart->mergeCells(4,24,4,34);

// Формат для текстовых данных
$colDataFormat =& $xls->addFormat(array('Border'  => '1'));
$colDataFormat->setTextWrap();
$colDataFormat->setVAlign('vequal_space');
// Формат для сумм
$colSumFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00', 'Size'=>11, 'Bold'=>'1', 'locked' => 1));
$colSumFormat->setFontFamily('Calibri');
// Формат для формул
$colFormula =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00', 'locked' => 1));
// Табличка для строки
$rowFormat =& $xls->addFormat(array('Border'  => '1'));
//Формат для курсов (5 знаков после запятой)
$colCourseFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00000'));

// ИТОГО ПРИХОД
$cart->write(6,1,'Приход',$colHeadingFormat);
$cart->writeFormula(6,2,"=(prihod!D$sumRowPrihod)",$colFormula);
$cart->writeFormula(6,3,"=(prihod!E$sumRowPrihod)",$colFormula);
$cart->writeFormula(6,4,"=(prihod!F$sumRowPrihod)",$colFormula);
$cart->writeFormula(6,5,"=(prihod!H$sumRowPrihod)",$colFormula);
$cart->writeFormula(6,6,"=(prihod!I$sumRowPrihod)",$colFormula);
$cart->writeFormula(6,7,"=(prihod!J$sumRowPrihod)",$colFormula);
$cart->writeFormula(6,8,"=(prihod!K$sumRowPrihod)",$colFormula);
$cart->writeFormula(6,9,"=(prihod!L$sumRowPrihod)",$colFormula);
$cart->writeFormula(6,10,"=(prihod!M$sumRowPrihod)",$colFormula);
$cart->writeFormula(6,11,"=(prihod!N$sumRowPrihod)",$colFormula);
$cart->writeFormula(6,12,"=(prihod!O$sumRowPrihod)",$colFormula);
for ($i=0; $i<11; $i++) $cart->write(6,13+$i,"",$colHeadingFormat);

// ИТОГО РАСХОД
for ($i=0; $i<11; $i++) $cart->write(7,2+$i,"",$colHeadingFormat);
$cart->write(7,1,'Расход',$colHeadingFormat);
$cart->writeFormula(7,13,"=(rashod!M$sumRowRashod)",$colFormula);
$cart->writeFormula(7,14,"=(rashod!N$sumRowRashod)",$colFormula);
$cart->writeFormula(7,15,"=(rashod!O$sumRowRashod)",$colFormula);
$cart->writeFormula(7,16,"=(rashod!D$sumRowRashod)",$colFormula);
$cart->writeFormula(7,17,"=(rashod!E$sumRowRashod)",$colFormula);
$cart->writeFormula(7,18,"=(rashod!F$sumRowRashod)",$colFormula);
$cart->writeFormula(7,19,"=(rashod!G$sumRowRashod)",$colFormula);
$cart->writeFormula(7,20,"=(rashod!H$sumRowRashod)",$colFormula);
$cart->writeFormula(7,21,"=(rashod!I$sumRowRashod)",$colFormula);
$cart->writeFormula(7,22,"=(rashod!J$sumRowRashod)",$colFormula);
$cart->writeFormula(7,23,"=(rashod!K$sumRowRashod)",$colFormula);

//ИТОГО ОФИС
$cart->write(8,1,'Офис',$colHeadingFormat);
for ($i=4; $i<=14; $i++)
   $cart->writeFormula(8,$i-2,"=(office!".__numtoalpha($i)."$sumRowOffice)",$colFormula);
for ($i=15; $i<=25; $i++)
   $cart->writeFormula(8,$i-2,"=(office!".__numtoalpha($i+1)."$sumRowOffice)",$colFormula);

//ИТОГО ИГОРЬ
$cart->write(9,1,'Игорь',$colHeadingFormat);
for ($i=4; $i<=14; $i++)
   $cart->writeFormula(9,$i-2,"=(Igor!".__numtoalpha($i)."$sumRowIgor)",$colFormula);
for ($i=15; $i<=25; $i++)
   $cart->writeFormula(9,$i-2,"=(Igor!".__numtoalpha($i+1)."$sumRowIgor)",$colFormula);

// ИТОГО НЕЗАКРЫТЫЕ ГРУППЫ
// ..

// ИТОГО
$cart->write(10,1,'ИТОГО:',$colHeadingFormat);
for ($i=3; $i<=24; $i++)
   $cart->writeFormula(10,$i-1,"=SUM(".__numtoalpha($i)."7:".__numtoalpha($i)."10)",$colSumFormat);

// ОСТАТКИ
// Формат для сумм
$colOstFormat =& $xls->addFormat(array('Border'  => '1', 'Align'=>'center', 'FgColor'=>31, 'NumFormat' => '0.00', 'Size'=>12,
               'Bold'=>'1', 'locked' => 1));
$colOstFormat->setVAlign('vcenter');
$colOstFormat->setFontFamily('Calibri');
for ($i=3; $i<=13; $i++) {
   $cart->writeFormula(6,$i+21,"=SUM(".__numtoalpha($i)."11-".__numtoalpha($i+11)."11)",$colOstFormat);
   $cart->write(7,$i+21,"",$colOstFormat);$cart->write(8,$i+21,"",$colOstFormat);
   $cart->write(9,$i+21,"",$colOstFormat);$cart->write(10,$i+21,"",$colOstFormat);
   $cart->mergeCells(6,$i+21,9,$i+21);
}

// ================================================================
// Create worksheet ФИН РЕЗУЛЬТАТ
// ================================================================
$cart =& $xls->addWorksheet('фин_рез');

# Add the title
// Some text to use as a title for the worksheet
$titleText = 'Сводная таблица - финансовый результат ';

// Create a format object
$titleFormat =& $xls->addFormat(array('Size' => 13, 'Align' => 'left', 'Color' => 'navy',
                                      'Bold'  => '1', 'Bottom'=> '2', 'BottomColor' => 'navy'));

// Set the font family - Helvetica works for OpenOffice calc too...
$titleFormat->setFontFamily('Helvetica');
$cart->write(1,1,$titleText,$titleFormat);
$cart->write(1,2,$titleText,$titleFormat);
$cart->write(1,3,$titleText,$titleFormat);
$cart->write(1,4,$titleText,$titleFormat);
$cart->write(1,5,$titleText,$titleFormat);
$cart->mergeCells(1,1,1,5);

// Высота строки
$cart->setRow(1,30);
// Формат для заголовка
$colHeadingFormat =& $xls->addFormat(array('Size' => 12, 'Align' => 'center', 'Border'  => '1', 'Bottom'=> '1','top'=>'1','left'=>'1','right'=>'1'));
$colHeadingFormat->setBold();
$colHeadingFormat->setFontFamily('Helvetica');
$colHeadingFormat->setVAlign('vcenter');

// Ширина колонок
$cart->setColumn(0,0,2); // Отступ
$cart->setColumn(1,1,25); // B - Статья
$cart->setColumn(2,5,15); // D-L валюты

# Вставка заголовка
$colNames = array("Доллар","E-деньги");
$cart->write(4,1,"Статья",$colHeadingFormat);$cart->write(5,1,"",$colHeadingFormat);
$cart->write(4,2,"Приход",$colHeadingFormat);$cart->write(4,3,"",$colHeadingFormat);
$cart->write(4,4,"Расход",$colHeadingFormat);$cart->write(4,5,"",$colHeadingFormat);

$cart->writeRow(5,2,$colNames,$colHeadingFormat);
$cart->writeRow(5,4,$colNames,$colHeadingFormat);

$cart->mergeCells(4,1,5,1);
$cart->mergeCells(4,2,4,3);
$cart->mergeCells(4,4,4,5);

// Формат для формул
$colFormula =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00', 'locked' => 1));
$colBoldFormula =& $xls->addFormat(array('Border'  => '1', 'Bold'=>'1', 'Align'=>'center', 'Size'=>11, 'NumFormat' => '0.00', 'locked' => 1, 'FgColor'=>11));

// ПРИХОД  (КЛИЕНТЫ)
$cart->write(6,1,'клиенты (приход)',$colHeadingFormat);
$cart->writeFormula(6,2,"=(prihod!G$sumRowPrihod)",$colFormula);
$cart->write(6,3,"",$colFormula);$cart->write(6,4,"",$colFormula);
$cart->writeFormula(6,5,"=(prihod!P$sumRowPrihod)",$colFormula);

// РАСХОД  (КЛИЕНТЫ)
$cart->write(7,1,'клиенты (расход)',$colHeadingFormat);
$cart->write(7,2,"",$colFormula);
$cart->writeFormula(7,3,"=(rashod!L$sumRowRashod)",$colFormula);
$cart->writeFormula(7,4,"=(rashod!P$sumRowRashod)",$colFormula);
$cart->write(7,5,"",$colFormula);

// ОФИСНЫЕ РАСХОДЫ
$cart->write(8,1,'офисные расходы',$colHeadingFormat);
$cart->writeFormula(8,2,"=(office!O$sumRowOffice)",$colFormula);
$cart->write(8,3,"",$colFormula);
$cart->writeFormula(8,4,"=(office!AA$sumRowOffice)",$colFormula);
$cart->write(8,5,"",$colFormula);

// РАСХОДЫ НА ИГОРЯ
$cart->write(9,1,'расходы на Игоря',$colHeadingFormat);
$cart->writeFormula(9,2,"=(Igor!O$sumRowIgor)",$colFormula);
$cart->write(9,3,"",$colFormula);
$cart->writeFormula(9,4,"=(Igor!AA$sumRowIgor)",$colFormula);
$cart->write(9,5,"",$colFormula);

// ИТОГО
$cart->write(10,1,'ИТОГО',$colHeadingFormat);
$cart->writeFormula(10,2,"=SUM(C7:C10)",$colBoldFormula);
$cart->writeFormula(10,3,"=SUM(D7:D10)",$colBoldFormula);
$cart->writeFormula(10,4,"=SUM(E7:E10)",$colBoldFormula);
$cart->writeFormula(10,5,"=SUM(F7:F10)",$colBoldFormula);

// ИТОГО
$cart->write(11,1,'ИТОГО',$colHeadingFormat);
$cart->writeFormula(11,2,"=C11+D11",$colBoldFormula);
$cart->write(11,3,"",$colBoldFormula);$cart->mergeCells(11,2,11,3);
$cart->writeFormula(11,4,"=E11+F11)",$colBoldFormula);
$cart->write(11,5,"",$colBoldFormula);$cart->mergeCells(11,4,11,5);
// ФИНРЕЗ
$cart->writeFormula(12,3,"=C12-E12",$colBoldFormula);
$cart->write(12,4,"",$colBoldFormula);
$cart->mergeCells(12,3,12,4);


// ================================================================
// Create worksheet ОТКРЫТЫЕ ГРУППЫ
// ================================================================
$cart =& $xls->addWorksheet('opened');

# Add the title
// Some text to use as a title for the worksheet
$titleText = 'Реестр незавершенных операций ' . date('dS M Y') . '(+ приход; - расход)';

// Create a format object
$titleFormat =& $xls->addFormat(array('Size' => 13, 'Align' => 'merge', 'Color' => 'navy',
                                      'Bold'  => '1', 'Bottom'=> '2', 'BottomColor' => 'navy'));

// Set the font family - Helvetica works for OpenOffice calc too...
$titleFormat->setFontFamily('Helvetica');
$cart->write(1,0,$titleText,$titleFormat);
$cart->write(1,1,'',$titleFormat);
$cart->write(1,2,'',$titleFormat);
//$cart->write(1,3,'',$titleFormat);

// Высота строки
$cart->setRow(1,30);
// Формат для заголовка
$colHeadingFormat =& $xls->addFormat(array('Size' => 10, 'Align' => 'center', 'Border'  => '1', 'Bottom'=> '2'));
$colHeadingFormat->setFontFamily('Helvetica');
$colHeadingFormat->setVAlign('vcenter');
$colHeadingFormat->setTextWrap();
// Ширина колонок
$cart->setColumn(0,0,7); // A - Номер п/п
$cart->setColumn(1,1,18); // B - Дата операции
$cart->setColumn(2,2,50); // C - Примечание
$cart->setColumn(3,14,10); // D-L валюты
$cart->setColumn(15,24,12); // E - Логин ...

# Вставка заголовка
// An array with the data for the column headings
$colNames = array('N п/п','Дата посл. редактирования','Примечание',"грн","Доллар","Евро","Справочно $","WMU", "WMZ","WME","WMR",
                  "Betfair \$", "Betfair EUR", "Wire \$", "Wire EUR", "Справочно $",
                  "Логин", "Клиент", "Кто добавил", "Когда добавил", "Кто редактировал", "Когда редактировал", "Результат", "грн", "EUR", "руб");

// Add all the column headings with a single call
// leaving a blank row to look nicer
$cart->writeRow(3,0,$colNames,$colHeadingFormat);

// Группа ячеек для замораживания
// 1-ый Аргумент - позиция вертикального обьединения
// 2-ой Аргумент - позиция горизонтального обьединения (0 = нет горизонтального обьединения)
// 3-ий Аргумент - верхняя видимая строка внизу вертикального объединения
// 4-ий Аргумент - левый видимый столбец после горизнотального объединения
// Сделать всегда видимыми 4 сверзу, 1 слева
$freeze = array(4,1,4,1);

// Заморозить эти ячейки!
$cart->freezePanes($freeze);

//============= SQL ==================================================
   $sqlSumField = "";
   for ($i=0; $i<count($sumFields); $i++)
   	  $sqlSumField.= "SUM(".$sumFields[$i]."), ";
   $sqlSumField = substr($sqlSumField, 0, -2);

   // Выбор всех открытых групп операций, кроме групп Офис(9) и групп Игорь(15)
   $sql = "SELECT *, MIN(Descr), $sqlSumField FROM $table
           LEFT OUTER JOIN $group ON ($table.group_id = $group.id)
           INNER JOIN $client ON ($table.id_client = $client.id_client)
           WHERE error Is NULL AND ($group.closed IS NULL) AND ($table.id_client<>9) AND ($table.id_client<>15)
           $query_data
           GROUP BY $table.group_id
           ORDER BY added, DateTS";
   $opened_group_row = OpenSQL ($sql, $opened_group_rows, $opened_group_res);

// Формат для заголовка
$colDataFormat =& $xls->addFormat(array('Border'  => '1'));
$colDataFormat->setTextWrap();
$colDataFormat->setVAlign('vequal_space');
// Формат для сумм
$colSumFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00'));
// Формат для формул
$colFormula =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00', 'locked' => 1, 'FgColor' => 22));
// Табличка для строки
$rowFormat =& $xls->addFormat(array('Border'  => '1'));
$rowFormat->setVAlign('vequal_space');
//Формат для курсов (5 знаков после запятой)
$colCourseFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00000'));

// Use this to keep track of the current row number
$currentRow = 4;

if (!$opened_group_row) {
	for ($i=0; $i<$opened_group_rows; $i++) {
        $row = NULL;
        $cart->setRow($currentRow,30, $rowFormat);
        // Наличные валюты
		GetFieldValue ($opened_group_res, $row, 'SUM(iUAH)', $SUMiUAH, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oUAH)', $SUMoUAH, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oUSD)', $SUMoUSD, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(iUSD)', $SUMiUSD, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(iEUR)', $SUMiEUR, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oEUR)', $SUMoEUR, $IsNull);
        // Курсы валют
		GetFieldValue ($opened_group_res, $row, 'USD', $USD, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'EUR', $EUR, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'RUR', $RUR, $IsNull);
		$SUM_CASH = ($SUMiUAH-$SUMoUAH)/$USD+$SUMiUSD-$SUMoUSD+($SUMiEUR-$SUMoEUR)*$EUR/$USD;

		// N п/п | Дата | Примечание | грн | Доллар | Евро | Справочно, доллар | WMU| WMZ | WME | ... | Логин | Клиент | кто открыл | когда открыл | кто закрыл | когда закрыл
        // N п/п
		GetFieldValue ($opened_group_res, $row, 'group_id', $group_id, $IsNull);
		if ($group_id<>"")	{
			$cart->writeUrl($currentRow,0,"$http/s/editgroup.asp?do=edit&group_id=".md5($group_id+$group_id),$group_id, $colDataFormat);
			// Дата редактирования группы
			GetFieldValue ($opened_group_res, $row, 'last_edited', $edited, $IsNull);
	        $cart->write($currentRow,1,$edited, $colDataFormat);
		} else {
			$cart->write($currentRow,0,"-", $colDataFormat);
        	$cart->write($currentRow,1,"", $colDataFormat);
        }
        // Описание (В примечании к ячейке описание всех строк, т.е. полное описание группы)
		GetFieldValue ($opened_group_res, $row, 'MIN(Descr)', $Descr, $IsNull);
        $Descr = str_replace("!","",$Descr);
        $Descr = str_replace("Спасибо за выбор нашего сервиса","",$Descr);
        $Descr = str_replace("Комиссия Webmoney. ","",$Descr);
        $cart->writeString($currentRow,2,$Descr, $colDataFormat);
        if ($group_id<>"") {
	        // Формирование полного описания группы по строкам
	        $sql_descr = "SELECT descr FROM $table WHERE group_id = $group_id";
	        $descr_row = OpenSQL ($sql_descr, $descr_rows, $descr_res);
	        if (!$descr_row) {
	        	$all_descr = "";
	        	for ($j=0; $j<$descr_rows; $j++) {
	        		$row_descr = NULL;
	        		GetFieldValue ($descr_res, $row_descr, 'descr', $Descr_transaction, $IsNull);
	        		if (!ereg("Комиссия Webmoney", $Descr_transaction)) {
	        			$Descr_transaction = str_replace("Спасибо за выбор нашего сервиса","",$Descr_transaction);
	        			$Descr_transaction = str_replace("!","",$Descr_transaction);
	        			$all_descr.= $Descr_transaction."\r\n";
	        		}
	            }
	            $cart->writeNote($currentRow,2,$all_descr);
	        }
        }
        // нал
        if ($SUMiUAH-$SUMoUAH<>0) $cart->write($currentRow,3,$SUMiUAH-$SUMoUAH, $colSumFormat);
        if ($SUMiUSD-$SUMoUSD<>0) $cart->write($currentRow,4,$SUMiUSD-$SUMoUSD, $colSumFormat);
        if ($SUMiEUR-$SUMoEUR<>0) $cart->write($currentRow,5,$SUMiEUR-$SUMoEUR, $colSumFormat);
        // Справочно, Доллар
		$excelRow = $currentRow + 1;
		$formula = "=(D$excelRow/X$excelRow) + E$excelRow + (F$excelRow*Y$excelRow/X$excelRow)" ;
		$cart->writeFormula($currentRow,6, $formula, $colFormula);
        // Исходящая валюта
		GetFieldValue ($opened_group_res, $row, 'SUM(iWMU)', $SUMiWMU, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oWMU)', $SUMoWMU, $IsNull);
        if ($SUMiWMU-$SUMoWMU<>0) $cart->write($currentRow,7, $SUMiWMU-$SUMoWMU, $colSumFormat);
		GetFieldValue ($opened_group_res, $row, 'SUM(iWMZ)', $SUMiWMZ, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oWMZ)', $SUMoWMZ, $IsNull);
        if ($SUMiWMZ-$SUMoWMZ<>0) $cart->write($currentRow,8, $SUMiWMZ-$SUMoWMZ, $colSumFormat);
		GetFieldValue ($opened_group_res, $row, 'SUM(iWME)', $SUMiWME, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oWME)', $SUMoWME, $IsNull);
        if ($SUMiWME-$SUMoWME<>0) $cart->write($currentRow,9, $SUMiWME-$SUMoWME, $colSumFormat);
		GetFieldValue ($opened_group_res, $row, 'SUM(iWMR)', $SUMiWMR, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oWMR)', $SUMoWMR, $IsNull);
        if ($SUMiWMR-$SUMoWMR<>0) $cart->write($currentRow,10, $SUMiWMR-$SUMoWMR, $colSumFormat);
		GetFieldValue ($opened_group_res, $row, 'SUM(iBFU)', $SUMiBFU, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oBFU)', $SUMoBFU, $IsNull);
        if ($SUMiBFU-$SUMoBFU<>0) $cart->write($currentRow,11, $SUMiBFU-$SUMoBFU, $colSumFormat);
		GetFieldValue ($opened_group_res, $row, 'SUM(iBFE)', $SUMiBFE, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oBFE)', $SUMoBFE, $IsNull);
        if ($SUMiBFE-$SUMoBFE<>0) $cart->write($currentRow,12, $SUMiBFE-$SUMoBFE, $colSumFormat);
		GetFieldValue ($opened_group_res, $row, 'SUM(iBWU)', $SUMiBWU, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oBWU)', $SUMoBWU, $IsNull);
        if ($SUMiBWU-$SUMoBWU<>0) $cart->write($currentRow,13, $SUMiBWU-$SUMoBWU, $colSumFormat);
		GetFieldValue ($opened_group_res, $row, 'SUM(iBWE)', $SUMiBWE, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oBWE)', $SUMoBWE, $IsNull);
        if ($SUMiBWE-$SUMoBWE<>0) $cart->write($currentRow,14, $SUMiBWE-$SUMoBWE, $colSumFormat);
        // Справочно, Доллар
		$formula = "=(H$excelRow/X$excelRow) + I$excelRow + (J$excelRow*Y$excelRow/X$excelRow) + (K$excelRow*Z$excelRow/X$excelRow)".
		           "+ L$excelRow + (M$excelRow*Y$excelRow/X$excelRow) + N$excelRow + (O$excelRow*Y$excelRow/X$excelRow)" ;
		$cart->writeFormula($currentRow,15, $formula, $colFormula);

        // Вспомогательная информация
		GetFieldValue ($opened_group_res, $row, 'login', $login, $IsNull);
		$cart->write($currentRow,16, $login, $colDataFormat);
		GetFieldValue ($opened_group_res, $row, 'name_client', $name_client, $IsNull);
		$cart->write($currentRow,17, $name_client, $colDataFormat);
		GetFieldValue ($opened_group_res, $row, 'whoadded', $whoadded, $IsNull);
		$cart->write($currentRow,18, $whoadded, $colDataFormat);
		GetFieldValue ($opened_group_res, $row, 'added', $added, $IsNull);
		$cart->write($currentRow,19, $added, $colDataFormat);
		GetFieldValue ($opened_group_res, $row, 'whoedited', $whoedited, $IsNull);
		$cart->write($currentRow,20, $whoedited, $colDataFormat);
		GetFieldValue ($opened_group_res, $row, 'last_edited', $edited, $IsNull);
		$cart->write($currentRow,21, $edited, $colDataFormat);

		$formula = "=G$excelRow+P$excelRow" ;
		$cart->writeFormula($currentRow,22, $formula, $colFormula);

        // Курсы валют НБУ
        $cart->write($currentRow,23,$USD, $colCourseFormat);
        $cart->write($currentRow,24,$EUR, $colCourseFormat);
        $cart->write($currentRow,25,$RUR, $colCourseFormat);
        $currentRow++;

    }
}

// The first row as Excel knows it - $currentRow was 4 at the start
$startingExcelRow = 5;

// The final row as Excel
// (which is the same as the currentRow once the loop ends)
$finalExcelRow = $currentRow;

// Excel formal to sum all the item totals to get the grand total
$dTFormula = '=SUM(D'.$startingExcelRow.':D'.$finalExcelRow.')';
$eTFormula = '=SUM(E'.$startingExcelRow.':E'.$finalExcelRow.')';
$fTFormula = '=SUM(F'.$startingExcelRow.':F'.$finalExcelRow.')';
$gTFormula = '=SUM(G'.$startingExcelRow.':G'.$finalExcelRow.')';
$hTFormula = '=SUM(H'.$startingExcelRow.':H'.$finalExcelRow.')';
$iTFormula = '=SUM(I'.$startingExcelRow.':I'.$finalExcelRow.')';
$jTFormula = '=SUM(J'.$startingExcelRow.':J'.$finalExcelRow.')';
$kTFormula = '=SUM(K'.$startingExcelRow.':K'.$finalExcelRow.')';
$lTFormula = '=SUM(L'.$startingExcelRow.':L'.$finalExcelRow.')';
$mTFormula = '=SUM(M'.$startingExcelRow.':M'.$finalExcelRow.')';
$nTFormula = '=SUM(N'.$startingExcelRow.':N'.$finalExcelRow.')';
$oTFormula = '=SUM(O'.$startingExcelRow.':O'.$finalExcelRow.')';
$pTFormula = '=SUM(P'.$startingExcelRow.':P'.$finalExcelRow.')';
$wTFormula = '=SUM(W'.$startingExcelRow.':W'.$finalExcelRow.')';

// Some more formatting for the grand total cells
$gTFormat =& $xls->addFormat(array("NumFormat"=>"0.00", 'locked' => 1, 'bottom'=> '1','top'=>'1','left'=>'1','right'=>'1', 'FgColor' => 11));
$gTFormat->setFontFamily('Helvetica');
$gTFormat->setBold();

// Add some text plus formatting
$cart->write($currentRow,0,'Всего:',$gTFormat);

// Add the grand total formula along with the format
$cart->writeFormula($currentRow,3,$dTFormula,$gTFormat);
$cart->writeFormula($currentRow,4,$eTFormula,$gTFormat);
$cart->writeFormula($currentRow,5,$fTFormula,$gTFormat);
$cart->writeFormula($currentRow,6,$gTFormula,$gTFormat);
$cart->writeFormula($currentRow,7,$hTFormula,$gTFormat);
$cart->writeFormula($currentRow,8,$iTFormula,$gTFormat);
$cart->writeFormula($currentRow,9,$jTFormula,$gTFormat);
$cart->writeFormula($currentRow,10,$kTFormula,$gTFormat);
$cart->writeFormula($currentRow,11,$lTFormula,$gTFormat);
$cart->writeFormula($currentRow,12,$mTFormula,$gTFormat);
$cart->writeFormula($currentRow,13,$nTFormula,$gTFormat);
$cart->writeFormula($currentRow,14,$oTFormula,$gTFormat);
$cart->writeFormula($currentRow,15,$pTFormula,$gTFormat);
$cart->writeFormula($currentRow,22,$wTFormula,$gTFormat);
$sumRowPrihod = $currentRow+1;


// Send the Spreadsheet to the browser
//$xls->send("reestr.xls");
$xls->close();

// Архивация данных
$zip = new ZipArchive();

if ($zip->open("./reestrs/$filename.zip", ZIPARCHIVE::CREATE)!==TRUE) {
    exit("cannot open <$filename>\n");
}
$thisdir = "./";
$zip->addFile($thisdir.$filename, $filename);
if (($zip->numFiles==1) && ($zip->status==0)) {
	echo "<a href=\"/excel_code/reestrs/$filename.zip\">Скачать</a>";
} else "Файл не создан!";
$zip->close();
unlink($filename);


    function __numtoalpha($v)  {
        $return = '';
        while( $v >= 1 ) {
            $v = $v - 1;
            $return = chr(($v % 26)+65).$return;
            $v = $v / 26;
        }
        return $return;
    }

?>