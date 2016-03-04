<?php
// This form is the main input that updates automatically based on selection
//
// Main variables:
// $_POST[TABLE] - hold the value of currenly selected table
// $_POST[GROUP] - holds the value of currently selected group
//
// Inputs:
//  tables: list of selectable database tables
//  groups: list of groups in currently selected table
//  columns: list of columns in currently selected table
//
// Output: a table with a form inside that can be direcly sent to client
//

function yform($tables,$groups,$columns,&$y_data){
    $menu  = '<div class="form">';
    $menu .= '<table border="0"><tbody>';
    $menu .= '<tr><td height="50" valign="top">';
    $menu .= '<form method="post" name="y" id="y" autocomplete="on">';
    // define flag that hold table name to be shown in select table
    $menu .= '<input type="hidden" name="'.FLAG_SEL1.'"';
    $menu .= ' value="'.$_POST[FLAG_SEL1].'"><br>';
    // define flag that signals partnumber update
    $menu .= '<input type="hidden" size="1" name="'.FLAG_PN_UPDATE.'"';
    $menu .= ' value="'.$_POST[FLAG_PN_UPDATE].'"><br>';
    // mode selection new/mod for now
    $menu .= '<input type="radio" name="'.MODE.'" value="'.MODE_NEW.'"';
    $menu .= ' onchange="y_set_select_table(\''.SQL_ECAD_ID.'\');" ';
    if($_POST[MODE] == MODE_NEW) $menu .= 'checked="checked" ';
    $menu .= '>Create New PartNumber<br>';
    $menu .= '<input type="radio" name="'.MODE.'" value="'.MODE_MOD.'"';
    if($_POST[TABLE] == TABLE_ECAD)
        $menu .= ' onchange="y_set_select_table(\''.SQL_ECAD_ID.'\');" ';
    else
        $menu .= ' onchange="y_set_select_table(\''.SQL_PN_PARTNUM.'\');" ';
    if($_POST[MODE] == MODE_MOD) $menu .= 'checked="checked" ';
    $menu .= '>Modify PartNumber';
    $menu .= '</td></tr>';
    $menu .= '<tr height="10"></tr><tr>';
    $menu .= '<td height="50" valign="top">';
    $menu .= 'Table: <select name="'.TABLE.'" onchange="y_pn_up(\'1\')">';

    foreach($tables as $name => $comm){
        $menu .= '<option value="'.$name.'"';
        if($_POST[TABLE] == $name) $menu .= ' selected="selected" ';
        $menu .= '>'.$comm.'</option>';
    }
    $menu .= '</select>';

    if($groups != NULL){
        $menu .= '&nbsp;&nbsp;';
        $menu .= 'Group: <select name="'.GROUP.'" onchange="y_pn_up(\'1\');">';
        if(!array_key_exists($_POST['group'],$groups)){
            $_POST[GROUP] = key($groups);
            $group_str = $groups[key($groups)];
        }
        else $group_str = $groups[$_POST[GRUOP]];
        foreach($groups as $name => $desc){
            $menu .= '<option value="'.$name.'"';
            if($_POST[GROUP] == $name) $menu .= ' selected="selected" ';
            $menu .= '>'.$desc.'</option>';
        }
        $menu .= '</select>';
        $menu .= '<noscript><input type="submit" value="Submit"></noscript>';
        $menu .= '</td>';
    }
    $menu .= '</tr>';
    // var_dump($columns); echo '<br>';
    $menu .= '<tr><td><table><tr bgcolor="'.BGCOLOR.'">';
    foreach($columns['name'] as $column => $name){
        $menu .= '<th>'.strtoupper($name).'</th>';
    }
    $menu .= '</tr><tbody><tr>';

    foreach($columns['name'] as $column => $name){
        $menu .= '<td align="center">';
        y_type($columns,$column,$columns['type'][$column]);
        switch ($name){
        case SQL_ID:
            if($_POST[MODE] == MODE_NEW){
                $_POST[SQL_ID] = get_next_id($_POST[TABLE]);
                $menu .= $_POST[SQL_ID];
            }
            else{
                $menu .= 'TBI';
            }
            break;
        case SQL_PN_GROUP:
            $menu .= $y_data[$name] = $_POST[GROUP];
            break;
        case SQL_PN_PARTNUM:
            if($_POST[MODE] == MODE_NEW){
                $_POST[SQL_PN_PARTNUM] = get_next_pn($_POST[TABLE],$_POST[GROUP]);
                $menu .= $_POST[SQL_PN_PARTNUM];
            }
            else{
                if($_POST[FLAG_PN_UPDATE] == 1){
                    $_POST[FLAG_PN_UPDATE] = 0;
                    $x = ysql_get_pn($_POST[TABLE],'
                        '.SQL_PN_GROUP.'="'.$_POST[GROUP].'" AND 
                        '.SQL_PN_PARTNUM.'="'.$_POST[SQL_PN_PARTNUM].'" AND 
                        '.SQL_PN_REV.'="'.$_POST[SQL_PN_REV].'"');
                    foreach($x as $c => $v) $_POST[$c] = $v;
                }
                $menu .= '<input type="text" class="center" ';
                $menu .= ' size="3" ';
                $menu .= ' onfocus="y_set_select_table(\''.SQL_PN_PARTNUM.'\');"';
                $menu .= ' placeholder="'.SQL_PN_PARTNUM.'" readonly ';
                $menu .= ' name="'.SQL_PN_PARTNUM.'" ';
                $menu .= ' value="'.$_POST[SQL_PN_PARTNUM].'">';
            }
            break;
        case SQL_PN_REV:
            if($_POST[MODE] == MODE_NEW){ 
                $menu .= '00';
                $_POST[MODE_REV] = "00";
            }
            else{
                if($_POST[MODE_REV] == "") $_POST[MODE_REV] = "00";
                $menu .= '<input type="text"class="center" ';
                $menu .= ' placeholder="'.SQL_PN_REV;
                $menu .= '" onchange="this.form.submit();" ';
                $menu .= ' name="'.SQL_PN_REV.'" size="1"';
                $menu .= ' value="'.$_POST[SQL_PN_REV].'">';
            }
            break;
        case SQL_ECAD_SYM:
        case SQL_ECAD_FOOTPRINT:
        case SQL_ECAD_3DMODEL:
            $attr[$name] = 'size="15"';
        case SQL_ECAD_PKGTYPE: 
            if($name == SQL_ECAD_PKGTYPE) $attr[$name] = 'size="4"';
        case SQL_ECAD_ID:
            if($name == SQL_ECAD_ID){
                $attr[$name]  = ' size="2" readonly ';
                $attr[$name] .= ' onfocus="y_set_select_table(\'';
                $attr[$name] .= SQL_ECAD_ID.'\');"';
            }
        case SQL_PN_STATUS: if($name == "stat") $attr[$name] = 'size="4"';
        case SQL_PN_VALUE: if($name == "value") $attr[$name] = 'size="5"';
        case SQL_PN_PARAM: if($name == "param") $attr[$name] = 'size="5"';
        case SQL_PN_ROHS: if($name == "rohs") $attr[$name] = 'size="2"';
        case SQL_PN_DESC: if($name == "descrip") $attr[$name] = 'size="20"';
        case SQL_PN_DATASHEET: 
            if($name == "datasheet") $attr[$name] = 'size="15"';
        default:
            if($columns['type'][$column] == "set"){
                $menu .= '<select name="'.$name.'" >';
                $s = explode(',',$columns['size'][$column]);
                foreach($s as $l){
                    $menu .= '<option value="'.$l.'" ';
                    if($_POST[$name] == $l) $menu .= ' selected="selected"';
                    $menu .= '>'.$l.'</option>';
                }
                $menu .= '</select>';
            }
            else{
            $menu .= '<input type="text" class="center" ';
            $menu .= $attr[$name];
            $menu .= ' placeholder="'.$name.'" ';
            $menu .= ' name="'.$name.'" value="'.$_POST[$name].'">';
            }
        }
        if(isset($_POST[$name])){
            $y_data[$name] = $_POST[$name];
            //var_dump($y_data); echo '<br>';
        }
        $menu .= '</td>';
    }
    $menu .= '</select></td></tr>';
    $menu .= '<tr><td colspan="100" height="50" valign="bottom">';
    $menu .= '<input type="submit" name="submit_sql" value="Submit" ';
    if(CONFIRM) $menu .= 'onclick="return confirm(\'Update database?\');"';
    $menu .= '>';
    $menu .= '<input type="reset"></td></tr>';
    if($_POST[MODE] == MODE_NEW || $_POST[FLAG_SEL1] == SQL_ECAD_ID) 
        y_select($menu,TABLE_ECAD,SQL_ECAD_ID,SQL_ID,'',0);
    if($_POST[FLAG_SEL1] == SQL_PN_PARTNUM) 
        y_select($menu,$_POST[TABLE],SQL_PN_PARTNUM,SQL_PN_PARTNUM,
            SQL_PN_GROUP.'="'.$_POST[GROUP].'"',1);
    $menu .= '</td></tr></table></form></div>';
    return $menu;
}
?>
