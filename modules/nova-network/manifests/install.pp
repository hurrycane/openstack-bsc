class nova-network::install {
  exec { "clean-networks" :
    command => "/opt/tools/clean-networks",
    path => "/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin",
    logoutput => on_failure,
    require => [
      Package["dnsmasq-base"],
      Class["nova"],
      Class["nova-common"],
      Git_clone["nova"]
    ]
  }
}
