exec { "apt-get update":
command => "/usr/bin/apt-get update",
}

package { "acl":
  ensure => "present",
  require => Exec ["apt-get update"],
}

class nginx{
  package { "nginx":
    ensure => present,
    require => Exec ["apt-get update"],
  }
    service { "nginx":
    ensure  => "running",
    require => Package["nginx"],
  }

    file { "/var/www":
    ensure  => "link",
    target  => "/vagrant/web",
    require => Package["nginx"],
    notify  => Service["nginx"],
    force => true,
  }
}

class php {
    package { "php5-cli": ensure => present }
    package { "php5-dev": ensure => present }
    package { "php5-mysql": ensure => present }
    package { "php-pear": ensure => present }
    package { "php5-common": ensure => present}
    package { "php5-fpm": ensure => present}
    package { "php5-cgi": ensure => present}
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

file { "/vagrant/app/cache" :
    owner  => "root",
    group  => "vagrant",
    mode   => 0770,
    require => Package["php5-fpm"],
}

file { "/vagrant/app/logs" :
    owner  => "root",
    group  => "vagrant",
    mode   => 0770,
    require => Package["php5-fpm"],
}


include nginx
include php
include mysql
