class nova-scheduler::service {

  service { "nova-scheduler":
    ensure    => running,
    enable    => true,
    subscribe => File["/etc/nova/nova.conf"],
    require => [
      Package["nova-scheduler"]
    ]
  }
  
}
