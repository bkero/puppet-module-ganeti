class ganeti (
  $hypervisor="qemu-kvm",
  $uselvm=True,
  $managekernel=False
) {
  include package::virtual

  realize(
    Package["ganeti-htools"],
    Package["ganeti-instance-debootstrap"],
    Package["ganeti2"],
  )

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
      realize(
        Package["kvm-pxe"],
        Package["qemu-kvm"],
        Package["qemu-kvm-extras"],
      )
      # Include other stuff such as NRPE check scripts
    }
    /xen/: {
      realize(
        Package["xen-hypervisor-4.1"],
        Package["xen-utils-commont"],
      )
      exec { 'make-xenkernels-first':
        require     => [Package["xen-utils-common"], Package["xen-hypervisor-4.1"]],
        creates     => "/etc/grub.d/21_linux",
        cwd         => "/etc/grub.d/",
        path        => ["/usr/bin", "/bin"],
        refreshonly => true,
        user        => "root",
        command     => "/bin/mv /etc/grub.d/10_linux /etc/grub.d/21_linux && /usr/sbin/update-grub",
      }
    }
  }

  File["/etc/modprobe.d/drbd.conf"] -> Package["ganeti2"]
}
