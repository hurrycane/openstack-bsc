class openstackx::install {

  git_clone { "openstackx" :
    source    => "https://github.com/cloudbuilders/openstackx.git",
    real_name => "openstackx",
    localtree => "/opt/stack",
    branch    => "master"
  }

  exec { "python-install-openstackx" :
    path => "/usr/local/bin:/usr/bin:/bin",
    cwd => "/opt/stack/openstackx",
    command => "python setup.py develop",
    timeout => 0,
    require => [
      Class["nova"],
      Class["nova-common"],
      Git_clone["openstackx"]
    ],
    logoutput => on_failure
  }


}
