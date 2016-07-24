<script language="JavaScript">
<!-- Hide from old browsers
//Hide from Java Script
function echoDocs(selected) {
	doc_obj = document.getElementById? document.getElementById("doc") : document.all.doc;
	if (selected.value=='Киев') {
		doc_obj.innerHTML = '<br />Для посещения ячейки депозитария Вам необходимо будет предъявить документ!'+
		'<table style="margin: 0;">'+
		'<tr><td>Фамилия:</td><td><input type=text name="lastname" value="" maxlength=40 size=40></td></tr>'+
		'<tr><td>Имя:</td><td><input type=text name="firstname" value="" maxlength=40 size=40></td></tr>'+
		'<tr><td>Отчество:</td><td><input type=text name="midlename" value="" maxlength=40 size=40></td></tr>'+
		'<tr><td>Документ:</td><td><input type=text name="passport" value="" maxlength=40 size=40></td></tr>'+
		'<tr><td>Примечание к платежу (если необходимо):</td><td><input type=text name="descr" value="" maxlength=40 size=40></td></tr>'+
		'<tr><td>Код протекции (если необходимо):</td><td><input type=text name="prot" value="" maxlength=40 size=40></td></tr>'+
		'</table>';
	} else
	    doc_obj.innerHTML = '';
}

//-->
</script>