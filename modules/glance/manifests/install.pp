class glance::install {
  require "mysql"

  # TODO: Remove python-xattr once it is in glance packaging
  $glance_packages = [ "glance", "python-glance", "python-swift", "python-routes","python-argparse","python-sqlalchemy","python-wsgiref","python-pastedeploy","python-xattr"]

  package { $glance_packages:
    ensure => latest,
    notify => [Service["apache2"], Service["nova-api"]],
    require => [
      Package["nova-common"],
    ]
  }

  file { "glance-api.conf":
    path => "/etc/glance/glance-api.conf",
    ensure  => present,
    mode    => 0600,
    content => template("glance/glance-api.conf.erb"),
    notify => Service["glance-api"],
    require => Package["glance"]
  }

  file { "glance-scrubber.conf":
    path => "/etc/glance/glance-scrubber.conf",
    ensure  => present,
    mode    => 0600,
    content => template("glance/glance-scrubber.conf.erb"),
    notify => Service["glance-api"],
    require => Package["glance"]
  }
  
  file { "glance-cache.conf":
    path => "/etc/glance/glance-cache.conf",
    ensure  => present,
    mode    => 0600,
    content => template("glance/glance-cache.conf.erb"),
    notify => Service["glance-api"],
    require => Package["glance"]
  }

  file { "glance-registry.conf":
    path => "/etc/glance/glance-registry.conf",
    ensure  => present,
    owner   => "glance",
    mode    => 0600,
    content => template("glance/glance-registry.conf.erb"),
    notify => Service["glance-registry"],
    require => Package["glance"]
  }

  #file { "/usr/local/bin/keyglance":
  #  ensure  => present,
  #  owner   => 'glance',
  #  mode    => 0755,
  #  content => template('glance/keyglance.erb'),
  #}

  exec { "create_glance_db":
    command     => "mysql -uroot -p${mysql_password} -e 'DROP DATABASE IF EXISTS glance; CREATE DATABASE glance;'",
    path        => [ "/bin", "/usr/bin" ],
    # notify      => Exec["create_glance_user"],
    require     => [Service['mysql'], Class['mysql']]
  }

  # this is all totally brute force
  #exec { "sync_glance_db":
  #  command     => "sudo -u glance glance-manage db_sync",
  #  path        => [ "/bin", "/usr/bin" ],
  #  refreshonly => true,
  #  require     => [File["/etc/glance/glance-registry.conf"], Package['glance']]
  #}

}

