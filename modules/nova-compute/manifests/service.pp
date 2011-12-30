class nova-compute::service {
  service { "nova-compute":
    ensure    => running,
    enable    => true,
    #start     => "rm -f /var/lock/nova/nova-iptables.lock.lock; start nova-compute",
    hasrestart=> true,
    subscribe => File["/etc/nova/nova.conf"],
    require   => Class["nova-compute::install"]
  }
}
