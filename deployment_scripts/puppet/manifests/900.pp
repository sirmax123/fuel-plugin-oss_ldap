notice('MODULAR: 900')

exec { " /etc/init.d/slapd  restart":
  cwd     => '/etc/ldap',
  path    => ['/usr/bin', '/usr/sbin',],
} 

