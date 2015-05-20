
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
    
    package { 'ftp':
        ensure => installed,
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
    
    #password is sha512 encrypt timmy1
    user {'timmy':
        ensure     => present,
        gid        => "ftpuser",
        home       => "/home/timmy",
        shell      => "/sbin/nologin",
        password   => '$6$whVQC7Ya$BD3bB/1hh1MuG8X7JJpV0uXEYqEL7DuSG4TWXE6SLLxxXgYFcrJYCi2AVQYgI.NSWOnUU3lmDRzFsWNDQPGE7/',
        require    => Group["ftpuser"],
    }
    
    file {'/home/timmy':
        ensure => directory,
        owner   => "timmy",
        group   => "ftpuser",
        mode    => "0755",
        require => User["timmy"],
    }
    
    # bind ipv4 nic not ipv6
    file {'/etc/vsftpd/vsftpd.conf':
        ensure => present,
        content => template('basic/vsftpd.conf.erb'),
        owner   => "root",
        group   => "root",
        mode    => "0644",
        require => Package['vsftpd'],
    }
    
    service {'vsftpd':
        ensure => running,
        require => [File['/etc/vsftpd/vsftpd.conf'], User['timmy']],
    }
    
    exec {'flush_iptables':
        command => 'iptables -F',
        path => ['/usr/sbin'],
        subscribe => Service['vsftpd'],
    }
    
}
