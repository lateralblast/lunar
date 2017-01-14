# audit_wbem
#
# Web-Based Enterprise Management (WBEM) is a set of management and Internet
# technologies. Solaris WBEM Services software provides WBEM services in the
# Solaris OS, including secure access and manipulation of management data.
# The software includes a Solaris platform provider that enables management
# applications to access information about managed resources such as devices
# and software in the Solaris OS. WBEM is used by the Solaris Management
# Console (SMC).
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
