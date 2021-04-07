<?php

namespace Hestia\WebApp\Installers\Grav;

use \Hestia\WebApp\Installers\BaseSetup as BaseSetup;

class GravSetup extends BaseSetup {

    protected $appInfo = [ 
        'name' => 'Grav',
        'group' => 'cms',
        'enabled' => true,
        'version' => '1.7.10',
        'thumbnail' => 'grav-thumb.png'
    ];
    
    protected $appname = 'GravCMS';
    
    protected $config = [
        'form' => [
            'username' => ['text'=>'admin'],
            'password' => 'password',
            'email' => 'text'
            ],
        'database' => false,
        'resources' => [
           'archive'  => [ 'src' => 'https://github.com/getgrav/grav/releases/download/1.7.10/grav-admin-v1.7.10.zip' ]
        ],
    ];
    
    public function install(array $options = null) : bool
    {
        parent::install($options);
        $this->appcontext->runUser('v-copy-fs-directory',[
            $this->getDocRoot("grav-admin/."),
            $this->getDocRoot()], $result);
        $this->appcontext->runUser('v-delete-fs-directory',[ $this->getDocRoot("grav-admin")], $result);
        $this->appcontext->runUser('v-copy-fs-file',[$this->getDocRoot(".htaccess.txt"), $this->getDocRoot(".htaccess")]);
        
        chdir($this->getDocRoot());
        $this -> appcontext -> runUser('v-run-cli-cmd', ['php', 
            $this->getDocRoot('/bin/plugin'),
            'login new-user',
            '-u '.$options['username'],
            '-p '.$options['password'],
            '-e '.$options['email'],
            '-P a',
            '-N '.$options['username']
         ], $status);
        return ($status->code === 0);
    }
}
