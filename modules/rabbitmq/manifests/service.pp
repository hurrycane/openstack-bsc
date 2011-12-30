class rabbitmq::service {
  service { "rabbitmq":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => Class["rabbitmq::install"]
  }
}
