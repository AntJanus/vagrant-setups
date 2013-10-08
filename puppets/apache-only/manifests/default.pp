exec { "apt-get update":
  command => "/usr/bin/apt-get update",
}

package { "apache2":
	ensure  => present,
	require => Exec ["apt-get update"],
}

service { "apache2":
  ensure  => "running",
  require => Package["apache2"],
}

file { "/var/www":
  ensure  => "link",
  target  => "/vagrant",
  require => Package["apache2"],
  notify  => Service["apache2"],
  force => true,
}