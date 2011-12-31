class nova::packages {
  $nova_packages = [ "lvm2", "open-iscsi", "open-iscsi-utils" ]
  $nova_baseline = ["dnsmasq-base", "dnsmasq-utils", "kpartx", "parted", "arping", "iputils-arping", "python-mysqldb", "python-xattr", "python-lxml", "gawk", "iptables", "ebtables", "sqlite3", "sudo", "kvm", "vlan", "socat", "python-mox", "python-paste", "python-migrate", "python-gflags", "python-libvirt", "python-libxml2", "python-routes", "python-netaddr", "python-pastedeploy", "python-eventlet", "python-cheetah", "python-carrot", "python-tempita", "python-sqlalchemy", "python-suds", "python-lockfile", "python-m2crypto", "python-boto", "python-kombu", "python-feedparser"]

  package { $nova_packages :
    ensure => latest
  }

  package { $nova_baseline :
    ensure => latest
  }



 
}
