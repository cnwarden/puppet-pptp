
class pptp::install {
    notice("Private PPTP Deployment")
    
    package { 'ppp':
        ensure => installed,
        before => Package['pptpd']
    }
    
    package { 'iptables':
        ensure => installed,
        before => Package['pptpd']
    }
    
    package { 'pptpd':
        ensure => installed,
        source => "http://poptop.sourceforge.net/yum/stable/packages/pptpd-1.4.0-1.el6.x86_64.rpm",
        provider => "rpm",
        install_options => ['-ivh'],
    }
    
    file {'/etc/ppp/options.pptpd':
        ensure => present,
        content => template('pptp/options.pptpd.erb'),
        owner   => "root",
        group   => "root",
        mode    => "0644",
        require => Package['pptpd'],
    }
    
    file {'/etc/ppp/chap-secrets':
        ensure => present,
        content => template('pptp/chap-secrets.erb'),
        owner   => "root",
        group   => "root",
        mode    => "0644"
        require => Package['pptpd'],
    }
}
