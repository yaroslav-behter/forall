foc=Array();
foc['money2out']=0;
foc['money2give']=0;

sh=Array();
sh['from_cur']='from_popup';
sh['to_cur']='to_popup';

va=Array();
va['from_cur']='inmoney';
va['to_cur']='outmoney';

var countTown = 3;

function show_input(a){
  if (navigator.userAgent.indexOf('Opera') >= 0) {
    a.className="inputhoveropera"
  }else{
    a.className="inputhover"
  };
}
function hide_input(a){
  if(foc[a.id] == 0){
    a.className="";
  }
}
function focus_input(a){
  foc[a.id]=1;
 a.style.opacity=1;
}
function blur_input(a){
  foc[a.id]=0;
  hide_input(a);
 a.style.opacity=1;
if(a.value>0){
	a.style.opacity=1;
}else{
   	a.style.opacity=0.5;
}
}

function show_menu(id, event, from) {
    var d = document.getElementById(id);
    if (d.style.visibility != "visible" && from) {
	    d.style.top = event.clientY+document.body.scrollTop-1+'px';
	    d.style.left = event.clientX+document.body.scrollLeft-25+'px';
	}
    d.style.visibility="visible";
}

function hide_menu(id) {
    var d = document.getElementById(id);
    d.style.visibility="hidden";
}

function setval(a,b,c){
  z=document.getElementById(a);
  z.innerHTML = c;
  x=document.getElementById(va[a]);
  x.value=b;
  OutSumChanged(document.forms.makeexchange, document.forms.makeexchange.InSum0.value)
  hide_popup(sh[a]);
}
function clear_num(num, In_Val, Out_Val, Town, In_code){
  var rg = new RegExp('[^1234567890\.,]','gi');
  var rg2 = new RegExp('[,]','gi');
  if(num.value.match(rg)){
    num.value = num.value.replace(rg,'');
  }
  num.value = num.value.replace(rg2,'.');
  if(num.id=='money2give'){
    OutSumChanged(document.forms.makeexchange, num.value, num.name, In_Val, Out_Val, Town, In_code);
  }
  if(num.id=='money2out'){
    InSumChanged(document.forms.makeexchange, num.value, num.name, In_Val, Out_Val, Town, In_code);
  }
}

 function COURSE (outmoney, inmoney) {
 //было        var InMoney = inmoney.value;
  //было        var OutMoney = outmoney.value;
        var InMoney = inmoney;
        var OutMoney = outmoney;

         // проверка на операции с наличными или с одинаковыми валютами
         if ((InMoney == OutMoney)  ||
             ((InMoney == "USD") ||(InMoney == "EUR") ||(InMoney == "NUAH"))&&
             ((OutMoney == "USD")||(OutMoney == "EUR")||(OutMoney == "NUAH")))
             {P2=0; return 0;}

         // купить OutMoney за InMoney
         var ii = ((InMoney == "WMZ"))? "USD":
                  ((InMoney == "WME")||(InMoney == "UKSH"))? "EUR":
                  ((InMoney == "WMR")||(InMoney == "YAD"))? "RUB":
                  ((InMoney == "NUAH")||(InMoney == "WMU"))? "UAH":
                  InMoney;
         var jj = ((OutMoney == "WMZ")||(OutMoney == "BFU")||(OutMoney == "PSU"))? 0:
                  ((OutMoney == "WME")||(OutMoney == "EUR"))? 1:
                  ((OutMoney == "WMR"))? 2:
                  ((OutMoney == "NUAH")||(OutMoney == "WMU")||(OutMoney == "GMU"))? 3:
                   0;

         im  = InMoney.substring(0,2);
         om = OutMoney.substring(0,2);
         P2 = amP[OutMoney][InMoney];
         // Купить OutMoney за ii
         if (Course[ii][jj] != 0)
            return 1/Course[ii][jj]
         else
            return 0;
 }

 // перевод sum в $
 function SumToBucks (money, sum) {
         var jj = ((money == "WMZ")||(money=="PSU")||(money=="BFU"))? 0:
                  ((money == "WME")||(money=="EUR"))? 1:
                  ((money == "WMR")||(money=="YAD"))? 2:
                  ((money == "NUAH")||(money == "WMU")||(money == "GMU"))? 3:
                   0;
         //alert (sum/Course["USD"][jj]);
         return (Course["USD"][jj] != 0)? sum/Course["USD"][jj] : 0;
 }

//МЫ ВАМ
 function InSumChanged (form, outsum, isform, In_Val, Out_Val, Town, Out_code) {	var i=0;
    var outsum0="";
	var outsum1="";
	var outsum2="";
	var outsum3="";
	var outsum4="";
	var outsum5="";
	var outsum6="";
	var outsum7="";
	//var outsum8="";
	outsum = not_space(norm_in(outsum));
	if(outsum!=0){
		if(outsum<10){
			empty_element_out(form, In_Val, Out_Val, Town);
		}
		outsum0=OutSum2InSum("WMZ", Out_code, outsum);
		outsum1=OutSum2InSum("WME", Out_code, outsum);
		outsum2=OutSum2InSum("WMR", Out_code, outsum);
		outsum3=OutSum2InSum("WMU", Out_code, outsum);
		outsum4=OutSum2InSum("USD", Out_code, outsum);
		outsum5=OutSum2InSum("EUR", Out_code, outsum);
		outsum6=OutSum2InSum("NUAH",Out_code, outsum);
		outsum7=OutSum2InSum("YAD", Out_code, outsum);
		//outsum8=OutSum2InSum("UKSH", Out_code, outsum);
		for (i=0; i < In_Val; i++){
				document.getElementsByName("inline"+i)[0].style.opacity=1;
				document.getElementsByName("inline"+i)[0].style.filter = 'alpha(opacity=100)';
				document.getElementsByName("InSum"+i)[0].style.opacity=1;
				document.getElementsByName("inchk"+i)[0].checked=false;
				document.getElementsByName("inchk"+i)[0].style.visibility="visible";
				document.getElementsByName("inchk"+i)[0].style.opacity=1;
				document.getElementsByName("inchk"+i)[0].style.filter = 'alpha(opacity=100)';
        }
		for (i=0; i < Out_Val; i++){
			if(isform=="OutSum"+i){
				document.getElementsByName("OutSum"+i)[0].style.opacity=1;
				document.getElementsByName("OutSum"+i)[0].value=outsum;
				document.getElementsByName("outline"+i)[0].style.opacity=1;
				document.getElementsByName("outline"+i)[0].style.filter = 'alpha(opacity=100)';
				document.getElementsByName("outchk"+i)[0].style.visibility="visible";
				document.getElementsByName("outchk"+i)[0].checked=true;
				// осветление строки напротив вводимой МЫ ВАМ (где одинаковые валюты)
				if((i < In_Val)&&(i<=6)) {				    // До 7й строки валюты напротив совпадают
    				empty_one_element(i, "in");
				}
				if(i==4 || i==5 || i==6){
				    // нал на нал не меняется
					empty_one_element(4, "in"); outsum4=0;
					empty_one_element(5, "in"); outsum5=0;
					empty_one_element(6, "in"); outsum6=0;
				}
				//if(i==9){
				    // UKASH на UKASH не меняется
					//empty_one_element(8, "in"); outsum8=0;
				//}
			}
        }
	    form.InSum0.value=out_number(outsum0);
	    form.InSum1.value=out_number(outsum1);
	    form.InSum2.value=out_number(outsum2);
	    form.InSum3.value=out_number(outsum3);
	    form.InSum4.value=out_number(outsum4);
 	    form.InSum5.value=out_number(outsum5);
	    form.InSum6.value=out_number(outsum6);
	    form.InSum7.value=out_number(outsum7);
	    //form.InSum8.value=out_number(outsum8);
	}
 }

//ВЫ НАМ
 function OutSumChanged (form,insum,isform, In_Val, Out_Val, Town, In_code) {
	var i=0;
    var outsum0="";
	var outsum1="";
	var outsum2="";
	var outsum3="";
	var outsum4="";
	var outsum5="";
	var outsum6="";
	var outsum7="";
	var outsum8="";
	//var outsum9="";
    insum = not_space(norm_in(insum));
   if(insum!=0){
		if(insum<9){
			empty_element(form, In_Val, Out_Val, Town);
		}
		outsum0=InSum2OutSum(In_code, "WMZ", insum);
		outsum1=InSum2OutSum(In_code, "WME", insum);
		outsum2=InSum2OutSum(In_code, "WMR", insum);
		outsum3=InSum2OutSum(In_code, "WMU", insum);
		outsum4=InSum2OutSum(In_code, "USD", insum);
		outsum5=InSum2OutSum(In_code, "EUR", insum);
		outsum6=InSum2OutSum(In_code, "NUAH",insum);
		outsum7=InSum2OutSum(In_code, "BFU", insum);
		outsum8=InSum2OutSum(In_code, "PSU", insum);
		//outsum9=InSum2OutSum(In_code, "UKSH", insum);
		for (i=0; i < Out_Val; i++){
			if(isform=="InSum"+i){
				document.getElementsByName("InSum"+i)[0].style.opacity=1;
				document.getElementsByName("InSum"+i)[0].value=insum;
				document.getElementsByName("inline"+i)[0].style.opacity=1;
				document.getElementsByName("inline"+i)[0].style.filter = 'alpha(opacity=100)';
				if (i<=6) {				    // Гасим стрелку напротив ВЫ НАМ (актуально до ГРН)
				    empty_one_element(i, "out");
				}
				document.getElementsByName("inchk"+i)[0].style.visibility="visible";
				document.getElementsByName("inchk"+i)[0].checked=true;
				if(i==4 || i==5 || i==6){				    // in USD, EUR, UAH
				    empty_one_element(4, "out"); outsum4=0;
				    empty_one_element(5, "out"); outsum5=0;
				    empty_one_element(6, "out"); outsum6=0;
				}
				//if(i==8){
				    // UKASH на UKASH не меняется
					//empty_one_element(9, "out"); outsum9=0;
				//}
				if(i==0 || i==1 || i==2 || i==3){
				    // UKASH на BF POKERSTARS не меняется
					empty_one_element(7, "out"); outsum7=0;
					empty_one_element(8, "out"); outsum8=0;
					//empty_one_element(9, "out"); outsum9=0;
				}
			};
		};
		form.OutSum0.value=out_number(outsum0);
		form.OutSum1.value=out_number(outsum1);
		form.OutSum2.value=out_number(outsum2);
		form.OutSum3.value=out_number(outsum3);
		form.OutSum4.value=out_number(outsum4);
		form.OutSum5.value=out_number(outsum5);
		form.OutSum6.value=out_number(outsum6);
		form.OutSum7.value=out_number(outsum7);
		form.OutSum8.value=out_number(outsum8);
		//form.OutSum9.value=out_number(outsum9);
	}
 }
 function empty_one_element(i, side){     // гасит елемент формы
     //alert(i+" -- "+side);
     document.getElementsByName(side+"line"+i)[0].style.opacity=0.1;
     document.getElementsByName(side+"line"+i)[0].style.filter = 'alpha(opacity=10)';
     document.getElementsByName(side+"chk"+i)[0].style.visibility="hidden";
     if (side=="in"){		document.getElementsByName("InSum"+i)[0].style.opacity=0.5;
		document.getElementsByName("InSum"+i)[0].value="";
     }
     if (side=="out") {		document.getElementsByName("OutSum"+i)[0].style.opacity=0.5;
		document.getElementsByName("OutSum"+i)[0].value="";
     }
 }
 function enable_one_element(i, side){     // подсвечивает элемент формы
     document.getElementsByName(side+"line"+i)[0].style.opacity=1;
     document.getElementsByName(side+"line"+i)[0].style.filter = 'alpha(opacity=100)';
     document.getElementsByName(side+"chk"+i)[0].style.visibility="visible";
     if (side=="in"){
		document.getElementsByName("InSum"+i)[0].style.opacity=1;
     }
     if (side=="out") {
		document.getElementsByName("OutSum"+i)[0].style.opacity=1;
     }
 }
// нужно сделать подобную функцию empty_element() для колонки МЫ ВАМ
 function empty_element_out(form, In_Val, Out_Val, Town){
	 	var i=0;
		for (i=0; i < In_Val; i++){
			// Обнуление полей ввода
			document.getElementsByName("InSum"+i)[0].value="";
			// Прозрачность поля ввода InSum
			document.getElementsByName("InSum"+i)[0].style.opacity=1;
			// Прозрачность стрелки InSum
			document.getElementsByName("inline"+i)[0].style.opacity=1;
			document.getElementsByName("inline"+i)[0].style.filter = 'alpha(opacity=100)';
			// Прозрачность checkbox InSum
			document.getElementsByName("inchk"+i)[0].style.visibility="visible";
        };
		for (i=0; i < Out_Val; i++){
			// Обнуление полей ввода
			document.getElementsByName("OutSum"+i)[0].value="";
			// Прозрачность стрелки OutSum
			document.getElementsByName("outline"+i)[0].style.opacity=0.1;
			document.getElementsByName("outline"+i)[0].style.filter = 'alpha(opacity=10)';
			// Прозрачность поля ввода OutSum
			document.getElementsByName("OutSum"+i)[0].style.opacity=0.1;
			// Прозрачность checkbox OutSum
			document.getElementsByName("outchk"+i)[0].style.visibility="hidden";
        };
		// Обнуление checkbox OutSum
		clear_outchk_full(In_Val, Out_Val);
		// Прозрачность checkbox Town
		for (i=0; i < Town; i++){
				 document.getElementsByName("town"+i)[0].style.visibility="hidden";
        }
 }

 function empty_element(form, In_Val, Out_Val, Town){
	 	var i=0;
		for (i=0; i < In_Val; i++){
			// Обнуление полей ввода
			document.getElementsByName("InSum"+i)[0].value="";
			// Прозрачность поля ввода InSum
			document.getElementsByName("InSum"+i)[0].style.opacity=0.5;
			// Прозрачность стрелки InSum
			document.getElementsByName("inline"+i)[0].style.opacity=0.1;
			document.getElementsByName("inline"+i)[0].style.filter = 'alpha(opacity=10)';
			// Прозрачность checkbox InSum
			document.getElementsByName("inchk"+i)[0].style.visibility="hidden";
        };
		for (i=0; i < Out_Val; i++){
			// Прозрачность стрелки OutSum
			document.getElementsByName("outline"+i)[0].style.opacity=1;
			document.getElementsByName("outline"+i)[0].style.filter = 'alpha(opacity=100)';
			// Прозрачность поля ввода OutSum
			document.getElementsByName("OutSum"+i)[0].style.opacity=1;
			// Прозрачность checkbox OutSum
			document.getElementsByName("outchk"+i)[0].style.visibility="visible";
        };
		// Обнуление checkbox OutSum
		clear_outchk_full(In_Val, Out_Val);
		// Прозрачность checkbox Town
		for (i=0; i < Town; i++){
				 document.getElementsByName("town"+i)[0].style.visibility="hidden";
        }
 }

 function not_space(value){
         var nsvalue='';
         for (var i=0; i <= value.length; i++){
                 if (value.charAt(i) != " ") nsvalue += value.charAt(i) + '';
         }
         return nsvalue;
 }

 function out_number(val){
         if(isNaN(val)) return '';
         val=val+'';
         var div=val.indexOf('.');
         if(div==-1){
                 return val+'.00'
         }else if(val.length >div+3 ){
                 val=val.substr(0,div+3);
         }else for(var i=val.length;i<div+3;i++) val+='0';
         return val;
 }

 function norm_in(val){
         var div=val.indexOf(',');
         if(div!=-1) val=val.substr(0,div)+'.'+val.substr(div+1,val.length);
         if(! isNaN(val) && val <0 ) val=-val;
         return val;
 }

 function round2(val){
         return Math.round((val+0.0000001)*100)/100;
 }

function clear_outchk(a, In_Val, Out_Val){
	var chek=a.checked;
	var test=0;
	for (var i=0; i < In_Val; i++){
		if (document.getElementsByName("InSum"+i)[0].value>0){
			test=test+1;
		};
	};
	if (test>1){
		clear_outchk_full(In_Val, Out_Val);
	}else{
		for (var i=0; i < Out_Val; i++){
			document.getElementsByName("outchk"+i)[0].checked=false;
			document.getElementsByName("outchk"+i)[0].style.opacity=1;
			document.getElementsByName("outchk"+i)[0].style.filter = 'alpha(opacity=100)';
		};
	};
	a.checked=chek;
	if(!a.checked){
		for (i=0; i < Out_Val; i++){
			document.getElementsByName("outchk"+i)[0].style.opacity=0.5;
			document.getElementsByName("outchk"+i)[0].style.filter = 'alpha(opacity=50)';
  			document.getElementsByName("outline"+i)[0].style.opacity=0.1;
			document.getElementsByName("outline"+i)[0].style.filter = 'alpha(opacity=10)';
		};
	};
	a.style.opacity=1;
	for (i=0; i < Out_Val; i++){
		if (a.name == "outchk"+i){
			document.getElementsByName("outline"+i)[0].style.opacity=1;
			document.getElementsByName("outline"+i)[0].style.filter = 'alpha(opacity=100)';
		};
	};
	if(a.name=="outchk4"){
		if((document.getElementsByName("outchk1")[0].style.opacity==0.5) || (document.getElementsByName("outchk2")[0].style.opacity==0.5)){
			town_on(a);
		}else{
			town_off(a);
		};
	}else if(a.name=="outchk5"){
		if((document.getElementsByName("outchk1")[0].style.opacity==0.5) || (document.getElementsByName("outchk2")[0].style.opacity==0.5)){
			town_on(a);
		}else{
			town_off(a);
		};
	}else if(a.name=="outchk6"){
		if((document.getElementsByName("outchk1")[0].style.opacity==0.5) || (document.getElementsByName("outchk2")[0].style.opacity==0.5)){
			town_on(a);
		}else{
			town_off(a);
		};
	}else{
	town_off(a);
	};
	if((document.getElementsByName("InSum4")[0].style.opacity==1) || (document.getElementsByName("InSum5")[0].style.opacity==1) || (document.getElementsByName("InSum6")[0].style.opacity==1)){
		town_on(a);
	};
}

function clear_outchk_full(In_Val, Out_Val){
	for (var i=0; i < In_Val; i++){
		document.getElementsByName("inchk"+i)[0].checked=false;
		document.getElementsByName("inchk"+i)[0].style.opacity=1;
		document.getElementsByName("inchk"+i)[0].style.filter='alpha(opacity=100)';
	};
	for (var i=0; i < Out_Val; i++){
		document.getElementsByName("outchk"+i)[0].checked=false;
		document.getElementsByName("outchk"+i)[0].style.opacity=1;
		document.getElementsByName("outchk"+i)[0].style.filter = 'alpha(opacity=100)';
    };
}

function clear_inchk(a, In_Val, Out_Val){
	var chek=a.checked;
	clear_inchk_full(In_Val, Out_Val);
	a.checked=chek;
	if(!a.checked){
		for (i=0; i < In_Val; i++){
			document.getElementsByName("inchk"+i)[0].style.opacity=0.5;
			document.getElementsByName("inchk"+i)[0].style.filter = 'alpha(opacity=50)';
			document.getElementsByName("inline"+i)[0].style.opacity=0.1;
			document.getElementsByName("inline"+i)[0].style.filter = 'alpha(opacity=10)';


	        };
	};
	a.style.opacity=1;
	for (i=0; i < In_Val; i++){
		if (a.name == "inchk"+i){
			document.getElementsByName("inline"+i)[0].style.opacity=1;
			document.getElementsByName("inline"+i)[0].style.filter = 'alpha(opacity=100)';
		};
		if ((a.name=="inchk4")||(a.name=="inchk5")||(a.name=="inchk6")||(document.getElementsByName("outchk4")[0].checked)||(document.getElementsByName("outchk5")[0].checked)||(document.getElementsByName("outchk6")[0].checked)){
			town_on();
		}else{
			town_off();
		};
    };
}

function clear_inchk_full(In_Val, Out_Val){
	for (var i=0; i < In_Val; i++){
		document.getElementsByName("inchk"+i)[0].checked=false;
		document.getElementsByName("inchk"+i)[0].style.opacity=1;
		document.getElementsByName("inchk"+i)[0].style.filter = 'alpha(opacity=100)';
		document.getElementsByName("inline"+i)[0].style.opacity=1;
		document.getElementsByName("inline"+i)[0].style.filter = 'alpha(opacity=100)';
    };
}

function town_on(a){
	for (var i=0; i<countTown; i++){
		document.getElementsByName("town"+i)[0].style.visibility="visible";
		document.getElementsByName("town"+i)[0].checked=false;
		document.getElementsByName("town"+i)[0].style.opacity=1;
		document.getElementsByName("town"+i)[0].style.filter = 'alpha(opacity=100)';
	};
}
function town_off(a){
	for (var i=0; i<countTown; i++){
		document.getElementsByName("town"+i)[0].style.visibility="hidden";
	};
}
function clear_town(a){
	var chek=a.checked;
	town_on();
	a.checked=chek;
	if(!a.checked){
		for (var i=0; i<countTown; i++){
			document.getElementsByName("town"+i)[0].style.opacity=0.5;
		}
	};
	a.style.opacity=1;
}
