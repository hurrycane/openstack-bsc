class nova-volumes::install{
  $nova_volume_packages = ["iscsitarget-dkms","iscsitarget"]

  package { $nova_volume_packages :
    ensure => latest
  }

  exec { "clean-volume-groups" :
    command => "/opt/tools/clean-volume-groups",
    path => "/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin",
    logoutput => on_failure,
    require => [Package["iscsitarget"],Class["nova-compute"]],
    notify => Service["iscsitarget"]
  }


}
