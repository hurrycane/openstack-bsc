class keystone::install {

  git_clone { "keystone" :
    source    => "https://github.com/openstack/keystone.git",
    real_name => "keystone",
    localtree => "/opt/stack",
    branch    => "stable/diablo"
  }

  file { "keystone.conf":
    path => "/opt/stack/keystone/etc/keystone.conf",
    ensure  => present,
    mode    => 0600,
    content => template("keystone/keystone.conf.erb"),
    #notify => Service["keystone"],
    require => Git_clone["keystone"]
  }

  file { "keystone_data.sh":
    path => "/opt/stack/keystone/bin/keystone_data.sh",
    ensure  => present,
    mode    => 0700,
    content => template("keystone/keystone_data.sh.erb"),
    require => Git_clone["keystone"]
  }


  exec { "create_keystone_db":
    command     => "mysql -uroot -p${mysql_password} -e 'DROP DATABASE IF EXISTS keystone; CREATE DATABASE keystone;'",
    path        => [ "/bin", "/usr/bin" ]
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
    command     => "/opt/stack/keystone/bin/keystone_data.sh",
    path        => [ "/bin", "/usr/bin" ],
    require     => [
      Git_clone["keystone"],
      File['keystone.conf'],
      File["keystone_data.sh"]
    ],
    cwd         => '/opt/stack/keystone/bin'
  }

}
  
