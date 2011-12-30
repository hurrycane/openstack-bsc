class nova-api::install {

  package { "python-keystone":
    ensure => latest
  }

  package { "nova-api":
    ensure => latest,
    require => [
      Package["nova-common"],
      Package["openstackx"],
      Package["python-keystone"]
    ]
  }

  file { "/etc/nova/nova-api-paste.ini":
    ensure => present,
    content => template("nova-api/api-paste.ini.erb"),
    require => [
      Package["nova-api"]
    ]
  }
}

