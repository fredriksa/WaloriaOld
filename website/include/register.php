<?php
/*
    Simultaneous Core Registration
    coded by Faded - www.EmuDevs.com
*/
include('database.php');

// From: https://www.azerothcore.org/wiki/account
function CalculateSRP6Verifier($username, $password, $salt)
{
    // algorithm constants
    $g = gmp_init(7);
    $N = gmp_init('894B645E89E1535BBDAD5B8B290650530801B18EBFBF5E8FAB3C82872A3E9BB7', 16);
    
    // calculate first hash
    $h1 = sha1(strtoupper($username . ':' . $password), TRUE);
    
    // calculate second hash
    $h2 = sha1($salt.$h1, TRUE);
    
    // convert to integer (little-endian)
    $h2 = gmp_import($h2, 1, GMP_LSW_FIRST);
    
    // g^h2 mod N
    $verifier = gmp_powm($g, $h2, $N);
    
    // convert back to a byte array (little-endian)
    $verifier = gmp_export($verifier, 1, GMP_LSW_FIRST);
    
    // pad to 32 bytes, remember that zeros go on the end in little-endian!
    $verifier = str_pad($verifier, 32, chr(0), STR_PAD_RIGHT);
    
    // done!
    return $verifier;
}

function GetSRP6RegistrationData($username, $password)
{
    // generate a random salt
    $salt = random_bytes(32);
    
    // calculate verifier using this salt
    $verifier = CalculateSRP6Verifier($username, $password, $salt);
    
    // done - this is what you put in the account table!
    return array($salt, $verifier);
}

$player = $_POST['player'];
$password = $_POST['password'];
$email  = $_POST['email'];

switch ($_POST['expansion'])
{
    case "Wrath of the Lich King":
        $tc_expansion = 2;
        $arc_expansion = 24;
        break;
}

list($salt, $verifier) = GetSRP6RegistrationData($player, $password);

$result = $mysqli->select_db($db_tc);

if (!$result)
{
    echo "Selection Failed";
    trigger_error(mysqli_connect_errno(), E_USER_ERROR);
}

$tc_template = "INSERT INTO `" . $table_tc ."` (`username`, `salt`, `verifier`, `email`, `expansion`) VALUES ('" .
$player . "','" . $salt . "','" . $verifier . "','" . $email . "'," . $tc_expansion. ")";

echo "\n" . $tc_template . "\n";

$player_query = "SELECT * FROM `" . $table_tc . "` WHERE username='" . $player ."'";
$playerResult = $mysqli->query($player_query);

if (!$playerResult)
{
    echo "Failed to execute!";
    trigger_error(mysqli_connect_errno(), E_USER_ERROR);
}

$row = mysqli_num_rows($playerResult);

if ($row != 1)
{
    $tc_result = $mysqli->query($tc_template);
    if (!$tc_result)
    {
        echo "Failed to execute!";
        trigger_error(mysqli_connect_errno(), E_USER_ERROR);
    }
    else
    {
        echo "Account '" . $player . "' created.";
    }
}
else
{
    echo "Account '" . $player . "' already exists.";
}

$mysqli->close();