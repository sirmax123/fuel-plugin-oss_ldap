notice('MODULAR: 172')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database





class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'cn=%admin,ou=sudo,ou=services,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                  'objectClass'   => [ 'top', 'sudoRole' ],
                  'cn'            => '%admin',
                  'sudoUser'      => '%admin',
                  'sudoHost'      => 'ALL',
                  'sudoRunAsUser' => 'ALL',
                  'sudoCommand'   => 'ALL',
                  'sudoOrder'     => '3',
                 }
}

