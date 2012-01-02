class glance::install {
  require "mysql"

  file { '/opt/stack/glance/images' :
    ensure      => directory,
    owner       => 'stack',
    group       => 'stack',
    mode        => 755,
    require => Git_clone["glance"]
  }

  git_clone { "glance" :
    source    => "https://github.com/openstack/glance.git",
    real_name => "glance",
    localtree => "/opt/stack",
    branch    => "master",
  }

  exec { "python-install-glance":
    path => "/usr/local/bin:/usr/bin:/bin",
    cwd => "/opt/stack/glance",
    command => "python setup.py develop",
    timeout => 0,
    require => [
      Class["nova::packages"],
      Git_clone["glance"],
      Class["nova"]
    ],
    logoutput => on_failure
  }

  file { "glance-api.conf":
    path => "/opt/stack/glance/etc/glance-api.conf",
    ensure  => present,
    mode    => 0600,
    owner   => "stack",
    group   => "stack",
    content => template("glance/glance-api.conf.erb"),
    require => Git_clone["glance"]
  }

  file { "glance-registry.conf":
    path => "/opt/stack/glance/etc/glance-registry.conf",
    ensure  => present,
    mode    => 0600,
    owner   => "stack",
    group   => "stack",
    content => template("glance/glance-registry.conf.erb"),
    require => Git_clone["glance"]
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

