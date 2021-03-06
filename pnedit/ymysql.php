<?php

function ysql_insert($table,$data){
    $cols = $vals = "";
    foreach($data as $c => $v){
        if($data[$c] != ""){
            $cols .= $c.',';
            $vals .= '"'.$data[$c].'",';
        }
    }
    $cols = substr($cols,0,-1);
    $vals = substr($vals,0,-1);
    $sql = 'INSERT INTO '.$table.'('.$cols.') ';
    $sql .= 'VALUE('.$vals.')';
    if(DEB_SQL_INSERT) var_dump($sql);
    $res = mysqli_query($GLOBALS["___mysqli_ston"], $sql) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
    return 1;
        //$res;
}

function ysql_get_pn($table,$filt){
    $sql = 'SELECT * FROM '.$table;
    if($filt != "") $sql .= ' WHERE '.$filt;
    $res = mysqli_query($GLOBALS["___mysqli_ston"], $sql) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
    return mysqli_fetch_array($res, MYSQLI_ASSOC);
}

function ysql_update($table,$data){
    var_dump($data);
    if(!isset($data['pn']) || ($data['grp'] == "") || ($data['rev'] == "")){
        yerror("Missing full PartNumber ["
            .$data['grp'].'-'.$data['pn'].'-'.$data['rev'].']');
        return false;
    }
    foreach($data as $c => $v) $set .= $c.'="'.$v.'",';
    $set= substr($set,0,-1);
    $sql = 'UPDATE '.$table.' SET '.$set.' ';
    $sql .= ' WHERE grp="'.$data['grp'].'" AND pn="'.$data['pn'];
    $sql .= '" AND rev="'.$data['rev'].'"';
    //var_dump($sql);
    $res = mysqli_query($GLOBALS["___mysqli_ston"], $sql) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
    return $res;
}

// sets mysql column type and its size
function y_type(&$arr,$pos,$str){
    $s = substr($str,strpos($str,'(')+1);
    $arr['size'][$pos] = str_replace("'",'',substr($s,0,strpos($s,')')));
    $arr['type'][$pos] = substr($str,0,strpos($str,'('));
}

function ysql_columns($table,&$columns){
    $sql = "SHOW COLUMNS FROM ".$table;
    $res = mysqli_query($GLOBALS["___mysqli_ston"], $sql) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
    while ($res1 = mysqli_fetch_array($res, MYSQLI_NUM)){
     //var_dump($res1); echo '<br>';
     $columns['name'][] = $res1[0];
     $columns['type'][] = $res1[1];
     //var_dump($res[1]); echo '<br>';
    }
    //var_dump($columns);
}

function ysql_groups($table,&$groups){
    $sql = "SELECT id,descrip FROM tb_group WHERE tname = '".$table."'";
    $res = mysqli_query($GLOBALS["___mysqli_ston"], $sql) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
    while ($row = mysqli_fetch_array($res, MYSQLI_NUM)){
        $groups[$row[0]] = '['.$row[0].']'.' '.ucwords($row[1]);
    }
}

// get table list and their descriptions
function ysql_tables($database,&$tables){
    $sql  = "SHOW FULL TABLES FROM ";
    $sql .= "`".$database."` WHERE Table_type = 'BASE TABLE'";
    $res = mysqli_query($GLOBALS["___mysqli_ston"], $sql) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
    while ($row = mysqli_fetch_array($res, MYSQLI_NUM)){
        $sql  = "SELECT table_comment FROM information_schema.tables";
        $sql .= " WHERE table_name = '".$row[0]."'";
        $res2 = mysqli_query($GLOBALS["___mysqli_ston"], $sql) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
        $tables[$row[0]] = 
            ucwords(mysqli_fetch_array($res2, MYSQLI_ASSOC)['table_comment']);
    }

}

?>
