<?php
// display selection form with filter for each column
// inputs:
//  menu: form string to append selection form to
//  table: table to show
//  item: column name to use as a key
//  id: key in the table
//  prefilt: only show fields after this filter applied
//  update_pn: flag to enable/disable partnumber update

function y_select(&$menu,$table,$item,$id,$preflt,$update_pn){

    $menu .= '<tr><td colspan="100"><div class="form1">';
    $menu .= '<table border="0" bgcolor="'.BGCOLOR.'" cellpadding="3">';
    ysql_columns($table,$cols);
    $i = 0;
    $menu .= '<tr><th colspan="100" align="left">'.strtoupper($item);
    $menu .= ' Selector</th></tr>';
    $menu .= '<tr><th>Filter</th>';
    foreach($cols['name'] as $c){
        $menu .= '<th>'.strtoupper($c).'</th>';
        if($c == $id) $yvp = $i;
        $i++;
    }
    $menu .= '</tr>';
    $first=0;
    $menu .= '<tr><td><input type="submit" value="Set"></td>';
    $menu .= '<td><input type="submit" name="clear" value="Clear"></td>';
    foreach($cols['name'] as $c){
        if(isset($_POST['clear'])) $filter[$c]=$_POST['f_'.$c] = NULL;
        if(!$first++) continue; 
        $menu .= '<td align="center">';
        $menu .= '<input type="text" class="center" size="6"';
        $menu .= ' name="'.'f_'.$c.'"';
        $menu .= 'value="'.$_POST['f_'.$c].'"></td>';
        if(isset($_POST['f_'.$c])) $filter[$c]=$_POST['f_'.$c];
        if(DEB_SQL){ print $c; echo ';'; }
    }
    $menu .= '</tr>';
    $sql_filter = "";
    foreach($filter as $f => $s){
        if($sql_filter == ""){
            if($s != "") $sql_filter = $f.' like "%'.$s.'%"';
        }
        else{
            if($s != "") $sql_filter .= ' AND '.$f.' like "%'.$s.'%"';
        }
    }
    if($sql_filter != "" && $preflt != "" ){
        $sql_filter = 'WHERE '.$preflt.' AND '.$sql_filter;
    }
    else{
        if($sql_filter != "" ) $sql_filter = 'WHERE '.$sql_filter;
        if($preflt != "" ) $sql_filter = 'WHERE '.$preflt;
    }
    $sql  = 'SELECT * FROM '.$table.' '.$sql_filter;
    $sql_filter = "";
    if(DEB_SQL){ print htmlspecialchars(var_dump($sql)); echo '<br>'; }
    $res = mysqli_query($GLOBALS["___mysqli_ston"], $sql) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
    $odd = 0;
    while($data = mysqli_fetch_array($res, MYSQLI_NUM)){
        if($odd){
            $menu .= '<tr bgcolor="'.BGCOLOR1.'">';
            $odd = 0;
        }
        else{
            $menu .= '<tr bgcolor="'.BGCOLOR2.'">';
            $odd = 1;
        }
        $menu .= '<td align="center">';
        $menu .= '<input type="radio" name="'.$item.'" value="'.$data[$yvp].'" ';
        $menu .= 'onchange="y_pn_up(\''.$update_pn.'\');"';
        if($_POST[$item] == $data[$yvp]) $menu .= ' checked="checked"';
        $menu .= '></td>';
        foreach($data as $l){
            $menu .= '<td align="center">'.$l.'</td>';
        }
        $menu .= '</tr>';
    }
    $menu .= '</table></div></td></tr>';
}

?>
