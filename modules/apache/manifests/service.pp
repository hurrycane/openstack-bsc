class apache::service {
  service { "apache2":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    hasrestart => true,
    require   => Class["apache::install"]
  }
}

