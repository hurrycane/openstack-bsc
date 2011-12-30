class openstackx::install {
  package { openstackx:
    ensure => latest,
    notify => [Service["nova-api"]]
  }
}

