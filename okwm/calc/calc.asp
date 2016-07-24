<?php

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/config.asp");
require("calc.server.asp");

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Calc</title>
    <?php
      $xajax->printJavascript(DOMAIN_HTTP.'/xajax/');
    ?>
  </head>
  <body>
  <form id="calcForm" onsubmit="return false;">
      <input type=radio id="Action1" name="Action" value="sell" checked="checked" />
    Платят <input type="text" id="inSum" name="inSum" value="" size="15" />
      <select size="1" id="inMoney" name="inMoney">
     <option value="WMZ">WMZ</option>
     <option value="WME">WME</option>
     <option value="WMR">WMR</option>
     <option value="WMU">WMU</option>
     <option value="USD">USD</option>
     <option value="EUR">&euro;</option>
     <option value="NUAH">грн</option>
     <option value="P24">Приват24</option>
     <option value="UKSH">Ukash &euro;</option>
      </select>&nbsp; =>
      <input type=radio id="Action2" name="Action" value="buy"/>
    Получают <input type="text" id="outSum" name="outSum" value="" size="15" />
      <select size="1" id="outMoney" name="outMoney">
     <option value="WMZ">WMZ</option>
     <option value="WME">WME</option>
     <option value="WMR">WMR</option>
     <option value="WMU">WMU</option>
     <option value="UKSH">Ukash &euro;</option>
     <option value="USD" selected>USD</option>
     <option value="EUR">&euro;</option>
     <option value="NUAH">грн</option>
     <option value="PCB">Южкомбанк</option>
     <option value="SBRF">Сбербанк России</option>
      </select>&nbsp;
    <input type="submit" value="Calculate" onclick="xajax_calc(xajax.getFormValues('calcForm'));return false;" />
    </form>
  <div id="submittedDiv" style=" margin: 3px;"></div>
  </body>
</html>