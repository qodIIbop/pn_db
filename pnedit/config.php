<?php
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Mon, 26 Jul 1997 01:00:00 GMT");
header("Pragma: no-cache");

date_default_timezone_set("Europe/Budapest");
error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);

$config['host']     = "192.168.50.147";
$config['user']     = "test";
$config['pass']     = "Bjje,9314";
$config['database'] = "db_ddrpn";
$config['def_table']= "tb_1xx";
$config['def_mode'] = "new";
?>
