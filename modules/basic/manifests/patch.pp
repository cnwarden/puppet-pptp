
class basic::patch {
    #ignore error using unless
    
    exec{ "python3_install":
        command => "yum -y install scl-utils && rpm -Uvh https://www.softwarecollections.org/en/scls/rhscl/python33/epel-7-x86_64/download/rhscl-python33-epel-7-x86_64.noarch.rpm && yum -y install python33",
        unless  => 'cd /root/',
        path    => ['/usr/bin'],
    }
    
    exec{ "you-get_install":
        command => "cd /root/workspace && rm -rf /root/workspace/you-get &&git clone https://github.com/soimort/you-get.git",
        path => ['/usr/bin'],
    }
    
}
