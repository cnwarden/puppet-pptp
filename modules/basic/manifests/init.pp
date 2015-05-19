
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
    
    file {'/home/timmy':
        ensure => directory,
        owner   => "timmy",
        group   => "ftpuser",
        mode    => "0755",
    }
    
    user {'timmy':
        ensure     => present,
        gid        => "ftpuser",
        home       => "/home/timmy",
        shell      => "/sbin/nologin",
        password   => sha1('timmy1'),
        require    => [File['/home/timmy'], Group["ftpuser"]],
    }
    
    service {'vsftpd':
        ensure => running,
        require => [Package['vsftpd'], User['timmy']],
    }
    
}
