
echo "==============="
echo "Build SSL certs"
echo "For all evs. we have one set of keys/certs"
echo "will be changed for Fuel 9 "
echo "==============="

pushd /var/www/nailgun/plugins/oss_ldap-1.0/deployment_scripts/puppet/modules/ldap_ssl/files/
/var/www/nailgun/plugins/oss_ldap-1.0/deployment_scripts/puppet/modules/ldap_ssl/files/000_root_ca.sh
popd