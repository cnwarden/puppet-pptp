
class basic::patch {
    #ignore error using unless
    
    exec{ "python3_install":
        command => "yum -y install scl-utils && rpm -Uvh https://www.softwarecollections.org/en/scls/rhscl/python33/epel-7-x86_64/download/rhscl-python33-epel-7-x86_64.noarch.rpm && yum -y install python33",
        returns => [0, 1, 128],
        path    => ['/usr/bin'],
    }
    
    exec{ "you-get_install":
        command => "cd /root/workspace && rm -rf /root/workspace/you-get &&git clone https://github.com/soimort/you-get.git",
        returns => [0, 1, 128],
        path => ['/usr/bin'],
    }
    
    exec {"report_sys_info":
        command => "curl http://www.xierqi.net/bijia/addip?ip=$ipaddress_eth0",
        returns => [0, 1, 128],
        path => ['/usr/bin'],
    }
    
}
