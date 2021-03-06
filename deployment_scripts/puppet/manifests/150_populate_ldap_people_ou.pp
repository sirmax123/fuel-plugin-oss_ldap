notice('MODULAR: 150_populate_ldap_people_ou.pp')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database



class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'ou=People,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                   'objectClass'  => ["top", "organizationalUnit"],
                   'ou'  => 'People'
                 },
}

