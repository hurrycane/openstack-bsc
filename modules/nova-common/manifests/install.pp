class nova-common::install {
  $nova_common_packages = [ "pep8", "pylint", "python-pip", "screen", "unzip", "wget", "psmisc", "git-core", "lsof", "openssh-server", "vim-nox", "locate", "python-virtualenv", "python-unittest2", "iputils-ping", "curl", "tcpdump", "euca2ools", "libvirt-bin", "build-essential" ]

  $nova_pip_packages = [ "django-nose-selenium", "pycrypto==2.3","-e git+https://github.com/cloudbuilders/openstackx.git#egg=openstackx", "-e git+https://github.com/jacobian/openstack.compute.git#egg=openstack", "-e git+https://review.openstack.org/p/openstack/python-keystoneclient#egg=python-keystoneclient", "PassLib", "pika" ]
  
  package { $nova_common_packages:
    ensure  => latest
  }

  pip { $nova_pip_packages:
    ensure => installed
  }

}
