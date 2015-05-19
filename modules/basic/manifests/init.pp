
class basic::install {
    notice("Basic Environment Deployment")

    file {'/root/.bashrc':
        ensure  => present,
        content => template('basic/bashrc.erb'),
        owner   => "root",
        group   => "root",
        mode    => "0644",
    }
    
    file {'/root/.bash_profile':
        ensure  => present,
        content => template('basic/bash_profile.erb'),
        owner   => "root",
        group   => "root",
        mode    => "0644",
    }
    
    file {'/root/bin':
        ensure => directory,
    }
    
    file {'/root/workspace':
        ensure => directory,
    }
    
    file {'/root/bin/python3_install.sh':
        ensure => present,
        content => template('basic/python3_install.sh.erb'),
        owner   => "root",
        group   => "root",
        mode    => "0755",
        require => File['/root/bin'],
    }
    
    file {'/root/bin/scripts_install.sh':
        ensure => present,
        content => template('basic/scripts_install.sh.erb'),
        owner   => "root",
        group   => "root",
        mode    => "0755",
        require => File['/root/bin'],
    }
    
    package { 'git':
        ensure => installed,
    }
    
    package {'vsftpd':
        ensure => installed,
    }
    
    group { "ftpuser":
        ensure => present,
        gid    => 1000,
        require=> Package['vsftpd'],
    }
    
    #password is sha512 encrypt password
    user {'timmy':
        ensure     => present,
        gid        => "ftpuser",
        home       => "/home/timmy",
        shell      => "/sbin/nologin",
        password   => "$6$salt$IxDD3jeSOb5eB1CX5LBsqZFVkJdido3OUILO5Ifz5iwMuTS4XMS130MTSuDDl3aCI6WouIL9AjRbLCelDCy.g."
        require    => Group["ftpuser"],
    }
    
    file {'/home/timmy':
        ensure => directory,
        owner   => "timmy",
        group   => "ftpuser",
        mode    => "0755",
        require => User["timmy"],
    }
    
    service {'vsftpd':
        ensure => running,
        require => [Package['vsftpd'], User['timmy']],
    }
    
}
