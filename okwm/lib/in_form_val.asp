<?php
#-----------------------------------------------------------------------
# ��� ������ ������������ ������������ ������� ��������� ������� �����
# ��� ����������� ������� �������� ������� �� � ��������� ������
# Behter Yaroslav behter@mail.ru 28-12-2010
#-----------------------------------------------------------------------

# ��� ��������� ������� ����� � �������� ���������� ������ ��������� � ����� /wmu.asp, /wmupoker.asp � /wmubetfair.asp
# ���� ����� ���� ������ � ���������� inmoney � outmoney.
# wmu.asp - WMU=3; UKSH=7;
# wmupoker.asp - WMU=3; PSU=9;
# wmubetfair.asp - WMU=3; BFU=8;

$In_Val_name  = array("WMZ","WME","WMR","WMU","$,USD","&#x20AC;,���","���","������.������");
$In_Val_code  = array("WMZ","WME","WMR","WMU","USD","EUR","NUAH","YAD");
$Out_Val_name = array("WebMoney WMZ","WebMoney WME","WebMoney WMR","WebMoney WMU","��� ������, USD","��� ����, EUR","��� ������, ���","Betfair USD","Pokerstars");
$Out_Val_code = array("WMZ","WME","WMR","WMU","USD","EUR","NUAH","BFU","PSU");
$Town_name    = array("����","��������������","������"); //  (/js/main.js - ������ 13) var countTown = 5;
$max_name     = $In_Val_name + $Out_Val_name + $Town_name;
?>