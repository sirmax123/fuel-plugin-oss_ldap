class ldap_config() {
  notice('CLASS: ldap_config')

  $ldap_ssl_cert_dir        = "/etc/ldap/ssl"
  $olcTLSCertificateFile    = "/etc/ldap/ssl/ldap.crt"
  $olcTLSCertificateKeyFile = "/etc/ldap/ssl/ldap.key"
  $olcTLSCACertificateFile  = "/etc/ssl/certs/rootca.crt"



  $database = "dc=fuel_domain"
  $rootdn   = 'cn=admin,dc=fuel_domain'
  $rootpw   = "r00tme"


  $ldapmodify_ldapi         = "/usr/bin/ldapmodify -Y EXTERNAL  -H ldapi://"

  $check_if_olcRootPW_exist = '/usr/bin/ldapsearch -Y EXTERNAL  -H ldapi://   -b cn=config  "olcDatabase=config" olcRootPW -LLL | /bin/grep olcRootPW'
  $check_if_olcRootDN_exist = '/usr/bin/ldapsearch -Y EXTERNAL  -H ldapi://   -b cn=config  "olcDatabase=config" olcRootDN -LLL | /bin/grep olcRootDN'



  $check_if_Moduel_exist        = '/usr/bin/ldapsearch -Y EXTERNAL  -H ldapi://  -b cn=config   "cn=module{*}"        | /bin/grep --color -E "olcModuleLoad: .*syncprov"'
  $check_if_Overley_exist       = '/usr/bin/ldapsearch -Y EXTERNAL  -H ldapi://  -b cn=config   "olcOverlay=syncprov" | /bin/grep --color -E "olcOverlay: .*syncprov"'
  $check_if_ServerID_exist      = '/usr/bin/ldapsearch -Y EXTERNAL  -H ldapi://  -b cn=config   "cn=config"           | /bin/grep --color -E "olcServerID: [0-9].*"'
  $check_if_ReplicaConfig_exist = '/usr/bin/ldapsearch -Y EXTERNAL  -H ldapi://  -b cn=config   "olcDatabase=config"  | /bin/grep --color -E "olcSyncrepl: {[0-1]}rid=00[0-9] provider=ldaps://ldap[1-2]"'
  $check_if_ReplicaDomain_exist = '/usr/bin/ldapsearch -Y EXTERNAL  -H ldapi://  -b cn=config   "olcDatabase={1}hdb"  | /bin/grep --color -E "olcSyncrepl: {[0-1]}rid=10[0-9] provider=ldaps://ldap[1-2]"'

}

# Wrapper for ldap_entry call
class ldap_create_object(
  $ldap_entry  = undef,
  $attributes  = undef,
#
  $ensure      = 'present',
  $base        = 'dc=fuel_domain',
  $host        = '127.0.0.1',
  $port        = '636',
  $self_signed = true,
  $username    = 'cn=admin,dc=fuel_domain',
  $password    = $ldap_config_rootpw,
) {

  notify { "LDAP Object $ldap_entry": }

  ldap_entry { $ldap_entry:
    ensure      => $ensure,
    base        => $base,
    host        => $host,
    port        => $port,
    self_signed => $self_signed,
    username    => $username,
    password    => $password,
    attributes  => $attributes,
  }
}