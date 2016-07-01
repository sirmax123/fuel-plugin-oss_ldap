notice('MODULAR: 180')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database






class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'uid=test_user,ou=People,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                  'objectClass' => [ "top", "person", "organizationalPerson", "inetOrgPerson",  "posixAccount",  "shadowAccount" ],
                  'uid' => 'test_user',
                  'cn' => 'Test User',
                  'sn' => 'Test',
                  'givenName' => 'User',
                  'title' => 'Test User',
                  'telephoneNumber' => '+1-650-963-9828',
                  'mobile' => ' +1-650-963-9828',
                  'postalAddress' => '525 Almanor Ave, 4th Floor Sunnyvale, CA 94085',
                  'userPassword' => '{CRYPT}$6$DS/mzad5$EB.cNCLE7KB7OCPK1nU6aEA8HnQDLY1FPd3KaWPVqaNBtWhmh/4cOUgD1I8tQSFu41yy7jMXDrg9TDqlAbuLX',
                  'labeledURI' => 'https://github.com/sirmax123/fuel-plugin-oss_ldap',
                  'loginShell' => '/usr/bin/sudosh',
                  'uidNumber' => '9999',
                  'gidNumber' => '9999',
                  'homeDirectory' => '/home/test_user',
                  'description' => 'This is me :)',
                 }
}
