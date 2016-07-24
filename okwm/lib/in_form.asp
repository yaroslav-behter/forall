<?php   ?>


<tr>
	<td class="lsh"></td>
	<td colspan="2"

		<!-- table align="left" width="100%" cellspacing="0" height="100%" style="min-width:750px" -->
		<table align="right" width="100%" cellspacing="0" height="100%" style="min-width:750px; background-color:#FFF;">
			<tr><!-- Первая строка -->
				<td id="pbl_txt">
					<div id="take" aligh=right style="text-align:right; width:295px; float:right;">
						<div style="width:100px;"><h1 style="float:left;">ВЫ НАМ</h1></div>
                        <div style="float:right; font-size:11px; text-align:left; margin:0 0 0 0; width:190px;">Введите в окошко электронную валюту или наличные, которые есть у вас и вы хотели бы их обменять.</div>
					</div>
				</td>
				<td id="pbr_txt">
					<div id="give" >
						<h1 style="float:left;">МЫ ВАМ</h1>
                        <div style="font-size:11px; text-align:left; width: 290px;">Отметьте, какую валюту вы хотите получить в результате операции.</div>
					</div>
				</td>
				<td id="pbl_txt">
					<div id="town" >
						<div><h1 style="float:left;">ГОРОД</h1></div>
                        <div style="font-size:11px; text-align:left; float: right; width: 130px;">Город можно выбрать при операции с наличными деньгами.</div>
					</div>
				</td>
			</tr>

<!-- А вот тут наши валюты -->
<!-- Проверка вставки из сформированного массива -->

<?php
// Подключение массивов валют $In_Val_name, $In_Val_code, $Out_Val_name, $Out_Val_code, $Town_name
require_once("${HTTP_SERVER_VARS['DOCUMENT_ROOT']}/lib/in_form_val.asp");
$i=0;
while ($i<=count($max_name)-1){
	echo "<tr>\n";
// Первая колонка Вы Нам
	echo "  <td id='pblall'>\n";
	echo "    <div id='takeall'>\n";
	if(isset($In_Val_name[$i])){
		echo "	$In_Val_name[$i]\n";
		echo "	<input type=text id='money2give' name='InSum".$i."' size=13 value='' onMouseOver='show_input(this)' onMouseOut='hide_input(this)' onFocus='focus_input(this)' onBlur='blur_input(this)' onKeyUp='clear_num(this, ".count($In_Val_name).", ".count($Out_Val_name).", ".count($Town_name).", \"".$In_Val_code[$i]."\")'>\n";
		echo "	<input type=checkbox name='inchk".$i."' style='visibility:hidden;' onMouseDown='clear_inchk(this, ".count($In_Val_name).", ".count($Out_Val_name).")' />\n";
		echo "	<img name='inline".$i."' style='opacity:0.1; filter:alpha(opacity=10); '  width='26' height='16' src='img/array-right.png' />\n";
	}
	echo "    </div>\n";
	echo "  </td>\n";
// Вторая колонка Мы Вам
	echo "  <td id='pbrall'>\n";
	echo "    <div id='giveall'>\n";
	if(isset($Out_Val_name[$i])){
		echo "	<img name='outline".$i."' style='opacity:0.1; filter:alpha(opacity=10); ' width='26' height='16' src='img/array-right.png' />\n";
		echo "  <input type='text' id='money2out' size=13 name='OutSum".$i."' value='' onMouseOver='show_input(this)' onMouseOut='hide_input(this)' onFocus='focus_input(this)' onBlur='blur_input(this)' onKeyUp='clear_num(this, ".count($In_Val_name).", ".count($Out_Val_name).", ".count($Town_name).", \"".$Out_Val_code[$i]."\")' />\n";
		echo "	<input type=checkbox name='outchk".$i."' style='visibility:hidden;' onMouseDown='clear_outchk(this, ".count($In_Val_name).", ".count($Out_Val_name).");' />\n";
		echo "	$Out_Val_name[$i]\n";
	}
	echo "    </div>\n";
	echo "  </td>\n";
// Третья колонка Города
	echo "  <td id='pbtall'>\n";
	echo "    <div id='townall' align='right'>\n";
	if(isset($Town_name[$i])){
		echo "	$Town_name[$i]";
		echo "	<input type=checkbox name='town".$i."' style='visibility:hidden;' onMouseDown='clear_town(this)' value='".$Town_name[$i]."'/>\n";
	}
	echo "    </div>\n";
	echo "  </td>\n";
	echo "</tr>\n";
	$i++;
}

?>
           <input type=hidden value="Ok" name="order">
<!-- КОНЕЦ - Проверка вставки из сформированного массива -->
<!-- Конец блока - А вот тут наши валюты -->

			<tr><!-- Последняя строка -->
				<td id="pblall"  ></td>
				<td id="pbrall"  ></td>
				<td id="pblall" ></td>
			</tr>
		</table>
	</td>
	<td class="rsh"></td>
</tr>
