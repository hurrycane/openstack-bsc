class nova-common::config {
  # set up the nova.conf
  file { "/etc/nova/nova.conf":
    ensure  => present,
    owner   => "nova",
    group   => "nova",
    mode    => 0660,
    content => template("nova-common/nova.conf.erb"),
    require => Package["nova-common"]
  }
}
