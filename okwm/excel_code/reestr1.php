<?php
// ������� ������������� �������� � MS Excel (��� �������� ������ �� ������ �������)
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
// Create worksheet �������� ������
// ================================================================
$cart =& $xls->addWorksheet('opened');

# Add the title
// Some text to use as a title for the worksheet
$titleText = '������ ������������� �������� ' . date('dS M Y') . '(+ ������; - ������)';

// Create a format object
$titleFormat =& $xls->addFormat(array('Size' => 13, 'Align' => 'merge', 'Color' => 'navy',
                                      'Bold'  => '1', 'Bottom'=> '2', 'BottomColor' => 'navy'));

// Set the font family - Helvetica works for OpenOffice calc too...
$titleFormat->setFontFamily('Helvetica');
$cart->write(1,0,$titleText,$titleFormat);
$cart->write(1,1,'',$titleFormat);
$cart->write(1,2,'',$titleFormat);
//$cart->write(1,3,'',$titleFormat);

// ������ ������
$cart->setRow(1,30);
// ������ ��� ���������
$colHeadingFormat =& $xls->addFormat(array('Size' => 10, 'Align' => 'center', 'Border'  => '1', 'Bottom'=> '2'));
$colHeadingFormat->setFontFamily('Helvetica');
$colHeadingFormat->setVAlign('vcenter');
$colHeadingFormat->setTextWrap();
// ������ �������
$cart->setColumn(0,0,7); // A - ����� �/�
$cart->setColumn(1,1,18); // B - ���� ��������
$cart->setColumn(2,2,50); // C - ����������
$cart->setColumn(3,14,10); // D-L ������
$cart->setColumn(15,24,12); // E - ����� ...

# ������� ���������
// An array with the data for the column headings
$colNames = array('N �/�','���� ����. ��������������','����������',"���","������","����","��������� $","WMU", "WMZ","WME","WMR",
                  "Betfair \$", "Betfair EUR", "Wire \$", "Wire EUR", "��������� $",
                  "�����", "������", "��� �������", "����� �������", "��� ������������", "����� ������������", "���������", "���", "EUR", "���");

// Add all the column headings with a single call
// leaving a blank row to look nicer
$cart->writeRow(3,0,$colNames,$colHeadingFormat);

// ������ ����� ��� �������������
// 1-�� �������� - ������� ������������� �����������
// 2-�� �������� - ������� ��������������� ����������� (0 = ��� ��������������� �����������)
// 3-�� �������� - ������� ������� ������ ����� ������������� �����������
// 4-�� �������� - ����� ������� ������� ����� ��������������� �����������
// ������� ������ �������� 4 ������, 1 �����
$freeze = array(4,1,4,1);

// ���������� ��� ������!
$cart->freezePanes($freeze);

//============= SQL ==================================================
   $sqlSumField = "";
   for ($i=0; $i<count($sumFields); $i++)
   	  $sqlSumField.= "SUM(".$sumFields[$i]."), ";
   $sqlSumField = substr($sqlSumField, 0, -2);

   // ����� ���� �������� ����� ��������, ����� ����� ����(9) � ����� �����(15)
   $sql = "SELECT *, MIN(Descr), $sqlSumField FROM $table
           LEFT OUTER JOIN $group ON ($table.group_id = $group.id)
           INNER JOIN $client ON ($table.id_client = $client.id_client)
           WHERE error Is NULL AND ($group.closed IS NULL) AND ($table.id_client<>9) AND ($table.id_client<>15)
           $query_data
           GROUP BY $table.group_id
           ORDER BY added, DateTS";
   $opened_group_row = OpenSQL ($sql, $opened_group_rows, $opened_group_res);
   //echo $sql;
// ������ ��� ���������
$colDataFormat =& $xls->addFormat(array('Border'  => '1'));
$colDataFormat->setTextWrap();
$colDataFormat->setVAlign('vequal_space');
// ������ ��� ����
$colSumFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00'));
// ������ ��� ������
$colFormula =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00', 'locked' => 1, 'FgColor' => 22));
// �������� ��� ������
$rowFormat =& $xls->addFormat(array('Border'  => '1'));
$rowFormat->setVAlign('vequal_space');
//������ ��� ������ (5 ������ ����� �������)
$colCourseFormat =& $xls->addFormat(array('Border'  => '1','NumFormat' => '0.00000'));

// Use this to keep track of the current row number
$currentRow = 4;

if (!$opened_group_row) {
	for ($i=0; $i<$opened_group_rows; $i++) {
        $row = NULL;
        $cart->setRow($currentRow,30, $rowFormat);
        // �������� ������
		GetFieldValue ($opened_group_res, $row, 'SUM(iUAH)', $SUMiUAH, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oUAH)', $SUMoUAH, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oUSD)', $SUMoUSD, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(iUSD)', $SUMiUSD, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(iEUR)', $SUMiEUR, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'SUM(oEUR)', $SUMoEUR, $IsNull);
        // ����� �����
		GetFieldValue ($opened_group_res, $row, 'USD', $USD, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'EUR', $EUR, $IsNull);
		GetFieldValue ($opened_group_res, $row, 'RUR', $RUR, $IsNull);
		$SUM_CASH = ($SUMiUAH-$SUMoUAH)/$USD+$SUMiUSD-$SUMoUSD+($SUMiEUR-$SUMoEUR)*$EUR/$USD;

		// N �/� | ���� | ���������� | ��� | ������ | ���� | ���������, ������ | WMU| WMZ | WME | ... | ����� | ������ | ��� ������ | ����� ������ | ��� ������ | ����� ������
        // N �/�
		GetFieldValue ($opened_group_res, $row, 'group_id', $group_id, $IsNull);
		if ($group_id<>"")	{
			$cart->writeUrl($currentRow,0,"$http/s/editgroup.asp?do=edit&group_id=".md5($group_id+$group_id),$group_id, $colDataFormat);
			// ���� �������������� ������
			GetFieldValue ($opened_group_res, $row, 'last_edited', $edited, $IsNull);
	        $cart->write($currentRow,1,$edited, $colDataFormat);
		} else {
			$cart->write($currentRow,0,"-", $colDataFormat);
        	$cart->write($currentRow,1,"", $colDataFormat);
        }
        // �������� (� ���������� � ������ �������� ���� �����, �.�. ������ �������� ������)
		GetFieldValue ($opened_group_res, $row, 'MIN(Descr)', $Descr, $IsNull);
        $Descr = str_replace("!","",$Descr);
        $Descr = str_replace("������� �� ����� ������ �������","",$Descr);
        $Descr = str_replace("�������� Webmoney. ","",$Descr);
        $cart->writeString($currentRow,2,$Descr, $colDataFormat);
        if ($group_id<>"") {
	        // ������������ ������� �������� ������ �� �������
	        $sql_descr = "SELECT descr FROM $table WHERE group_id = $group_id";
	        $descr_row = OpenSQL ($sql_descr, $descr_rows, $descr_res);
	        if (!$descr_row) {
	        	$all_descr = "";
	        	for ($j=0; $j<$descr_rows; $j++) {
	        		$row_descr = NULL;
	        		GetFieldValue ($descr_res, $row_descr, 'descr', $Descr_transaction, $IsNull);
	        		if (!ereg("�������� Webmoney", $Descr_transaction)) {
	        			$Descr_transaction = str_replace("������� �� ����� ������ �������","",$Descr_transaction);
	        			$Descr_transaction = str_replace("!","",$Descr_transaction);
	        			$all_descr.= $Descr_transaction."\r\n";
	        		}
	            }
	            $cart->writeNote($currentRow,2,$all_descr);
	        }
        }
        // ���
        if ($SUMiUAH-$SUMoUAH<>0) $cart->write($currentRow,3,$SUMiUAH-$SUMoUAH, $colSumFormat);
        if ($SUMiUSD-$SUMoUSD<>0) $cart->write($currentRow,4,$SUMiUSD-$SUMoUSD, $colSumFormat);
        if ($SUMiEUR-$SUMoEUR<>0) $cart->write($currentRow,5,$SUMiEUR-$SUMoEUR, $colSumFormat);
        // ���������, ������
		$excelRow = $currentRow + 1;
		$formula = "=(D$excelRow/X$excelRow) + E$excelRow + (F$excelRow*Y$excelRow/X$excelRow)" ;
		$cart->writeFormula($currentRow,6, $formula, $colFormula);
        // ��������� ������
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
        // ���������, ������
		$formula = "=(H$excelRow/X$excelRow) + I$excelRow + (J$excelRow*Y$excelRow/X$excelRow) + (K$excelRow*Z$excelRow/X$excelRow)".
		           "+ L$excelRow + (M$excelRow*Y$excelRow/X$excelRow) + N$excelRow + (O$excelRow*Y$excelRow/X$excelRow)" ;
		$cart->writeFormula($currentRow,15, $formula, $colFormula);

        // ��������������� ����������
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

        // ����� ����� ���
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
$cart->write($currentRow,0,'�����:',$gTFormat);

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

// ��������� ������
$zip = new ZipArchive();

if ($zip->open("./reestrs/$filename.zip", ZIPARCHIVE::CREATE)!==TRUE) {
    exit("cannot open <$filename>\n");
}
$thisdir = "./";
$zip->addFile($thisdir.$filename, $filename);
if (($zip->numFiles==1) && ($zip->status==0)) {
	echo "<a href=\"/excel_code/reestrs/$filename.zip\">�������</a>";
} else "���� �� ������!";
$zip->close();
unlink($filename);

?>