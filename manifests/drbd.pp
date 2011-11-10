class ganeti::drbd {
    package { drbd:
            ensure => present;
    }

    service {
        "drbd":
            enable => true,
            ensure => running,
            hasrestart => true,
            hasstatus => true,
            require => Package['drbd'],
    }

}
