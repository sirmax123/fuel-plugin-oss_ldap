notice('MODULAR: 101_install_openldap.pp')

include ::ldap_config

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database

#Set Server ID (we always have 2 nodes)

$r = hiera("role")
if "$r" == "primary-oss_ldap"  {
  $ldap_server_id = 1
} else {
  $ldap_server_id = 2

}


file { $::ldap_config::ldap_ssl_cert_dir:
    ensure => 'directory',
    mode   => '755',
    owner  => 'root',
    group  => 'root',
} ->

file { $::ldap_config::olcTLSCertificateFile:
    source => 'puppet:///modules/ldap_ssl/CA/certs/ldap.crt',
    mode   => '644',
    owner  => 'root',
    group  => 'root',
  } ->

  file { $::ldap_config::olcTLSCertificateKeyFile:
    source => 'puppet:///modules/ldap_ssl/CA/private/ldap.key',
    mode   => '644',
    owner  => 'root',
    group  => 'root',
  } ->

  file { $::ldap_config::olcTLSCACertificateFile:
    source => 'puppet:///modules/ldap_ssl/CA/certs/rootca.crt',
    mode   => '644',
    owner  => 'root',
    group  => 'root',
  } ->


class { 'openldap::client':
  base         => $::ldap_config::database,
  uri          => ['ldaps://ldap' ],
  tls_cacert   => $::ldap_config::olcTLSCACertificateFile,
  tls_reqcert  => 'demand',
  timelimit    => 15,
  timeout      => 20,

} ->


class { 'openldap::utils': } ->

class { 'openldap::server':
  ldaps_ifs => ["ldap$ldap_server_id"],
  ldap_ifs  => ["ldap$ldap_server_id"],
  ssl_cert  => $::ldap_config::olcTLSCertificateFile,
  ssl_key   => $::ldap_config::olcTLSCertificateKeyFile,
  ssl_ca    =>  $::ldap_config::olcTLSCACertificateFile,
  databases => {
    "$::ldap_config::database" => {
        rootdn    => $::ldap_config::rootdn,
        rootpw    => $::ldap_config::rootpw
    }
  },
}

## need for ldap_entry usage

package { 'ruby-net-ldap':
    ensure => 'installed',
}
