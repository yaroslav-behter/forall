<script language="JavaScript">
<!-- Hide from old browsers
//Hide from Java Script
function echoDocs(selected) {
	doc_obj = document.getElementById? document.getElementById("doc") : document.all.doc;
	if (selected.value=='����') {
		doc_obj.innerHTML = '<br />��� ��������� ������ ����������� ��� ���������� ����� ���������� ��������!'+
		'<table style="margin: 0;">'+
		'<tr><td>�������:</td><td><input type=text name="lastname" value="" maxlength=40 size=40></td></tr>'+
		'<tr><td>���:</td><td><input type=text name="firstname" value="" maxlength=40 size=40></td></tr>'+
		'<tr><td>��������:</td><td><input type=text name="midlename" value="" maxlength=40 size=40></td></tr>'+
		'<tr><td>��������:</td><td><input type=text name="passport" value="" maxlength=40 size=40></td></tr>'+
		'<tr><td>���������� � ������� (���� ����������):</td><td><input type=text name="descr" value="" maxlength=40 size=40></td></tr>'+
		'<tr><td>��� ��������� (���� ����������):</td><td><input type=text name="prot" value="" maxlength=40 size=40></td></tr>'+
		'</table>';
	} else
	    doc_obj.innerHTML = '';
}

//-->
</script>