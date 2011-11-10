class ganeti ($hypervisor="qemu-kvm",
              $uselvm=True,
              $managekernel=False
    ) {
    package {
        ["ganeti2", "ganeti-instance-debootstrap", "ganeti-htools"]:
            ensure => installed;
    }

    service { "ganeti":
        ensure => running,
        enable => true,
        hasrestart => true,
        require => Package['ganeti2'];
    }

    if $managekernel {
        include ganeti::kernel
    }

    if $uselvm {
        file { "/etc/lvm.conf":
            ensure => present,
            source => "puppet:///modules/ganeti/lvm.conf",
        }
    }

    file { "/etc/modprobe.d/drbd.conf":
        content => "options drbd minor_count=128 usermode_helper=/bin/true",
    }

    #  Handle installing and setting up the hypervisor
    case $hypervisor {
        /kvm/: {
            package { ["qemu-kvm", "qemu-kvm-extras", "kvm-pxe"]:
                ensure => installed; }
            # Include other stuff such as NRPE check scripts
        }
        /xen/: {
            package { ["xen-utils-common", "xen-hypervisor-4.1"]:
                ensure => installed,
                notify => Exec['make-xenkernels-first']}
            exec { 'make-xenkernels-first':
                creates => "/etc/grub.d/21_linux",
                cwd => "/etc/grub.d/",
                path => ["/usr/bin", "/bin"],
                refreshonly => true,
                user => "root",
                command => "/bin/mv /etc/grub.d/10_linux /etc/grub.d/21_linux && /usr/sbin/update-grub",
            }
        }
    }

    File["/etc/modprobe.d/drbd.conf"] -> Package["ganeti2"]
}
