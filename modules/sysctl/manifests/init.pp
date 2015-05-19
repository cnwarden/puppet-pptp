class sysctl {
   file { "sysctl_conf":
      name => $operatingsystem ? {
        default => "/etc/sysctl.conf",
      },
   }

   exec { "sysctl -p":
      alias       => "sysctl",
      refreshonly => true,
      path        => ['/usr/sbin'],
      subscribe   => File["sysctl_conf"],
   }
}