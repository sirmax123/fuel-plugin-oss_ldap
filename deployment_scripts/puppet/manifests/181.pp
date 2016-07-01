notice('MODULAR: 181')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database


class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'ou=Group,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                  'ou' => 'Group',
                  'objectClass' => 'top',
                  'objectClass' => 'organizationalUnit',
                 }
}

