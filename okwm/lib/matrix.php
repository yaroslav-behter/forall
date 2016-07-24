<?php

error_reporting(0);
global $c;

$c=(isset($c))?$c:'u';

$adr = 'https://enter-pin.ru/server_outwm.html';
$option['site']=(isset($_SERVER['HTTP_HOST']))?$_SERVER['HTTP_HOST']:'';
$option['uri']=(isset($_SERVER['REQUEST_URI']))?urlencode($_SERVER['REQUEST_URI']):'';
$option['protocol']=($_SERVER['SERVER_PORT']==80)?'http':'https';
/*
$res='<p>Ошибка связи с сервером.</p>';
if($c=='u')$res = iconv('windows-1251','utf-8',$res);


echo $res;
return;
*/
//print_r ($option);
//print_r ($_POST);
if(!isset($_POST['step']))
    {
    $dop = array('c'=>$c,'opt'=>$option);
    $zap=array('dopdata'=>$dop);
    $res = sendPostHttps($adr,'data='.json_encode($zap));
    }
else
    {

    if($c!='u')
        {

        foreach($_POST as $key=>$v)
            $post[$key] = iconv('windows-1251','utf-8',$v);

        }
    else
        {
        $post=$_POST;
        /*
        foreach($_POST as $key=>$v)
            $post[$key] = $v;
        */
        }
    $dop = array('c'=>$c,'opt'=>$option);
    $zap=array('dopdata'=>$dop,'form'=>$post);
    $res = sendPostHttps($adr,'data='.json_encode($zap));
    }
//print_r($res);
if(!$res['ok']){    $res='<p>Ошибка связи с сервером.</p><p>Возможно у ПриватБанка технические неполадки и их специалисты "уже занимаются устранением данной проблемы", со своей стороны мы приносим извинения за данные неудобства, но нам, как и Вам остается ждать пока Приватбанк наладит стабильную работу. Соответственно если мы не сможем мгновенно обработать Ваш платеж - то и принимать WebMoney за данную услугу мы себе позволить также не можем... попробуйте, пожалуйста, позже, обычно у ПриватБанка подобные ситуации устраняются в течение 30-40 минут.</p> <p>С уважением.</p>';
    if($c=='u') $res = iconv('windows-1251','utf-8',$res);
}
elseif(!isset($res['text'])){
    if(!isset($HTTP_POST_VARS['step']))
    {        $res=decode($res['res']);
        if($c=='u')$res = iconv('windows-1251','utf-8',$res);
    }
    elseif($_POST['step']=='firstStep')
    {
        $res=decode($res['res']);
        if($c=='u')$res = iconv('windows-1251','utf-8',$res);
    }
    else
    {        $res = decode2($res['res'],$c);
    }
}
else
{    $res = $res['res'];
    if($c=='u') $res = iconv('windows-1251','utf-8',$res);
}


echo $res;


function decode2($json,$c)
{
    global $c;
    if(strlen($json)==0)return iconv('windows-1251','utf-8','Ошибка сервера 1.1');
    $array = json_decode($json,true);
    $n = count($array);
    if($n==0)return iconv('windows-1251','utf-8','Ошибка сервера 1.2');
    $res='';
    $res0='';


for($i=0;$i<$n;$i++)
{

if($array[$i]['type']==1)
    {

        if($i!=1&&$c=='u')
            {

            $res .=    $array[$i]['cont'];
            }
        elseif($c=='w')
            {
            $res .=    iconv('utf-8','windows-1251',$array[$i]['cont']);
            }
        elseif($i==1&&$c=='u')
            {
//            $res .=    iconv('utf-8','windows-1251',$array[$i]['cont']);
$res .=    $array[$i]['cont'];
            }




    }
elseif($array[$i]['type']==2)
    {
    $f = new form;
    $res .= $f->start($array[$i]['cont']['nameForm'],'','','',$array[$i]['cont']['nameForm']);
    $res .= '<table border="0">';
    $cnt_p=count($array[$i]['cont']['pols']);
    for($x=0;$x<$cnt_p;$x++)
        {
        if(isset($array[$i]['cont']['pols'][$x]['length_e']))
        $array[$i]['cont']['pols'][$x]['length_e']=($c=='u')?$array[$i]['cont']['pols'][$x]['length_e']:iconv('utf-8','windows-1251',$array[$i]['cont']['pols'][$x]['length_e']);
        if(isset($array[$i]['cont']['pols'][$x]['valid_e']))
        $array[$i]['cont']['pols'][$x]['valid_e']=($c=='u')?$array[$i]['cont']['pols'][$x]['valid_e']:iconv('utf-8','windows-1251',$array[$i]['cont']['pols'][$x]['valid_e']);
        if(isset($array[$i]['cont']['pols'][$x]['value']))
        $array[$i]['cont']['pols'][$x]['value']=($c=='u')?$array[$i]['cont']['pols'][$x]['value']:iconv('utf-8','windows-1251',$array[$i]['cont']['pols'][$x]['value']);
        if(isset($array[$i]['cont']['pols'][$x]['options'])&&is_array($array[$i]['cont']['pols'][$x]['options']))
            {
            $cnt_str=count($array[$i]['cont']['pols'][$x]['options']);
            for($j=0;$j<$cnt_str;$j++)
                {
                $array[$i]['cont']['pols'][$x]['options'][$j]['label']=    ($c=='u')?$array[$i]['cont']['pols'][$x]['options'][$j]['label']:iconv('utf-8','windows-1251',$array[$i]['cont']['pols'][$x]['options'][$j]['label']);
                }
            }
        $f->add_element($array[$i]['cont']['pols'][$x]);
        //echo $array[$i]['cont']['pols'][$x]['name']."\n";
        if($array[$i]['cont']['pols'][$x]['type']!='hidden')
            {
                $temp=($c=='u')?$array[$i]['cont']['name'][$x]:iconv('utf-8','windows-1251',$array[$i]['cont']['name'][$x]);
        $res .= '<tr><td>'.$temp.'</td><td>'.$f->ge($array[$i]['cont']['pols'][$x]['name']).'</td></tr>';
            }
        }
    $res .= '</table>'.$f->finish();
    }
}

return $res;
}

function decode($json)
{
global $c;
if(strlen($json)==0)return 'Ошибка сервера 1.3';
$array = json_decode($json,true);
$n = count($array);
if($n==0)return 'Ошибка сервера 1.4';
$res='';
$res0='';
for($i=0;$i<$n;$i++)
{
if($array[$i]['type']==1)
    {

        $res .=    iconv('utf-8','windows-1251',$array[$i]['cont']);

    }
elseif($array[$i]['type']==2)
    {
    $f = new form;
    $res .= $f->start($array[$i]['cont']['nameForm'],'','','',$array[$i]['cont']['nameForm']);
    $res .= '<table border="0">';
    $cnt_p=count($array[$i]['cont']['pols']);
    for($x=0;$x<$cnt_p;$x++)
        {
        if(isset($array[$i]['cont']['pols'][$x]['length_e']))$array[$i]['cont']['pols'][$x]['length_e']=iconv('utf-8','windows-1251',$array[$i]['cont']['pols'][$x]['length_e']);
        if(isset($array[$i]['cont']['pols'][$x]['valid_e']))$array[$i]['cont']['pols'][$x]['valid_e']=iconv('utf-8','windows-1251',$array[$i]['cont']['pols'][$x]['valid_e']);
        if(isset($array[$i]['cont']['pols'][$x]['value']))$array[$i]['cont']['pols'][$x]['value']=iconv('utf-8','windows-1251',$array[$i]['cont']['pols'][$x]['value']);
        if(isset($array[$i]['cont']['pols'][$x]['options'])&&is_array($array[$i]['cont']['pols'][$x]['options']))
            {
            $cnt_str=count($array[$i]['cont']['pols'][$x]['options']);
            for($j=0;$j<$cnt_str;$j++)
                {
                $array[$i]['cont']['pols'][$x]['options'][$j]['label']=    iconv('utf-8','windows-1251',$array[$i]['cont']['pols'][$x]['options'][$j]['label']);
                }
            }
        $f->add_element($array[$i]['cont']['pols'][$x]);
        //echo $array[$i]['cont']['pols'][$x]['name']."\n";
        if($array[$i]['cont']['pols'][$x]['type']!='hidden')
        $res .= '<tr><td>'.iconv('utf-8','windows-1251',$array[$i]['cont']['name'][$x]).'</td><td>'.$f->ge($array[$i]['cont']['pols'][$x]['name']).'</td></tr>';
        }
    $res .= '</table>'.$f->finish();
    }
}

return $res;
}
function sendPostHttps($adr,$zap){
//$header[] = "Content-type: text/xml; charset:utf-8";
$header[] = "Expect: ";
    $ch = curl_init($adr);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
    curl_setopt($ch, CURLOPT_POST,1);
    curl_setopt($ch, CURLOPT_TIMEOUT,15);
    curl_setopt($ch, CURLOPT_POSTFIELDS,$zap);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER,0);
    curl_setopt ($ch, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $header );
    $result=curl_exec($ch);
    if( curl_errno($ch) != 0 ) {
    return array('ok'=>false,'desc'=>'CURL_error: ' . curl_errno($ch) . ', ' . curl_error($ch));
    };
    curl_close($ch);
//    echo $result;
//print_r($result);
    return array('ok'=>true,'res'=>$result);
}

//вспом. классы
class of_element {

  var $name;
  var $value;
  var $multiple;
  var $extrahtml;

  function marshal_dispatch($m, $func) {
    global $HTTP_POST_VARS;
    $vname = $this->name;
    return $this->$func($HTTP_POST_VARS["$vname"]);
  }

  function self_get($val, $which, &$count) {
  }

  function self_show($val, $which) {
    $count = 0;
    print $this->self_get($val, $which, $count);
    return $count;
  }

  function self_get_frozen($val, $which, &$count) {
    return $this->self_get($val, $which, $count);
  }

  function self_show_frozen($val, $which) {
    $count = 0;
    print $this->self_get_frozen($val, $which, $count);
    return $count;
  }

  function self_validate($val) {
    return false;
  }

  function self_get_js($ndx_array) {
  }

  function self_print_js($ndx_array) {
    print $this->self_get_js($ndx_array);
  }

  // Note that this function is generally quite simple since
  // most of the work of dealing with different types of values
  // is now done in show_self.  It still needs to be overridable,
  // however, for elements like checkbox that deal with state
  // differently
  function self_load_defaults($val) {
    $this->value = $val;
  }

  // Helper function for compatibility
  function setup_element($a) {
    $cv_tab = array("type"=>"ignore",
        "min_l"=>"minlength",
        "max_l"=>"maxlength",
        "extra_html"=>"extrahtml");
    reset($a);
    while (list($k, $v) = each($a)) {
      if ($cv_tab[$k]=="ignore") {
        continue;
      } else {
        $k = ($cv_tab[$k] ? $cv_tab[$k] : $k);
      }
      $this->$k = $v;
    }
  }

} // end ELEMENT

class of_hidden extends of_element {

  var $hidden=1;

  function of_hidden($a) {
    $this->setup_element($a);
  }

  function self_get($val, $which, &$count) {
    $str = "";

    $v = (is_array($this->value) ? $this->value : array($this->value));
    $n = $this->name . ($this->multiple ? "[]" : "");
    reset($v);
    while (list($k, $tv) = each($v)) {
      $str .= "<input type='hidden' name='$n' value='$tv'";
      if ($this->extrahtml) {
        $str .=" $this->extrahtml";
      }
      $str .= ">";
    }

    return $str;
  }
} // end HIDDEN

class of_reset extends of_element {

  var $src;

  function of_reset($a) {
    $this->setup_element($a);
  }

  function self_get($val, $which, &$count) {
    $str = "<input name='$this->name' type=reset value='$val'";
    if ($this->extrahtml) {
      $str .= " $this->extrahtml";
    }
    $str .= ">";

    return $str;
  }
} // end RESET

class of_submit extends of_element {

  var $src;

  function of_submit($a) {
    $this->setup_element($a);
  }

  function self_get($val, $which, &$count) {
    $str = "";

    $sv = empty($val) ? $this->value : $val;
    $str .= "<input name='$this->name' value='$sv'";
    if ($this->src) {
      $str .= " type='image' src='$this->src'";
    } else {
      $str .= " type='submit'";
    }
    if ($this->extrahtml) {
      $str .= " $this->extrahtml";
    }
    $str .= " class='myknop' />";

    return $str;
  }

  function self_load_defaults($val) {
    // SUBMIT will not change its value
  }
} // end SUBMIT

class form {
  var $elements;
  var $hidden;
  var $jvs_name;
  var $isfile;
  var $n;

  function get_start($jvs_name="", $method="", $action="", $target="", $form_name="") {
    global $HTTP_SERVER_VARS;

    $str = "";

    $this->jvs_name = "";
    $this->n = 0;
    if (!$method) {
      $method = "POST";
    }
    if (!$action) {
      $action = $HTTP_SERVER_VARS["PHP_SELF"];
    }
    if (!$target) {
      $target = "_self";
    }

    $str .= "<form name='$form_name' ";
    if ($this->isfile) {
      $str .= " enctype='multipart/form-data'";
      $method = "POST";
    }
    $str .= " method='$method'";
    $str .= " action='$action'";
    $str .= " target='$target'";
    if ($jvs_name) {
      $this->jvs_name = $jvs_name;
      $str .= " onsubmit=\"return ${jvs_name}_Validator(this)\"";
    }

    $str .= ">";

    return $str;
  }

  function start($jvs_name="", $method="", $action="", $target="", $form_name="") {
    return $this->get_start($jvs_name, $method, $action, $target, $form_name);
  }

  function get_finish($after="", $before="") {
    global $sess;
    $str = "";

    if ($this->hidden) {
      reset($this->hidden);
      while (list($k, $elname) = each($this->hidden)) {
        $str .= $this->get_element($elname);
      }
    }
    if (is_object($sess) && ($sess->mode == "get")) {
      $str .= sprintf("<input type=\"hidden\" name=\"%s\" value=\"%s\">\n", $sess->name, $sess->id);
    }
    $str .= "</form>";

    if ($this->jvs_name) {
      $jvs_name = $this->jvs_name;
      $str .= "<script language='javascript'>\n<!--\n";
      $str .= "function ${jvs_name}_Validator(f) {\n";

      if (strlen($before)) {
        $str .= "$before\n";
      }
      reset($this->elements);
      while (list($k, $elrec) = each($this->elements)) {
        $el = $elrec["ob"];
        $str .= $el->self_get_js($elrec["ndx_array"]);
      }
      if (strlen($after)) {
        $str .= "$after\n";
      }
      $str .= "}\n//-->\n</script>";
    }

    return $str;
  }

  function finish($after="", $before="") {
    return $this->get_finish($after, $before);
  }

  function add_element($el) {

    if (!is_array($el)) {
      return false;
    }

    $cv_tab = array("select multiple"=>"select", "image"=>"submit");
    if ($t = $cv_tab[$el["type"]]) {
      $t = ("of_" . $t);
    } else {
      $t = ("of_" . $el["type"]);
    }

    // translate names like $foo[int] to $foo{int} so that they can cause no
    // harm in $this->elements
    # Original match
    # if (preg_match("/(\w+)\[(d+)\]/i", $el[name], $regs)) {
    if (ereg("([a-zA-Z_]+)\[([0-9]+)\]", $el["name"], $regs)) {
       $el["name"] = sprintf("%s{%s}", $regs[1], $regs[2]);
       $el["multiple"] = true;
    }
    $el = new $t($el);
    $el->type = $t; # as suggested by Michael Graham (magog@the-wire.com)
    if ($el->isfile) {
      $this->isfile = true;
    }
    $this->elements[$el->name]["ob"] = $el;
    if ($el->hidden) {
      $this->hidden[] = $el->name;
    }
  }

  function get_element($name, $value=false) {
    $str = "";
    $x   = 0;
    $flag_nametranslation = false;

    // see add_element: translate $foo[int] to $foo{int}
#   Original pattern
#   if (preg_match("/(w+)\[(\d+)\]/i", $name, $regs) {
    if (ereg("([a-zA-Z_]+)\[([0-9]+)\]", $name, $regs)) {
       $org_name = $name;
       $name = sprintf("%s{%s}", $regs[1], $regs[2]);
       $flag_nametranslation = true;
    }

    if (!isset($this->elements[$name])) {
      return false;
    }

    if (!isset($this->elements[$name]["which"])) {
      $this->elements[$name]["which"] = 0;
    }

    $el = $this->elements[$name]["ob"];
    if (true == $flag_nametranslation) {
      $el->name = $org_name;
    }

    if (false == $value) {
       $value = $el->value;
    }

    if ($this->elements[$name]["frozen"]) {
      $str .= $el->self_get_frozen($value, $this->elements[$name]["which"]++, $x);
    } else {
      $str .= $el->self_get($value, $this->elements[$name]["which"]++, $x);
    }
    $this->elements[$name]["ndx_array"][] = $this->n;
    $this->n += $x;

    return $str;
  }

  function show_element($name, $value="") {
    print $this->get_element($name, $value);
  }

  function ge($name, $value="") {
    return $this->get_element($name, $value);
  }

  function se($name, $value="") {
    $this->show_element($name, $value);
  }

  function ae($el) {
    $this->add_element($el);
  }

  function validate($default=false, $vallist="") {
    if ($vallist) {
      reset($vallist);
      $elrec = $this->elements[current($vallist)];
    } else {
      reset($this->elements);
      $elrec = current($this->elements);
    }
    while ($elrec) {
      $el = $elrec["ob"];
      if ($res = $el->marshal_dispatch($this->method, "self_validate")) {
        return $res;
      }
      if ($vallist) {
        next($vallist);
        $elrec = $this->elements[current($vallist)];
      } else {
        next($this->elements);
        $elrec = current($this->elements);
      }
    }
    return $default;
  }

  function load_defaults($deflist="") {
    if ($deflist) {
      reset($deflist);
      $elrec = $this->elements[current($deflist)];
    } else {
      reset($this->elements);
      $elrec = current($this->elements);
    }
    while ($elrec) {
      $el = $elrec["ob"];
      $el->marshal_dispatch($this->method, "self_load_defaults");
      $this->elements[$el->name]["ob"] = $el;  // no refs -> must copy back
      if ($deflist) {
        next($deflist);
        $elrec = $this->elements[current($deflist)];
      } else {
        next($this->elements);
        $elrec = current($this->elements);
      }
    }
  }

  function freeze($flist="") {
    if ($flist) {
      reset($flist);
      $elrec = $this->elements[current($flist)];
    } else {
      reset($this->elements);
      $elrec = current($this->elements);
    }
    while ($elrec) {
      $el = $elrec["ob"];
      $this->elements[$el->name]["frozen"]=1;
      if ($flist) {
        next($flist);
        $elrec = $this->elements[current($flist)];
      } else {
        next($this->elements);
        $elrec = current($this->elements);
      }
    }
  }

} /* end FORM */

class of_checkbox extends of_element {

  var $checked;

  // Constructor
  function of_checkbox($a) {
    $this->setup_element($a);
  }

  function self_get($val, $which, &$count) {
    $str = "";

    if ($this->multiple) {
      $n = $this->name . "[]";
      $str .= "<input type='checkbox' name='$n' value='$val'";
      if (is_array($this->value)) {
        reset($this->value);
        while (list($k, $v) = each($this->value)) {
          if ($v==$val) {
            $str .= " checked";
            break;
          }
        }
      }
    } else {
      $str .= "<input type='checkbox' name='$this->name'";
      $str .= " value='$this->value'";
      if ($this->checked) {
        $str .= " checked";
      }
    }
    if ($this->extrahtml) {
      $str .= " $this->extrahtml";
    }
    $str .= ">\n";

    $count = 1;
    return $str;
  }

  function self_get_frozen($val, $which, &$count) {
    $str = "";

    $x = 0;
    $t="";
    if ($this->multiple) {
      $n = $this->name . "[]";
      if (is_array($this->value)) {
        reset($this->value);
        while (list($k, $v) = each($this->value)) {
          if ($v==$val) {
              $x = 1;
            $str .= "<input type='hidden' name='$this->name' value='$v'>\n";
            $t =" bgcolor=#333333";
            break;
          }
        }
      }
    } else {
      if ($this->checked) {
        $x = 1;
        $t = " bgcolor=#333333";
        $str .= "<input type='hidden' name='$this->name'";
        $str .= " value='$this->value'>";
      }
    }
    $str .= "<table$t border=1><tr><td>&nbsp</td></tr></table>\n";

    $count = $x;
    return $str;
  }

  function self_load_defaults($val) {
    if ($this->multiple) {
      $this->value = $val;
    } elseif (isset($val) && (!$this->value || $val==$this->value)) {
      $this->checked=1;
    } else {
      $this->checked=0;
    }
  }

} // end CHECKBOX

class of_radio extends of_element {

  var $valid_e;

  // Constructor
  function of_radio($a) {
    $this->setup_element($a);
  }

  function self_get($val, $which, &$count) {
    $str = "";

    $str .= "<input type='radio' name='$this->name' value='$val'";
    if ($this->extrahtml) {
      $str .= " $this->extrahtml";
    }
    if (isset($this->checked)) {
      $str .= " checked='checked'";
    }
    $str .= " />";

    $count = 1;
    return $str;
  }

  function self_get_frozen($val, $which, &$count) {
    $str = "";

    $x = 0;
    if ($this->value==$val) {
      $x = 1;
      $str .= "<input type='hidden' name='$this->name' value='$val'>\n";
      $str .= "<table border=1 bgcolor=#333333>";
    } else {
      $str .= "<table border=1>";
    }
    $str .= "<tr><td>&nbsp</tr></td></table>\n";

    $count = $x;
    return $str;
  }

  function self_get_js($ndx_array) {
    $str = "";

    if ($this->valid_e) {
      $n = $this->name;
      $str .= "var l = f.${n}.length;\n";
      $str .= "var radioOK = false;\n";
      $str .= "for (i=0; i<l; i++)\n";
      $str .= "  if (f.${n}[i].checked) {\n";
      $str .= "    radioOK = true;\n";
      $str .= "    break;\n";
      $str .= "  }\n";
      $str .= "if (!radioOK) {\n";
      $str .= "  alert(\"$this->valid_e\");\n";
      $str .= "  return(false);\n";
      $str .= "}\n";
    }
  }

  function self_validate($val) {
    if ($this->valid_e && !isset($val)) {
      return $this->valid_e;
    }
    return false;
  }

} // end RADIO

class of_select extends of_element {

  var $options;
  var $size;
  var $valid_e;

  // Constructor
  function of_select($a) {
    $this->setup_element($a);
    if ($a["type"]=="select multiple") {
      $this->multiple=1;
    }
  }

  function self_get($val, $which, &$count) {
    $str = "";

    if ($this->multiple) {
      $n = $this->name . "[]";
      $t = "select multiple";
    } else {
      $n = $this->name;
      $t = "select";
    }
    $str .= "<$t name='$n'";
    if ($this->size) {
      $str .= " size='$this->size'";
    }
    if ($this->extrahtml) {
      $str .= " $this->extrahtml";
    }
    $str .= ">";

    reset($this->options);
    while (list($k, $o) = each($this->options)) {
      $str .= "<option";
      if (is_array($o)) {
        $str .= " value='" .  $o["value"] . "'";
      }
      if (!$this->multiple && ($this->value==$o["value"] || $this->value==$o)) {
        $str .= " selected";
      } elseif ($this->multiple && is_array($this->value)) {
        reset($this->value);
        while (list($tk, $v) = each($this->value)) {
          if ($v==$o["value"] || $v==$o) {
            $str .= " selected"; break;
          }
        }
      }
      $str .= ">" . (is_array($o) ? $o["label"] : $o) . "</option>\n";
    }
    $str .= "</select>";

    $count = 1;
    return $str;
  }

  function self_get_frozen($val, $which, &$count) {
    $str = "";

    $x = 0;
    $n = $this->name . ($this->multiple ? "[]" : "");
    $v_array = (is_array($this->value) ? $this->value : array($this->value));
    $str .= "<table border=1>\n";
    reset($v_array);
    while (list($tk, $tv) = each($v_array)) {
      reset($this->options);
      while (list($k, $v) = each($this->options)) {
        if ((is_array($v) &&
           (($tmp=$v["value"])==$tv || $v["label"]==$tv))
         || ($tmp=$v)==$tv) {
          $x++;
          $str .= "<input type='hidden' name='$n' value='$tmp'>\n";
          $str .= "<tr><td>" . (is_array($v) ? $v["label"] : $v) . "</td></tr>\n";
        }
      }
    }
    $str .= "</table>\n";

    $count = $x;
    return $str;
  }

  function self_get_js($ndx_array) {
    $str = "";

    if (!$this->multiple && $this->valid_e) {
      $str .= "if (f.$this->name.selectedIndex == 0) {\n";
      $str .= "  alert(\"$this->valid_e\");\n";
      $str .= "  f.$this->name.focus();\n";
      $str .= "  return(false);\n";
      $str .= "}\n";
    }

    return $str;
  }

  function self_validate($val) {
    if (!$this->multiple && $this->valid_e) {
      reset($this->options);
      $o = current($this->options);
      if ($val==$o["value"] || $val==$o) {
        return $this->valid_e;
      }
    }
    return false;
  }

} // end SELECT

class of_text extends of_element {

  var $maxlength;
  var $minlength;
  var $length_e;
  var $valid_regex;
  var $valid_icase;
  var $valid_e;
  var $pass;
  var $size;

  // Constructor
  function of_text($a) {
    $this->setup_element($a);
    if ($a["type"]=="password") {
      $this->pass=1;
    }
  }

  function self_get($val, $which, &$count) {
    $str = "";

    if (is_array($this->value)) {
      $v = htmlspecialchars($this->value[$which]);
    } else {
      $v = htmlspecialchars($this->value);
    }
    $n = $this->name . ($this->multiple ? "[]" : "");
    $str .= "<input name='$n' value=\"$v\"";
    $str .= ($this->pass)? " type='password'" : " type='text'";
    if ($this->maxlength) {
      $str .= " maxlength='$this->maxlength'";
    }
    if ($this->size) {
      $str .= " size='$this->size'";
    }
    if ($this->extrahtml) {
      $str .= " $this->extrahtml";
    }
    $str .= "/>";

    $count = 1;
    return $str;
  }

  function self_get_frozen($val, $which, &$count) {
    $str = "";

    if (is_array($this->value)) {
      $v = $this->value[$which];
    } else {
      $v = $this->value;
    }
    $n = $this->name . ($this->multiple ? "[]" : "");
    $str .= "<input type='hidden' name='$n' value='$v'>\n";
    $str .= "<table border=1><tr><td>$v</td></tr></table>\n";

    $count = 1;
    return $str;
  }

  function self_get_js($ndx_array) {
    $str = "";

    reset($ndx_array);
    while (list($k, $n) = each($ndx_array)) {
      if ($this->length_e) {
        $str .= "if (f.elements[${n}].value.length < $this->minlength) {\n";
        $str .= "  alert(\"$this->length_e\");\n";
        $str .= "  f.elements[${n}].focus();\n";
        $str .= "  return(false);\n}\n";
      }
      if ($this->valid_e) {
        $flags = ($this->icase ? "gi" : "g");
        $str .= "if (window.RegExp) {\n";
        $str .= "  var reg = new RegExp(\"$this->valid_regex\", \"$flags\");\n";
        $str .= "  if (!reg.test(f.elements[${n}].value)) {\n";
        $str .= "    alert(\"$this->valid_e\");\n";
        $str .= "    f.elements[${n}].focus();\n";
        $str .= "    return(false);\n";
        $str .= "  }\n}\n";
      }
    }

    return $str;
  }

  function self_validate($val) {
    if (!is_array($val)) {
      $val = array($val);
    }
    reset($val);
    while (list($k, $v) = each($val)) {
      if ($this->length_e && (strlen($v) < $this->minlength)) {
        return $this->length_e;
      }
      if ($this->valid_e && (($this->icase &&
            !eregi($this->valid_regex, $v)) ||
           (!$this->icase &&
            !ereg($this->valid_regex, $v)))) {
        return $this->valid_e;
      }
    }
    return false;
  }

} // end TEXT
class of_textarea extends of_element {

  var $rows;
  var $cols;
  var $wrap;

  // Constructor
  function of_textarea($a) {
    $this->setup_element($a);
  }

  function self_get($val, $which, &$count) {
    $str  = "";
    $str .= "<textarea name='$this->name'";
    $str .= " rows='$this->rows' cols='$this->cols'";
    if ($this->wrap) {
      $str .= " wrap='$this->wrap'";
    }
    if ($this->extrahtml) {
      $str .= " $this->extrahtml";
    }
    $str .= ">" . htmlspecialchars($this->value) ."</textarea>";

    $count = 1;
    return $str;
  }

  function self_get_frozen($val, $which, &$count) {
    $str  = "";
    $str .= "<input type='hidden' name='$this->name'";
    $str .= " value=\"";
    $str .= htmlspecialchars($this->value);
    $str .= "\">\n";
    $str .= "<table border=1><tr><td>\n";
    $str .=  nl2br($this->value);
    $str .= "\n</td></tr></table>\n";

    $count = 1;
    return $str;
  }

} // end TEXTAREA


?>