class nova::install {

  require 'mysql'
  require 'rabbitmq'

  require 'nova::packages'

  git_clone { "nova" :
    source    => "https://github.com/openstack/nova.git",
    real_name => "nova",
    localtree => "/opt/stack",
    branch    => "master"
  }

  git_clone { "nova-client" :
    source  => "https://github.com/openstack/python-novaclient.git",
    real_name => "python-novaclient",
    localtree => "/opt/stack",
    branch    => "master"
  }

  exec { "python-install-nova-client":
    path => "/usr/local/bin:/usr/bin:/bin",
    cwd => "/opt/stack/python-novaclient",
    command => "python setup.py develop",
    timeout => 0,
    require => [Class["nova::packages"], Git_clone["nova-client"]],
    logoutput => on_failure
  }

  exec { "python-install-nova":
    path => "/usr/local/bin:/usr/bin:/bin",
    cwd => "/opt/stack/nova",
    command => "python setup.py develop",
    timeout => 0,
    require => [Class["nova::packages"], Git_clone["nova"]],
    logoutput => on_failure
  }
  
}
