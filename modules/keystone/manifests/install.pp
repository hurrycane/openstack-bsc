class keystone::install {
  require "apache"
  require "mysql"

  package { "keystone":
    ensure => latest,
    notify => [Service["apache2"], Service["nova-api"]],
    require => [
      Package["nova-common"]
    ]
  }

  file { "keystone.conf":
    path => "/etc/keystone/keystone.conf",
    ensure  => present,
    owner   => "keystone",
    mode    => 0600,
    content => template("keystone/keystone.conf.erb"),
    notify => Service["keystone"],
    require => Package["keystone"]
  }

  file { "keystone_data.sh":
    path => "/var/lib/keystone/keystone_data.sh",
    ensure  => present,
    mode    => 0700,
    content => template("keystone/keystone_data.sh.erb"),
    require => Package["keystone"],
    notify => [ Exec["create_keystone_db"], Service["keystone"] ]
  }


  exec { "create_keystone_db":
    command     => "mysql -uroot -p${mysql_password} -e 'DROP DATABASE IF EXISTS keystone; CREATE DATABASE keystone;'",
    path        => [ "/bin", "/usr/bin" ],
    require => [Service['mysql']]
  }

  # this is all totally brute force
  #exec { "sync_keystone_db":
  #  command     => "sudo -u keystone keystone-manage db_sync",
  #  path        => [ "/bin", "/usr/bin" ],
  #  notify      => Exec["create_keystone_data"],
  #  refreshonly => true,
  #  require     => [File["/etc/keystone/keystone.conf"], Package['keystone']]
  #}

  exec { "create_keystone_data":
    command     => "/var/lib/keystone/keystone_data.sh",
    path        => [ "/bin", "/usr/bin" ],
    require     => [
      Package['keystone'],
      File['keystone.conf'],
      File["keystone_data.sh"]
    ]
  }

}
  
