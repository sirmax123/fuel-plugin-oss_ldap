notice('MODULAR: 170')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database





class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'cn=root,ou=sudo,ou=services,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                  'objectClass'    => [ "top", "sudoRole" ],
                  'cn'             => "root",
                  'sudoUser'       => "root",
                  'sudoHost'       => "ALL",
                  'sudoRunAsUser'  => "ALL",
                  'sudoRunAsGroup' => "ALL",
                  'sudoCommand'    => "ALL",
                  'sudoOrder'      => "2",
                 }
}

