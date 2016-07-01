notice('MODULAR: 165')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database



class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'ou=service_users,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                   'objectClass'  => ["top", "organizationalUnit"],
                   'ou'  => 'service_users',
                 },
}


