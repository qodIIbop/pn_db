<!-- pn_view index.php -->

<?php 
error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING); 
$config['host']     = "192.168.50.147"; 
$config['user']     = "test"; 
$config['pass']     = "Bjje,9314"; 
$config['database'] = "db_ddrpn"; 
if(!isset($config['table'])){  $config['table'] = "allpn";} 
if(!isset($_table)){  $_table = $config['table'];} 

($GLOBALS["___mysqli_ston"] = mysqli_connect($config['host'],  $config['user'],  $config['pass'])); 
$sql_tables = "SHOW TABLES FROM `".$config['database']."` "; 
$_result = mysqli_query($GLOBALS["___mysqli_ston"], $sql_tables) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))); 
$menu = '<select name="_table" onchange="this.form.submit()">'; 
//$menu .= '<option value="'.$_POST['_table'].'"selected="selected">'; 
//$menu .= $_POST['_table'].'</option>'; 

while ($row = mysqli_fetch_array($_result, MYSQLI_NUM)){ 
    $menu .= '<option'; 
    if($_POST['_table'] == $row[0]) $menu .= ' selected="selected" '; 
    $menu .= '>'.$row[0].'</option>'; 
} 
$menu .= '</select>'; 
?> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 

<html xmlns="http://www.w3.org/1999/xhtml">  
<head>  
    <link rel="stylesheet" type="text/css" href="reset.css" /> 
    <link rel="stylesheet" type="text/css" href="typography.css" /> 
    <link rel="stylesheet" type="text/css" href="style.css" /> 
    <div class="version">V0.3</div> 
    <title>DDr PN Viewer</title>  
    <h2> DDr Partnumber DB viewer </h2><br> 
</head>  
<body> 
<form method="post" action=""> 
    Select Table: <?php printf("%s",$menu);?>  
    &nbsp; &nbsp; 
    <noscript><input type="submit" value="Update"></noscript> 
</form> 
<?php 

if(isset($_POST['_table']))     { $config['table']      = $_POST['_table'];} 
if(isset($_POST['user']))       { $config['user']       = $_POST["_user"];} 
if(isset($_POST['passwd']))     { $config['pass']       = $_POST["_passwd"];} 

//DATABASE SETTINGS 
$config['nicefields'] = true; // "Field Name" or "field_name" 
$config['perpage'] = 10000; 
$config['showpagenumbers'] = false;  
$config['showprevnext'] = true; 

/******************************************/ 
//SHOULDN'T HAVE TO TOUCH ANYTHING BELOW... 
//except maybe the html echos for pagination and arrow image file near end of file. 

include './Pagination.php'; 
$Pagination = new Pagination(); 

//CONNECT 
($GLOBALS["___mysqli_ston"] = mysqli_connect($config['host'],  $config['user'],  $config['pass'])); 
((bool)mysqli_query($GLOBALS["___mysqli_ston"], "USE " . $config['database'])); 

//get total rows 
$totalrows = mysqli_fetch_array(mysqli_query($GLOBALS["___mysqli_ston"], "SELECT count(*) as total FROM `".$config['table']."`")); 

//limit per page, what is current page, define first record for page 
$limit = $config['perpage']; 
if(isset($_POST['page']) && is_numeric(trim($_POST['page']))){$page = ((isset($GLOBALS["___mysqli_ston"]) && is_object($GLOBALS["___mysqli_ston"])) ? mysqli_real_escape_string($GLOBALS["___mysqli_ston"], $_POST['page']) : ((trigger_error("[MySQLConverterToo] Fix the mysql_escape_string() call! This code does not work.", E_USER_ERROR)) ? "" : ""));}else{$page = 1;} 
$startrow = $Pagination->getStartRow($page,$limit); 

//create page links 
if($config['showpagenumbers'] == true){ 
    $pagination_links = $Pagination->showPageNumbers($totalrows['total'],$page,$limit); 
}else{$pagination_links=null;} 

if($config['showprevnext'] == true){ 
    $prev_link = $Pagination->showPrev($totalrows['total'],$page,$limit); 
    $next_link = $Pagination->showNext($totalrows['total'],$page,$limit); 
}else{$prev_link=null;$next_link=null;} 

//IF ORDERBY NOT SET, SET DEFAULT 
if(!isset($_POST['orderby']) OR trim($_POST['orderby']) == ""){ 
    //GET FIRST FIELD IN TABLE TO BE DEFAULT SORT 
    $sql = "SELECT * FROM `".$config['table']."` LIMIT 1"; 
    $result = mysqli_query($GLOBALS["___mysqli_ston"], $sql) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))); 
    $array = mysqli_fetch_assoc($result); 
    //first field 
    if($array == NULL){echo "No data in this table"; return;} 
    $i = 0; 
    foreach($array as $key=>$value){ 
        if($i > 0){break;}else{ 
        $orderby=$key;} 
        $i++;         
    } 
    //default sort 
    $sort="ASC"; 
}else{ 
    $orderby=((isset($GLOBALS["___mysqli_ston"]) && is_object($GLOBALS["___mysqli_ston"])) ? mysqli_real_escape_string($GLOBALS["___mysqli_ston"], $_POST['orderby']) : ((trigger_error("[MySQLConverterToo] Fix the mysql_escape_string() call! This code does not work.", E_USER_ERROR)) ? "" : "")); 
}     

//IF SORT NOT SET OR VALID, SET DEFAULT 
if(!isset($_POST['sort']) OR ($_POST['sort'] != "ASC" AND $_POST['sort'] != "DESC")){ 
    //default sort 
        $sort="ASC"; 
    }else{     
        $sort=((isset($GLOBALS["___mysqli_ston"]) && is_object($GLOBALS["___mysqli_ston"])) ? mysqli_real_escape_string($GLOBALS["___mysqli_ston"], $_POST['sort']) : ((trigger_error("[MySQLConverterToo] Fix the mysql_escape_string() call! This code does not work.", E_USER_ERROR)) ? "" : "")); 
} 

//GET DATA 
$sql = "SELECT * FROM `".$config['table']."` ORDER BY $orderby $sort LIMIT $startrow,$limit"; 
$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql) or die(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))); 

//START TABLE AND TABLE HEADER 
echo "<table>\n<tr>"; 
$array = mysqli_fetch_assoc($result); 
foreach ($array as $key=>$value) { 
    $field = $key; 
    if($config['nicefields']){ 
        $field = str_replace("_"," ",$key); 
        $field = ucwords($field); 
    } 
     
    $field = columnSortArrows($key,$field,$orderby,$sort); 
    echo "<th>" . $field . "</th>\n"; 
} 
echo "</tr>\n"; 

//reset result pointer 
mysqli_data_seek($result, 0); 

//start first row style 
$tr_class = "class='odd'"; 

//LOOP TABLE ROWS 
while($row = mysqli_fetch_assoc($result)){ 

    echo "<tr ".$tr_class.">\n"; 
    foreach ($row as $field=>$value) {     
        echo "<td>" . $value . "</td>\n"; 
    } 
    echo "</tr>\n"; 
     
    //switch row style 
    if($tr_class == "class='odd'"){ 
        $tr_class = "class='even'"; 
    }else{ 
        $tr_class = "class='odd'"; 
    } 
     
} 

//END TABLE 
echo "</table>\n"; 

if(!($prev_link==null && $next_link==null && $pagination_links==null)){ 
echo '<div class="pagination">'."\n"; 
echo $prev_link; 
echo $pagination_links; 
echo $next_link; 
echo '<div style="clear:both;"></div>'."\n"; 
echo "</div>\n"; 
} 

/*FUNCTIONS*/ 

function columnSortArrows($field,$text,$currentfield=null,$currentsort=null){     
    //defaults all field links to SORT ASC 
    //if field link is current ORDERBY then make arrow and opposite current SORT 
     
    $sortquery = "sort=ASC"; 
    $orderquery = "orderby=".$field; 
     
    if($currentsort == "ASC"){ 
        $sortquery = "sort=DESC"; 
        $sortarrow = '<img src="arrow_up.png" />'; 
    } 
     
    if($currentsort == "DESC"){ 
        $sortquery = "sort=ASC"; 
        $sortarrow = '<img src="arrow_down.png" />'; 
    } 
     
    if($currentfield == $field){ 
        $orderquery = "orderby=".$field; 
    }else{     
        $sortarrow = null; 
    } 
     
    //return '<a href="?'.$orderquery.'&'.$sortquery.'">'.$text.'</a> '. $sortarrow;     
    return $text;     
     
} 

?> 
</body> 
</html> 
