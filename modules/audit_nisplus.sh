# audit_nisplus
#
# NIS+ was designed to be a more secure version of NIS. However,
# the use of NIS+ has been deprecated by Oracle and customers are
# encouraged to use LDAP as an alternative naming service.
# This service is disabled by default unless the NIS+ service has
# been configured on the system.
#
# Refer to Section(s) 2.2.4 Page(s) 25 CIS Solaris 10 Benchmark v5.1.0
#.

audit_nisplus () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "NIS+ Daemons"
      service_name="svc:/network/rpc/nisplus"
      funct_service $service_name disabled
    fi
  fi
}
