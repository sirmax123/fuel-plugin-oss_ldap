#    Copyright 2015 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#
notice('MODULAR: oss_ldap haproxy.pp')

$role_name = 'oss_ldap'
$ldap_port = '636'
$vip = hiera('oss::ldap::vip')
$roles = [ $role_name , "primary-${role_name}"]
$oss_ldap_nodes = get_nodes_hash_by_roles(hiera_hash('network_metadata'), $roles)
$oss_ldap_address_map = get_node_to_ipaddr_map_by_network_role($oss_ldap_nodes, 'oss_ldap')
$oss_ldap_nodes_ips = values($oss_ldap_address_map)
$oss_ldap_nodes_names = keys($oss_ldap_address_map)
notice($oss_ldap_address_map)
notice($os_ldap_nodes_ips)

Openstack::Ha::Haproxy_service {
  server_names        => $oss_ldap_nodes_names,
  ipaddresses         => $pss_ldap_nodes_ips,
  public              => false,
  public_ssl          => false,
  internal            => true,
  internal_virtual_ip => $vip,
}

openstack::ha::haproxy_service { 'oss_ldap':
  order                  => '920',
  listen_port            => $ldap_port,
  balancermember_port    => $ldap_port,
  server_names           => ["ldap1","ldap2"],
#  balancermember_options => 'check inter 10s fastinter 2s downinter 3s rise 3 fall 3',
#  haproxy_config_options => {
#    'option'  => [],
#    'balance' => 'first',
#    'mode'    => 'tcp',
#  }
  haproxy_config_options => {
    'option'         => ['tcplog','clitcpka','srvtcpka', 'ldap-check'],
    'balance'        => 'first',
    'mode'           => 'tcp',
    'timeout server' => '28801s',
    'timeout client' => '28801s'
  },
  balancermember_options => 'check inter 20s fastinter 2s downinter 2s rise 3 fall 3',

}



### example from ldap-ad plugin, tmp, MBF!
#$plugin_name           = "openldap-ad"
#notice("MODULAR: ${plugin_name}/openldap_haproxy.pp")
#
#$plugin_settings       = hiera($plugin_name, false)
#
#if $plugin_settings {
#  $internal_virtual_ip = hiera('management_vip')
#  $nodes_array         = hiera_array('nodes')
#  $server_names        = nodes_with_roles($nodes_array, ['primary-controller', 'controller'], 'name')
#  $ipaddresses         = nodes_with_roles($nodes_array, ['primary-controller', 'controller'], 'internal_address')
#
#  openstack::ha::haproxy_service { 'openldap':
#    internal_virtual_ip => $internal_virtual_ip,
#    ipaddresses         => $ipaddresses,
#    server_names        => $server_names,
#    order                  => '177',
#    listen_port            => 389,
#    balancermember_port    => 389,
#    define_backups         => true,
#    haproxy_config_options => {
#      'option'         => ['tcplog','clitcpka','srvtcpka', 'ldap-check'],
#      'balance'        => 'leastconn',
#      'mode'           => 'tcp',
#      'timeout server' => '28801s',
#      'timeout client' => '28801s'
#    },
#    balancermember_options => 'check inter 20s fastinter 2s downinter 2s rise 3 fall 3',
#  }
#
#}
