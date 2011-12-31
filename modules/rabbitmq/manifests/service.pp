class rabbitmq::service {
  service { "rabbitmq-server":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => Class["rabbitmq::install"]
  }
}
