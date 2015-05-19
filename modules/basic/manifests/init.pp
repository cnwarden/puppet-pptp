
class basic::install {
    notice("Basic Environment Deployment")
    
    package { 'git':
        ensure => installed,
    }
    
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
    
}
