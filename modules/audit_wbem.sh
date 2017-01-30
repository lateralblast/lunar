# audit_wbem
#
# Refer to Section(s) 2.1.6 Page(s) 21-2 CIS Solaris 10 Benchmark v5.1.0
#.

audit_wbem () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Web Based Enterprise Management"
      service_name="svc:/application/management/wbem"
      funct_service $service_name disabled
    fi
  fi
}
