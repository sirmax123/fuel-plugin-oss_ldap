notice('MODULAR: 110_configure_replica_objects.pp')


include ::ldap_config


file { '/etc/ldap/FixPermissionsAllowNssReadPAsswords.ldif':
  ensure  => file,
  content => template('ldap_config/FixPermissionsAllowNssReadPAsswords.ldif.erb'),
} ->

exec { "$::ldap_config::ldapmodify_ldapi -f /etc/ldap/FixPermissionsAllowNssReadPAsswords.ldif":
  cwd     => '/etc/ldap',
  path    => ['/usr/bin', '/usr/sbin',],
}

