class nova-volumes::service {
  service { "iscsitarget":
    ensure  => running,
    enable  => true,
    require => Class["nova-volumes::install"]
  }

}
