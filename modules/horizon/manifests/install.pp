class horizon::install {

  require 'nova'
  require 'nova-common'

  $horizon_packages = ["python-anyjson","python-cloudfiles","python-django","python-django-mailer","python-django-nose","python-django-registration","python-cherrypy3","python-sphinx","python-dateutil", "python-nose"]

  package { $horizon_packages:
    ensure => latest
  }

  git_clone { "horizon" :
    source    => "https://github.com/openstack/horizon.git",
    real_name => "horizon",
    localtree => "/opt/stack",
    branch    => "master",
  }

  exec { "python-install-horizon-base":
    path => "/usr/local/bin:/usr/bin:/bin",
    cwd => "/opt/stack/horizon/horizon",
    command => "python setup.py develop",
    timeout => 0,
    require => [
      Git_clone["horizon"],
      Class["nova"],
      Package[$horizon_packages],
      Class["apache"]
    ],
    logoutput => on_failure
  }

  exec { "python-install-horizon-dashboard":
    path => "/usr/local/bin:/usr/bin:/bin",
    cwd => "/opt/stack/horizon/openstack-dashboard",
    command => "python setup.py develop",
    timeout => 0,
    require => [
      Git_clone["horizon"],
      Class["nova"],
      Exec["python-install-horizon-base"],
      Package[$horizon_packages]
    ],
    logoutput => on_failure
  }

  file { '/opt/stack/horizon/openstack-dashboard/quantum' :
    ensure      => directory,
    owner       => 'stack',
    group       => 'stack',
    mode        => 755,
    require => Git_clone["horizon"]
  }

  file { '/opt/stack/horizon/.blackhole' :
    ensure      => directory,
    owner       => 'stack',
    group       => 'stack',
    mode        => 755,
    require => Git_clone["horizon"]
  }

  exec { "touch-quantum-files" :
    path => "/usr/local/bin:/usr/bin:/bin",
    command => "touch __init__.py; touch client.py",
    cwd => "/opt/stack/horizon/openstack-dashboard/quantum",
    timeout => 0,
    require => [
      File["/opt/stack/horizon/openstack-dashboard/quantum"]
    ],
    logoutput => on_failure
  }

  file { "local_settings.py" :
    path => "/opt/stack/horizon/openstack-dashboard/local/local_settings.py",
    ensure  => present,
    mode    => 0600,
    owner   => "stack",
    group   => "stack",
    content => template("horizon/local_settings.py.erb"),
    require => [
      Git_clone["horizon"],
      Exec["python-install-horizon-dashboard"],
      Exec["python-install-horizon-base"]
    ]
  }

  file { "horizon-000-default" :
    path => "/etc/apache2/sites-enabled/000-default",
    ensure  => present,
    mode    => 0600,
    content => template("horizon/000-default.erb"),
    require => [
      Exec["horizon-sync-db"],
      File["local_settings.py"],
      Exec["touch-quantum-files"],
      File["/opt/stack/horizon/.blackhole"],
      Class["apache"]
    ],
    notify => Service["apache2"]
  }

  exec { "horizon-sync-db":
    path => "/usr/local/bin:/usr/bin:/bin",
    command => "python manage.py syncdb",
    cwd => "/opt/stack/horizon/openstack-dashboard/dashboard/",
    timeout => 0,
    require => [
      Git_clone["horizon"]
    ],
    logoutput => on_failure
  }


}
