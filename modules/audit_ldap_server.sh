# audit_ldap_server
#
# The Lightweight Directory Access Protocol (LDAP) was introduced as a
# replacement for NIS/YP. It is a service that provides a method for looking
# up information from a central database. The default client/server LDAP
# application for CentOS is OpenLDAP.
# If the server will not need to act as an LDAP client or server, it is
# recommended that the software be disabled.
#
# Refer to Section 3.7 Page(s) 63-64 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_ldap_server () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      funct_linux_package uninstall openldap-servers
    fi
  fi
}
