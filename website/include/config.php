<?php
/*
    Simultaneous Core Registration
    coded by Faded - www.EmuDevs.com
*/
    $server_title = "Waloria Temporary Registration";
    $slogan = ""; /*Optional*/

    $mysql_host = "127.0.0.1";
    $mysql_user = "root";
    $mysql_pass = "ascent";

    /* Core Selection - false=disabled true=enabled
       simultaneous core registration supported. */

    $core_tc = true; //TrinityCore on/off
    $table_tc = "account"; //Account Table for TC
    $db_tc = "auth"; //Auth Database for TC

    $core_arc = false; //ArcEmu on/off
    $table_arc = "accounts"; //Account Table for ArcEmu
    $db_arc = "logon"; //Logon Database for ArcEmu

    $core_mang = false; //MaNGOS on/off
    $table_mang = "account"; //Account Table for MaNGOS
    $db_mang = "realmdb"; //Realms Database for MaNGOS