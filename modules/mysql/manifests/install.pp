class mysql::install {
  package { "mysql-server": ensure => installed }
  package { "mysql-common": ensure => installed }
  package { "mysql-client": ensure => installed }

  exec { "set-mysql-password":
    unless => "mysqladmin -uroot -p$mysql_password status",
    path => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password $mysql_password",
  }
  
}
