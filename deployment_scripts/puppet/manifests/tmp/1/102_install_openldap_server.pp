notice('MODULAR: 101_install_openldap.pp')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw =  $::ldap_config::rootpw


openldap::server::overlay { 'syncprov on cn=config':
  ensure => present,
}

openldap::server::module { 'syncprov':
  ensure => present,
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
  ldaps_ifs => ['/'],
  ssl_cert  => $::ldap_config::olcTLSCertificateFile,
  ssl_key   => $::ldap_config::olcTLSCertificateKeyFile,
  ssl_ca    =>  $::ldap_config::olcTLSCACertificateFile,
  databases => {
    "$::ldap_config::database" => {
        rootdn    => $::ldap_config::rootdn,
        rootpw    => $::ldap_config::rootpw
    }
  },
} ->

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
} 


### End of Workaround ####

notify { "Configure replication ": } 

### configure replication ###


#Set Server ID

if  hiera("role") == "primary_oss_ldap"  {
  $ldap_server_id = 1
} else {
  $ldap_server_id = 2
} 


#dn: dc=customer_organization,dc=fuel_domain
#dc: customer_organization
#o: Example Organization
#objectClass: dcObject
#objectClass: organization
#



class { 'ldap_create_object':
  ldap_entry  => 'dc=customer_organization,dc=fuel_domain',
  attributes  => {
                   'objectClass'  => ["dcObject", "organization"],
                   'o'  => 'fuel_users',
                   'dc' => 'customer_organization',
                   'o'  => 'Customer1_s Organization'
                 },
}


#notify {"End  of configure replication":`}

ldap_entry { 'cn=config':
  ensure      => present,
  base        => 'cn=config',
  host        => '127.0.0.1',
  port        => '636',
  self_signed => true,
  username    => 'cn=admin,cn=config',
  password    => $ldap_config_rootpw,
  attributes  => { 'olcServerID' => '99' },
}






