notice('MODULAR: 140_populate_ldap_customers_organization.pp')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   = $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database


class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'dc=customer_organization,dc=fuel_domain',
  attributes  => {
                   'objectClass'  => ["dcObject", "organization"],
                   'o'  => 'fuel_users',
                   'dc' => 'customer_organization',
                   'o'  => 'Customer1_s Organization'
                 },
}


