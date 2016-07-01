notice('MODULAR: 193')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database






class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'uid=nssproxy-node,ou=service_users,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                  'uid'              => 'nssproxy-node',
                  'gecos'            => 'Network Service Switch Proxy User',
                  'objectClass'      => ['top',  'posixAccount', 'shadowAccount', 'organizationalPerson', 'inetOrgPerson' ],
                  'userPassword'     => '{SSHA}RsAMqOI3647qg1gAZF3x2BKBnp0sEVfa',
                  'cn'               => 'nodes',
                  'sn'               => 'nodes',
                  'shadowLastChange' => '15140',
                  'shadowMin'        => '0',
                  'shadowMax'        => '99999',
                  'shadowWarning'    => '7',
                  'loginShell'       => '/bin/false',
                  'uidNumber'        => '801',
                  'gidNumber'        => '801',
                  'homeDirectory'    => '/home/nssproxy',
                }
}
