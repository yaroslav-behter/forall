<?php

$http  = "http://www.okwm.com.ua";
$table = "tactions";// ������� ������
$client = "tactions_client"; // ������� ��������
$group = "tgroups";          // ������� ��� ����������� ��������

$start_date  = date ("Y-m-d H:i:00", mktime (0, 0, 0, 4, 01, 2009));
$end_date    = date ("Y-m-d H:i:00", mktime (0, 0, 0, 4, 07, 2009));

$sumFields   = array ('iUAH', 'oUAH', 'iUSD', 'oUSD', 'iEUR', 'oEUR', 'iWMZ', 'oWMZ', 'iWME', 'oWME',
                      'iWMR', 'oWMR', 'iWMU', 'oWMU', 'iEGD', 'oEGD', 'iPCU', 'oPCU', 'iPCR', 'oPCR', 'iZPT', 'oZPT',
                      'iFET', 'oFET', 'iBWU', 'oBWU', 'iBWE', 'oBWE', 'iEBC', 'oEBC', 'iBFU', 'oBFU', 'iBFE', 'oBFE');

set_time_limit (240);
?>
