class nova-network::service {

  #service { "nova-network":
  #  ensure    => running,
  #  enable    => true,
  #  start     => "rm -f /var/lock/nova/nova-iptables.lock.lock; start nova-network",
  #  hasrestart=> true,
  #  require   => [
  #    Package["nova-network"]
  #  ],
  #  subscribe => File["/etc/nova/nova.conf"],
  #}

}
