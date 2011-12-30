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

}
