notice('MODULAR: 170')


include ::ldap_config

notice('DEBUG: ')

$ldap_config_rootpw   =  $::ldap_config::rootpw
$ldap_config_database = $::ldap_config::database





class { 'ldap_create_object':
  host        => 'ldap',
  ldap_entry  => 'cn=defaults,ou=sudo,ou=services,dc=customer_organization,dc=fuel_domain',
  attributes  => {
                  'objectClass' => [  "top", "sudoRole" ],
                  'cn'          =>  'defaults',
                  'description' =>  "Default sudoOptions go here",
                  'sudoOption'  =>  "env_reset",
                  'sudoOption'  =>  "mail_badpass",
                  'sudoOption'  =>  'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"',
                  'sudoOrder'   =>  "1",
                 }
}

