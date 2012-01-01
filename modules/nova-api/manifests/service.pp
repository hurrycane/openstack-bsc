class nova-api::service {

  #service { "nova-api":
  #  ensure    => running,
  #  enable    => true,
  #  require   => [
  #    # File["nova-default"],
  #    File["/etc/nova/nova-api-paste.ini"]
  #  ],
  #  subscribe => [
  #    File["/etc/nova/nova.conf"],
  #    File["/etc/nova/nova-api-paste.ini"]
  #  ]
  #}

}
