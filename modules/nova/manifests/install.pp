class nova::install {

  require 'mysql'
  require 'rabbitmq'

  $nova_packages = [ "lvm2", "open-iscsi", "open-iscsi-utils" ]
  $nova_baseline = ["dnsmasq-base", "dnsmasq-utils", "kpartx", "parted", "arping", "iputils-arping", "python-mysqldb", "python-xattr", "python-lxml", "gawk", "iptables", "ebtables", "sqlite3", "sudo", "kvm", "vlan", "socat", "python-mox", "python-paste", "python-migrate", "python-gflags", "python-libvirt", "python-libxml2", "python-routes", "python-netaddr", "python-pastedeploy", "python-eventlet", "python-cheetah", "python-carrot", "python-tempita", "python-sqlalchemy", "python-suds", "python-lockfile", "python-m2crypto", "python-boto", "python-kombu", "python-feedparser"]

  package { $nova_packages :
    ensure => latest
  }

  package { $nova_baseline :
    ensure => latest
  }

  git::clone { "nova" :
    source    => "https://github.com/openstack/nova.git",
    real_name => "nova",
    localtree => "/opt/stack",
    branch    => "master"
  }

  git::clone { "nova-client" :
    source  => "https://github.com/openstack/python-novaclient.git",
    real_name => "python-novaclient",
    localtree => "/opt/stack",
    branch    => "master"
  }

  exec { "python-install-nova-client":
    path => "/usr/local/bin:/usr/bin:/bin",
    cwd => "/opt/stack/python-novaclient",
    command => "python setup.py develop",
    timeout => 0,
    require => Package["build-essential"]
  }

  exec { "python-install-nova":
    path => "/usr/local/bin:/usr/bin:/bin",
    cwd => "/opt/stack/nova",
    command => "python setup.py develop",
    timeout => 0,
    require => Package["build-essential"]
  }
  
}
