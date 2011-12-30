class mysql::config {
  
  file { '/etc/mysql':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => 0755
  }
    
  file { '/etc/mysql/my.cnf':
    ensure  => present,
    require => [ File['/etc/mysql'], Class['mysql::install'] ],
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('mysql/my.cnf.erb'),
    notify  => Service['mysql']
  }

  mysqldb { "nova":
        user => "root",
        password => $mysql_password
  }



  define mysqldb( $user, $password ) {
    exec { "create-${name}-db":
      unless => "/usr/bin/mysql -u${user} -p${password} ${name}",
      command => "/usr/bin/mysql -uroot -p$mysql_password -e \"create database ${name}; grant all on ${name}.* to ${user}@localhost identified by '$password';\"",
    require => Class['mysql::install']
    }
  }


}
