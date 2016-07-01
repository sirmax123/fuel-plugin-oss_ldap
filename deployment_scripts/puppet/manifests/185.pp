notice('MODULAR: 185')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database





class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'cn=fuel_users,ou=Group,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                  'cn' => 'fuel_users',
                  'objectClass' => [ 'posixGroup' ],
                  'gidNumber' => '109999',
                  'description' => 'Fuel Users',
                  'memberUid' => 'test_user',
                 }
}



