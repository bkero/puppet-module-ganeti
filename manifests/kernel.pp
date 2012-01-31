class ganeti::kernel {
}
#
#    file { "kernelfiles":
#        path => "/opt/kernel/",
#        source => "puppet:///modules/ganeti/kernel/",
#        recurse => true,
#        ensure => present,
#    }
#
#    package {
#        "linux-image":
#	    name => "linux-image-3.2.0-030200rc1-generic",
#            provider => dpkg,
#            ensure => latest,
#            source => "/opt/kernel/linux-image-3.2.0-030200rc1-generic_3.2.0-030200rc1.201111071935_amd64.deb";
#
#        "linux-headers-amd64":
#	    name => "linux-headers-3.2.0-030200rc1-generic",
#            provider => dpkg,
#            ensure => latest,
#            source => "/opt/kernel/linux-headers-3.2.0-030200rc1-generic_3.2.0-030200rc1.201111071935_amd64.deb";
#
#        "linux-headers-all":
#	    name => "linux-headers-3.2.0-030200rc1",
#            provider => dpkg,
#            ensure => latest,
#            source => "/opt/kernel/linux-headers-3.2.0-030200rc1_3.2.0-030200rc1.201111071935_all.deb";
#
#    }
#    File["/opt/kernel"] -> File["kernelfiles"] -> Package["linux-image"] -> Package["linux-headers-all"] -> Package["linux-headers-amd64"]
#}
