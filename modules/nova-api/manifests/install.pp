class nova-api::install {
  file { "/opt/stack/nova/bin/nova-api-paste.ini":
    ensure => present,
    owner   => "stack",
    group   => "stack",
    content => template("nova-api/api-paste.ini.erb"),
    require => [
      Git_clone["nova"],
      Class["nova"],
    ]
  }
}
