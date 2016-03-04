<?php
function get_next_pn($t,$g){
    if($t == NULL || $g == NULL) return "error";
    $sql_next_pn = "SELECT MAX(pn) FROM ".$t." WHERE grp='".$g."'";
    $res_next_pn = mysqli_query($GLOBALS["___mysqli_ston"], $sql_next_pn) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
    return sprintf("%05s",mysqli_fetch_array($res_next_pn, MYSQLI_NUM)[0]+1);
}

function get_next_id($t){
    if($t == NULL ) return "error";
    $sql_next_id = "SELECT MAX(id) FROM ".$t;
    $res_next_id = mysqli_query($GLOBALS["___mysqli_ston"], $sql_next_id) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
    return sprintf("%s",mysqli_fetch_array($res_next_id, MYSQLI_NUM)[0]+1);
}

function yerror($msg){
    $ymsg  = '<script type="text/javascript">alert("';
    $ymsg .= $msg;
    $ymsg .= '");</script>';
    print $ymsg;
}

function ysubmit(){
    $ymsg  = '<script type="text/javascript">y.submit();</script>';
    print $ymsg;
}
    
?>
