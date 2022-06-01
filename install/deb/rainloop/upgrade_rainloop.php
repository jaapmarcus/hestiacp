<?php
// Example usage 
// change_password.php "admin_account admin_password mysql_password"
$_ENV['SNAPPYMAIL_INCLUDE_AS_API'] = true;
include '/var/lib/rainloop/index.php';

use \RainLoop\Config\Config;
use \RainLoop\Config\Config\Application;

$oConfig = \RainLoop\Api::Config();
    
// Change default login data / key
$password = $oConfig->Get('security','admin_password');
$oConfig->SetPassword($password);
// Allow Contacts to be saved in database
// Plugins
#$oConfig->Set('plugins', 'enable', 'On');
$oConfig->Set('plugins', 'enabled_list', '');
$oConfig->Save();
?>