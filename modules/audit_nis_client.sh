# audit_nis_client
#
# If the local site is not using the NIS naming service to distribute
# system and user configuration information, this service may be disabled.
# This service is disabled by default unless the NIS service has been
# configured on the system.
#
# Refer to Section(s) 2.5   Page(s) 18    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.2.3 Page(s) 24-5  CIS Solaris 10 Benchmrk v5.1.0
# Refer to Section(s) 2.1.5 Page(s) 58    CIS Red Hat Enterprise Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.5 Page(s) 53    CIS Red Hat Enterprise Linux 6 Benchmark v1.2.0
# Refer to Section(s) 2.3.1 Page(s) 123   CIS Red Hat Enterprise Linux 7 Benchmark v2.1.0
# Refer to Section(s) 5.1.2 Page(s) 41    CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.3.1 Page(s) 110-1 CIS Amazon Linux Benchmark v2.0.0
#.

audit_nis_client () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        funct_verbose_message "NIS Client Daemons"
        service_name="svc:/network/nis/client"
        funct_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      funct_verbose_message "NIS Client Daemons"
      service_name="ypbind"
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
      if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Amazon" ]; then
        funct_linux_package uninstall ypbind
      fi
    fi
  fi
}
