<?php
#--------------------------------------------------------------------
# OKWM partners page.
# Copyright by Yaroslav Behter (behter@hoodrook.com), (c) 2003-2006.
#--------------------------------------------------------------------
# Requires /lib/utility.asp
#--------------------------------------------------------------------

require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/utility.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/verifysum.asp");
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/database.asp");
$http = (!isset($HTTP_SERVER_VARS['HTTPS']))? DOMAIN_HTTP : DOMAIN_HTTPS;

// Контакты
$title = "Тарифы сервиса OKWM – ввод, вывод, обмен WebMoney WMZ WMR WME WMU, Ukash, Pokerstars, Betfair";
$Keywords = "комиссия Webmoney, курс обмена wmz, купить WMZ, продать WMZ, wmz на доллары, WMZ на наличные, купить wm, WMZ, WME, продать WebMoney, обмен, обменник, электронная валюта";
$Description = "Тарифы обменного сервиса OKWM - выгодно и быстро обменять WebMoney, Ukash, Pokerstars, Betfair в Киеве, Одессе, Днепропетровске.";
HTMLHead ($title, $Keywords, $Description);
echo <<<EOT

   <tr><td></td><td id="phl"><img width="1" height="4" alt="" src="$http/img/0.gif" /></td>
       <td id="phr"><img width="210" height="1" alt="" src="$http/img/0.gif" /></td><td></td>
       <td rowspan="5" class="right_banners">
EOT;
    if (!isset($HTTP_SERVER_VARS['HTTPS'])) EchoBaners ();
    echo <<<EOT

   </td>
   </tr>
   <tr><td class="lsh"></td><td id="pbl">
       <h1>Тарифы</h1>
   </td>
   <td id="pbr">&nbsp;
    </td><td class="rsh"></td>
   </tr>
     <tr height="600"><td class="lsh"></td><td id="content" colspan="2">
      <div id="tarifs">
    <p>
    <div align="center"><b>Тарифы сервиса &quot;OKWM&quot;.</b></div>
    </p><br>
        Наши тарифы меняются в зависимости от суммы обмена:<br>
        1. до $100<br>
        2. от $100 до $1000<br>
        3. от $1000 до $5000<br>
        4. свыше $5000<br><br>

        Чем больше сумма, тем комиссия нашего сервиса меньше.<br>
        При расчете сумм обмена, комиссии платежных систем не учитываются. Поэтому Вы должны учесть их сами.
        При переводе на наши кошельки Webmoney (WMZ, WME, WMR и WMU), Вы также должны учитывать комиссию системы 0,8%.
        При вводе, выводе и обмене Яндекс.Денег, комиссию платит получатель и она учтена в тарифах.<br>
        Если вы хотите получить или пополнить PokerStars, то эти операции осуществляются без внутренних комиссий.<br />
        Курсы валют ежедневно обновляются с сервера
        <a href="http://www.bank.gov.ua" target=_blank title="Официальный сайт Национального банка Украины.">Национального банка Украины</a>.<br>
        <br>Комиссии (в процентах) нашего сервиса приведены в таблице:<br><br>
EOT;

$k = array_keys($amP);
$v = array_keys($amP[$k[0]]);
echo <<<EOT

<table cellPadding=0 cellSpacing=0>
 <tr><td><div align="right">платите -&gt;</div>
         <div align="left">v получаете</div></td>
EOT;
for ($i=0; $i < count($v); $i++) {
    echo "<td align=middle><b>".GOODS_Name2Descr($v[$i])."</b></td>";
}
echo "</tr>\n";
for ($i=0; $i < count($k); $i++) {
    $str = "<tr><td><b>".GOODS_Name2Descr($k[$i])."</b></td>";
    for ($j=0; $j < count($v); $j++) {
      $z = $amP[$k[$i]][$v[$j]];
      if (($k[$i] == $v[$j])||($z == "100/100/100/100")) {
            $str.= "<td align=middle> X </td>";
        } else {
          $str.= "<td align=middle>".$z."</td>";
        }
    }
    $str.= "</tr>\n ";
    echo $str;
}
echo "</table>";


echo <<<EOT
    </p><br>
        Таким образом, представленные в таблице комиссии следует читать так:<br>
        для сумм до $100 / для сумм от 100$ до $1000 / для сумм от $1000 до $5000 / свыше $5000<br /><br />
        Наличие средств и возможные скидки на ввод и вывод сумм от 10000 USD уточняйте у
        <a href="http://www.okwm.com.ua/contacts.asp">администраторов</a>.
        </p>
      </div>
   </td><td class="rsh"></td></tr>
EOT;

HTMLTail();

function GOODS_Name2Descr ($name) {
  $sql = "SELECT GOODS_DESCRIPTION FROM GOODS WHERE GOODS_NAME = '$name'";
    OpenSQL ($sql, $row, $res);
    if ($row == 1) {
        $row_rec = NULL;
        GetFieldValue ($res, $row_rec, "GOODS_DESCRIPTION", $Descr, $IsNull);
    } else
        $Descr = "";
    return $Descr;
}

?>