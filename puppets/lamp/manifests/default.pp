exec { "apt-get update":
command => "/usr/bin/apt-get update",
}

package { "acl":
ensure => "present",
require => Exec ["apt-get update"],
}

class apache2{
  exec { "enable-mod_rewrite":
  require => Package["apache2"],
  before => Service["apache2"],
  command => "/usr/sbin/a2enmod rewrite"
}

package { "apache2":
ensure => present,
require => Exec ["apt-get update"],
}
service { "apache2":
ensure  => "running",
require => Package["apache2"],
}

file { "/var/www":
ensure  => "link",
target  => "/vagrant/web",
require => Package["apache2"],
notify  => Service["apache2"],
force => true,
}
}

class php {
  package { "libapache2-mod-php5": ensure => present }
  package { "php5": ensure => present }
  package { "php5-cli": ensure => present }
  package { "php5-dev": ensure => present }
  package { "php5-mysql": ensure => present }
  package { "php-pear": ensure => present }
  package { "php5-common": ensure => present}
  package { "php-apc": ensure => present}
  exec { "pear upgrade":
  command => "/usr/bin/pear upgrade",
  require => Package["php-pear"],
}
}
class mysql {
  package { "mysql-server":
  require => Exec["apt-get update"],
  ensure => present,
}
service { "mysql":
enable => true,
ensure => running,
require => Package["mysql-server"],
}
exec { "Set MySQL server root password":
require => Package["mysql-server"],
unless => "/usr/bin/mysqladmin -uroot -proot status",
command => "/usr/bin/mysqladmin -uroot password root",
}
}



include apache2
include php
include mysql
