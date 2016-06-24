notice('MODULAR: 103')


include ::ldap_config

$ldap_config_rootpw = $::ldap_config::rootpw
$ldap_config_rootdn = $::ldap_config::rootdn

#Set Server ID (we always have 2 nodes)
$r = hiera("role")
if "$r" == "primary-oss_ldap"  {
  $ldap_server_id = 1
} else {
  $ldap_server_id = 2

}

#
# It is not possible to edit cn=config db with existing code  because
# puppet module can connect only using ldap:// or ldaps://  but not
# using ldapi:///
# So I have co configure access with such workaround
#

file { '/etc/ldap/rootpw':
  ensure  => file,
  content => template('ldap_config/rootpw.erb'),
} ->

file { '/etc/ldap/rootdn':
  ensure  => file,
  content => template('ldap_config/rootdn.erb'),
} ->

exec { "$::ldap_config::ldapmodify_ldapi -f /etc/ldap/rootdn":
  cwd     => '/etc/ldap',
  path    => ['/usr/bin', '/usr/sbin',],
  unless  => $::ldap_config::check_if_olcRootDN_exist,
} ->

exec { "$::ldap_config::ldapmodify_ldapi -f /etc/ldap/rootpw":
  cwd     => '/etc/ldap',
  path    => ['/usr/bin', '/usr/sbin',],
  unless  => $::ldap_config::check_if_olcRootPW_exist,
} ->



file { '/etc/ldap/module.ldif':
  ensure  => file,
  content => template('ldap_config/module.ldif.erb'),
} ->

file { '/etc/ldap/overley.ldif':
  ensure  => file,
  content => template('ldap_config/overley.ldif.erb'),
} ->

exec { "$::ldap_config::ldapmodify_ldapi -f /etc/ldap/module.ldif":
  cwd     => '/etc/ldap',
  path    => ['/usr/bin', '/usr/sbin',],
  unless  => "$::ldap_config::check_if_Moduel_exist",
} ->

exec { "$::ldap_config::ldapmodify_ldapi -f /etc/ldap/overley.ldif":
  cwd     => '/etc/ldap',
  path    => ['/usr/bin', '/usr/sbin',],
  unless  => $::ldap_config::check_if_Overley_exist,
} -> 




file { '/etc/ldap/ServerID.ldif':
  ensure  => file,
  content => template('ldap_config/ServerID.ldif.erb'),
} ->

exec { "$::ldap_config::ldapmodify_ldapi -f /etc/ldap/ServerID.ldif":
  cwd     => '/etc/ldap',
  path    => ['/usr/bin', '/usr/sbin',],
  unless  => "$::ldap_config::check_if_ServerID_exist",
}



file { '/etc/ldap/ReplicaConfig_config.ldif':
  ensure  => file,
  content => template('ldap_config/ReplicaConfig_config.ldif.erb'),
} ->

exec { "$::ldap_config::ldapmodify_ldapi -f /etc/ldap/ReplicaConfig_config.ldif":
  cwd     => '/etc/ldap',
  path    => ['/usr/bin', '/usr/sbin',],
  unless  => "$::ldap_config::check_if_ReplicaConfig_exist",
} ->



file { '/etc/ldap/ReplicaConfig_domain.ldif':
  ensure  => file,
  content => template('ldap_config/ReplicaConfig_domain.ldif.erb'),
} ->

exec { "$::ldap_config::ldapmodify_ldapi -f /etc/ldap/ReplicaConfig_domain.ldif":
  cwd     => '/etc/ldap',
  path    => ['/usr/bin', '/usr/sbin',],
  unless  => "$::ldap_config::check_if_ReplicaDomain_exist",
}



