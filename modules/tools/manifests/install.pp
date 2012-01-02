class tools::install {
  file { '/opt' :
    ensure      => directory,
    owner       => 'root',
    group       => 'root',
    mode        => 755
  }

  file { '/opt/tools' :
    ensure      => directory,
    owner       => 'root',
    group       => 'root',
    mode        => 755,
    require     => File["/opt"]
  }

  file { '/opt/tools/setuserpassword' :
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0511,
    source => "puppet:///tools/setuserpassword"
  }

  file { '/opt/tools/clean_iptables' :
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0511,
    source => "puppet:///tools/clean_iptables"
  }

  file { '/opt/tools/clean-volume-groups' :
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0511,
    source => "puppet:///tools/clean-volume-groups"
  }

  file { '/opt/tools/clean-networks' :
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0511,
    source => "puppet:///tools/clean-networks"
  }

  file { '/opt/tools/startup_scripts' :
    ensure => present,
    owner => "root",
    group => "root",
    mode => 0511,
    source => "puppet:///tools/startup_scripts"
  }



}
