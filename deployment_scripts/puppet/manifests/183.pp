notice('MODULAR: 183')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database






class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'cn=test_user,ou=Group,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                  'cn' => 'test_user',
                  'objectClass' => 'posixGroup',
                  'gidNumber' => '9999',
                  'description' => 'Primary Group For test_user',
                  'memberUid' => 'test_user',
                 }
}
