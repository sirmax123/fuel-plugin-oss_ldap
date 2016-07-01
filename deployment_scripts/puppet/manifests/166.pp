notice('MODULAR: 166')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database




class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'ou=services,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                  'ou' => 'Services',
                  'objectClass' => [ "top", "organizationalUnit" ],
                  'description' => 'Group all services under this OU',
                 }
}



