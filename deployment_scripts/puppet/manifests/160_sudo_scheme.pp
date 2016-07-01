notice('MODULAR: 160_sudo_scheme.pp')


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


file { '/etc/ldap/sudoers.schema':
  ensure  => file,
  content => template('ldap_config/SudoScheme.ldif.erb'),
} ->

exec { "$::ldap_config::ldapmodify_ldapi -f /etc/ldap/sudoers.schema":
  cwd     => '/etc/ldap',
  path    => ['/usr/bin', '/usr/sbin',],
  unless  => $::ldap_config::check_if_SudoScheme_exist
,
}






