notice('MODULAR: ldap_hosts.pp')

$hosts_file = '/etc/hosts'

Host {
    ensure => present,
    target => $hosts_file
}

$ldap_vip = hiera('oss::ldap::vip')


## LDAP cluster always has 2 nodes
## Add to /etc/hosts ldap1 ldap2 for nodes and ldap for ldap_vip address

host { 'ldap_vip':
  name         => ldap,
  ensure       => present,
  comment      => "ldap vip",
  ip           => $ldap_vip,
  target       => $hosts_file,
}


$ldap_node_1 = filter_nodes(hiera('nodes'), 'role', 'primary-oss_ldap')
$ldap_node_2 = filter_nodes(hiera('nodes'), 'role', 'oss_ldap')

$ldap_1_address = $ldap_node_1[0]['internal_address']
$ldap_2_address = $ldap_node_2[0]['internal_address']

host { 'ldap_1':
  name         => ldap1,
  ensure       => present,
  comment      => "ldap1",
  ip           => $ldap_1_address,
  target       => $hosts_file,
}

host { 'ldap_2':
  name         => ldap2,
  ensure       => present,
  comment      => "ldap2",
  ip           => $ldap_2_address,
  target       => $hosts_file,
}




