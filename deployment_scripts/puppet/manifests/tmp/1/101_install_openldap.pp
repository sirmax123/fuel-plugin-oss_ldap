notice('MODULAR: 101_install_openldap.pp')


include ::ldap_config

notice('DEBUG: ')

  file { $::ldap_config::ldap_ssl_cert_dir:
    ensure => 'directory',
    mode   => '755',
    owner  => 'root',
    group  => 'root',
  } ->

#  $olcTLSCertificateFile    = "/etc/ldap/ssl/ldap.crt"
#  $olcTLSCertificateKeyFile = "/etc/ldap/ssl/ldap.key"
#  $olcTLSCACertificateFile  = "/etc/ssl/certs/rootca.crt"

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


#class { 'openldap::client':
#  base         => $::ldap_config::database,
#  uri          => ['ldaps://ldap' ],
#  tls_cacert   => $::ldap_config::olcTLSCACertificateFile,
#  tls_reqcert  => 'demand',
#  timelimit    => 15,
#  timeout      => 20,
#
#} ->

class { 'ldap::client':
  base         => $::ldap_config::database,
  uri          => 'ldaps://ldap',
  timelimit    => 15,
  ssl          => true,
  ssl_cacert   => $::ldap_config::olcTLSCACertificateFile,
  ssl_reqcert  => 'demand'
} -> 

class { 'ldap::server':
  suffix     => $::ldap_config::database,
  rootdn     => $::ldap_config::rootdn,
  rootpw     => $::ldap_config::rootpw,
  ssl        => true,
  ssl_cert   => $::ldap_config::olcTLSCertificateFile,
  ssl_key    => $::ldap_config::olcTLSCertificateKeyFile,
  ssl_cacert => $::ldap_config::olcTLSCACertificateFile,
}


#
#class { 'openldap::utils': } -> 
#
## ? olcTLSVerifyClient: never
#class { 'openldap::server':
#  ldaps_ifs => ['/'],
#  ssl_cert  => $::ldap_config::olcTLSCertificateFile,
#  ssl_key   => $::ldap_config::olcTLSCertificateKeyFile,
#  ssl_ca    =>  $::ldap_config::olcTLSCACertificateFile,
#  databases => {
#    "$::ldap_config::database" => {
#        rootdn    => $::ldap_config::rootdn,
#        rootpw    => $::ldap_config::rootpw
#    }
#  },
#  databases => {
#    "cn=config" => {
#        rootdn    => $::ldap_config::rootdn,
#        rootpw    => $::ldap_config::rootpw
#    }
#  }
#} 
#
#
#openldap::server::module { 'syncprov':
#  ensure => present,
#} 
#
#openldap::server::overlay { 'syncprov on cn=config':
#  ensure => present,
#}
#
#
#
##openldap::server::access {
##  suffix => 'cn=config'
##  'to attrs=userPassword,shadowLastChange by dn="cn=admin,dc=example,dc=com" on dc=example,dc=com':
##    access => 'write';
##  'to attrs=userPassword,shadowLastChange by anonymous on dc=example,dc=com':
##    access => 'auth';
##  'to attrs=userPassword,shadowLastChange by self on dc=example,dc=com':
##    access => 'write';
##  'to attrs=userPassword,shadowLastChange by * on dc=example,dc=com':
##    access => 'none';
##access = 
##}






