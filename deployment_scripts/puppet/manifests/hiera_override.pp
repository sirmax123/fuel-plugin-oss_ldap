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
notice('MODULAR: oss_ldap hiera_override.pp')

$hiera_dir            = '/etc/hiera/plugins'
$plugin_name          = 'oss_ldap'
$plugin_yaml          = "${plugin_name}.yaml"
$corosync_roles       = [$plugin_name, "primary-${plugin_name}"]
$oss_ldp              = hiera_hash('oss_ldap')
$network_metadata     = hiera('network_metadata')
$oss_ldap_nodes       = get_nodes_hash_by_roles($network_metadata, ['oss_ldap', 'primary-oss_ldap'])
$oss_ldap_nodes_count = count($oss_ldap_nodes)
$vip_name             = 'oss_ldap_vip_mgmt'

if ! $network_metadata['vips'][$vip_name] {
  fail('OSS LDAP VIP is not defined')
}
$vip = $network_metadata['vips'][$vip_name]['ipaddr']




$calculated_content = inline_template('
oss_ldap::corosync_roles:
<%
@corosync_roles.each do |crole|
%>  - <%= crole %>
<% end -%>

oss::ldap::vip: <%= @vip%>
')

file { "${hiera_dir}/${plugin_yaml}":
  ensure  => file,
  content => "${calculated_content}\n",
}
