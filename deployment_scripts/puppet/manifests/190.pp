notice('MODULAR: 190')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database


class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'cn=nssproxy,ou=Group,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                  'cn'          => 'nssproxy',
                  'objectClass' =>  [ "groupOfNames", "top" ],
                  'member'      =>  'uid=nssproxy-node,ou=service_users,dc=customer_organization,dc=fuel_domain',
                 }
}