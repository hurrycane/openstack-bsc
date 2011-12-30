class nova-common::install {
  $nova_common_packages = [ "nova-common", "python-nova", "python-mysqldb", "python-eventlet", "python-novaclient", "python-greenlet" ]
  $nova_common_other = [ "dnsmasq-base", "dnsmasq-utils", "socat" ]

  package { $nova_common_packages:
    ensure  => latest
  }

  package { $nova_common_other:
    ensure => latest
  }

  file { "nova-default":
    path => "/etc/default/nova-common",
    content => "ENABLED=1",
    require => Package["nova-common"]
  }

}
