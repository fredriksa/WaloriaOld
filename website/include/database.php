<?php
/*
    Simultaneous Core Registration
    coded by Faded - www.EmuDevs.com
*/
    include('config.php');

    $conn = mysqli_connect($mysql_host, $mysql_user, $mysql_pass);
    $mysqli = $conn;
    if (!$mysqli)
    {
        echo "Could not connect to server \n";
        trigger_error(mysqli_connect_error(), E_USER_ERROR);
    }