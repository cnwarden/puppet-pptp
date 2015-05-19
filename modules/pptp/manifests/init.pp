
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
        mode    => "0644",
        require => Package['pptpd'],
    }
    
    include sysctl
    sysctl::conf {
        "net.ipv4.ip_forward": value =>  1;
    }
    
    service { 'pptpd':
        ensure => "running",
        require => [File["/etc/ppp/options.pptpd"], File["/etc/ppp/chap-secrets"]],
    }
    
    exec { "iptables rules":
      command     => "iptables -A INPUT -p tcp --dport 1723 -j ACCEPT && iptables -A INPUT -p tcp --dport 47 -j ACCEPT && iptables -A INPUT -p gre -j ACCEPT && iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE",
      path        => ['/usr/sbin'],
      require     => Service["pptpd"],
    }
    
    service { 'firewalld':
        ensure => "running",
        require => Exec['iptables rules']
    }
    
}
