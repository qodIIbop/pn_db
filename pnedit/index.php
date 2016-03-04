<!-- pn_edit index.php -->

<?php
require 'consts.php';
require 'config.php';
require 'yselect.php';
require 'functions.php';
require 'ymysql.php';
require 'yform.php';
?>
<!DOCTYPE html PUBLIC 
    "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
>
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head> 
<link rel="stylesheet" type="text/css" href="pnedit.css">

<script type="text/javascript">

// disable ENTER key submit in text and number input
function stopRKey(evt) {
  var evt = (evt) ? evt : ((event) ? event : null);
  var node = 
      (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
  if ((evt.keyCode == 13) && ((node.type=="text") || (node.type=="number")))
        return false;
}
document.onkeypress = stopRKey;

// sets flag that controlls what is displayed in the the selection table
// item: name of the column of selected table
function y_set_select_table(item){
    document.y.<?php echo FLAG_SEL1; ?>.value = item;
    y.submit();
}

// signals partnumber change
function y_pn_up(pn_up){
    //document.y.pn_up.value = pn_up;
    document.y.<?php echo FLAG_PN_UPDATE; ?>.value = pn_up;
    // uncomment below line to hide selection table after select
    //document.y.sel1.value = "off";
    y.submit();
}

// example only!
// it is to show how to change any form value
function y_set(item,yv){
    document.y.elements[item].value = yv;
    y.submit();
}
</script>
</head> 
<body>
<title>DDr PN Editor</title> 
<h1> DDr Partnumber DB Editor</h1>

<?php
function _debug(){
    if(DEBUG){
        echo '<br>';
        printf("Debug: %s ",strftime('%T'));
        if(isset($_POST[TABLE])) $config[TABLE] = $_POST[TABLE];
        if(isset($_POST[GROUP])) $config[GROUP] = $_POST[GROUP];
        printf(" [%s,%s,%s]",
            $config[TABLE],
            $config[GROUP],
            $y_data[SQL_PN_PARTNUM]);
        printf(" {%s,%s,%s}",
            $_POST[MODE],
            $_POST[FLAG_PN_UPDATE],
            $_POST[FLAG_SEL1]);
        echo '<br>';
    }
}

print '<div class="version">'.VERSION.'</div>';

// init control variables
if($_POST[TABLE] == NULL){
    $_POST[MODE]=$config['def_mode'];
    $_POST[TABLE]=$config['def_table'];
    $_POST[FLAG_SEL1]='';
}

// connect to mysql server
($GLOBALS["___mysqli_ston"] = mysqli_connect($config['host'],  $config['user'],  $config['pass']));
((bool)mysqli_query($GLOBALS["___mysqli_ston"], "USE " . $config['database']));
// read tables list and their descriptions
ysql_tables($config['database'],$tables);

// delete some tables for now
unset($tables[TABLE_AVL]);
//unset($tables[TABLE_ECAD]);
unset($tables[TABLE_GROUP]);
unset($tables[TABLE_SOURCE]);

// read groups definition table for selected table
ysql_groups($_POST[TABLE],$groups);
// read columns and their field type for selected table
$columns = NULL;
ysql_columns($_POST[TABLE],$columns);

if($FLAG_SUBMIT_DATA){ 
    $_POST[FLAG_SUBMIT_DATA] = 1;
    $FLAG_SUBMIT_DATA = 0;
}
//_debug();
// create form and display it
print yform($tables,$groups,$columns,$y_data);
if(isset($FLAG_SUBMIT_DATA)) $_POST[FLAG_SUBMIT_DATA] = $FLAG_SUBMUT_DATA;
_debug();
$_POST[FLAG_SUBMIT_DATA] = 0;

if(isset($_POST['submit_sql'])){
    if($_POST[MODE] == MODE_NEW){
        if(ysql_insert($_POST[TABLE],$y_data)){
            $ymsg  = '<script type="text/javascript">alert("New PartNumber: ';
            $ymsg .= $y_data[SQL_PN_GROUP].'-';
            $ymsg .= $y_data[SQL_PN_PARTNUM].'-';
            $ymsg .= $y_data[SQL_PN_REV];
            $ymsg .= ' created successfully.");</script>';
            if(CONFIRM) 
                print $ymsg;
            $y_data[SQL_PN_PARTNUM] = 
                get_next_pn($_POST[TABLE],$_POST[GROUP]);
        }
        else yerror('New PartNumber ERROR');
    }        
    else{
        if(ysql_update($_POST[TABLE],$y_data)){;
            $ymsg  = '<script type="text/javascript">alert("PartNumber: ';
            $ymsg .= $y_data[SQL_PN_GROUP].'-';
            $ymsg .= $y_data[SQL_PN_PARTNUM].'-';
            $ymsg .= $y_data[SQL_PN_REV];
            $ymsg .= ' updated successfully.");</script>';
            if(CONFIRM) print $ymsg;
        }
    }
    ysubmit();
}
//_debug();
?>
</body></html>
