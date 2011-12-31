class nova-compute::install {

  exec { "modprobe-nbd" :
    command => "modprobe nbd",
    path => "/usr/local/bin:/usr/bin:/bin",
    logoutput => on_failure,
    require => Class["nova"]
  }

  exec { "stack-user-libvert-group" :
    command => "usermod -a -G libvirtd stack",
    path => "/usr/local/bin:/usr/bin:/bin",
    logoutput => on_failure,
    require => Class["nova"],
    notice => Service["libvirt-bin"]
  }

  exec { "/opt/tools/clean_iptables" :
    path    => "/usr/local/bin:/usr/bin:/bin",
    command => "/opt/tools/clean_iptables",
    require => [Class["nova"], Exec["/opt/tools/clean_iptables"]],
    logoutput => on_failure,
  }


}
