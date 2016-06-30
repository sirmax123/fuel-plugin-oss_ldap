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

Openstack::Ha::Haproxy_service {
  server_names        => [ 'ldap1', 'ldap2' ],
  ipaddresses         => [ 'ldap1', 'ldap2' ],
  public              => false,
  public_ssl          => false,
  internal            => true,
  internal_virtual_ip => $vip,
}

openstack::ha::haproxy_service { 'oss_ldap':
  order                  => '920',
  listen_port            => $ldap_port,
  balancermember_port    => $ldap_port,
  server_names           => [ 'ldap1', 'ldap2' ],

  haproxy_config_options => {
    'option'         => ['tcplog' ,'tcpka', 'ssl-hello-chk'],
    'balance'        => 'first',
    'mode'           => 'tcp',
    'timeout server' => '28801s',
    'timeout client' => '28801s'
  },
  balancermember_options => 'check inter 20s fastinter 2s downinter 2s rise 3 fall 3',

}


