notice('MODULAR: 120_phpldapadmin.pp')


define apache::loadmodule () {
     exec { "/usr/sbin/a2enmod $name" :
          unless => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
          notify => Service[apache2]
     }
}

define apache::enablesite () {
     exec { "/usr/sbin/a2ensite $name" :
          unless => "/bin/readlink -e /etc/apache2/sites-available/${name}.conf",
          notify => Service[apache2]
     }
}


include ::ldap_config
$ldap_config_rootdn   = $::ldap_config::rootdn
if $::ldap_config::phpldapadmin {

  notice('120_phpldapadmin.pp:  phpldapadmin is selected to be installed')

  package { 'apache2':
    ensure => 'installed',
  }

  service { 'apache2':
    ensure  => 'running',
    enable  => true,
    require => Package['apache2'],
  }


  package { 'phpldapadmin':
    ensure => 'installed',
    notify => Service['apache2']
  }


  package { 'php5-sasl':
    ensure => 'installed',
    notify => Service['apache2']
  }

  file { '/etc/phpldapadmin/config.php':
    ensure  => file,
    content => template('ldap_config/phpldapadmin_config.php.erb'),
  }

  apache::loadmodule{"ssl": }
  apache::enablesite{"default-ssl": }
}
