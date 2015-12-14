<?php
require_once '/srv/cloudmai/PasswordHash.php';
require_once '/srv/cloudmai/config.php';

$file_path = $argv[0];
$method = $argv[1];
$password = $argv[2];

function getHasher() {
    $hasher=null;
    if(!$hasher) {
            //we don't want to use DES based crypt(), since it doesn't return a has with a recognisable prefix
         $forcePortable=(CRYPT_BLOWFISH!=1);
         $hasher=new PasswordHash(8, $forcePortable);
    }        
     return $hasher;
}

function passwordtohash( $password ) {
    $hasher=getHasher();
    $hasher = $hasher->HashPassword($password.OC_Config::getValue('passwordsalt', ''));
    print $hasher;
}

if (!empty($method)){
    $method($password);
}

?>
