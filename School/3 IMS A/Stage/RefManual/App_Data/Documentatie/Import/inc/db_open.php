<?php
/* Specify the server and connection string attributes. */
$serverName = "WINSVR01\SQLEXPRESS";

/* Connect using Windows Authentication. */
//$connectionInfo = array( "Database"=>"Reference_manual" );

/* Connect using SQL Server Authentication. */
$connectionInfo = array( "UID"=>"appligen",
                         "PWD"=>"appligen!",
                         "Database"=>"Reference_Manual");

$conn = sqlsrv_connect( $serverName, $connectionInfo);

if( $conn === false )
{
     echo "Unable to connect.</br>";
     die( print_r( sqlsrv_errors(), true));
}

?>