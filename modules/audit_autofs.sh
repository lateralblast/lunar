# audit_autofs
#
# Refer to Section(s) 2.9    Page(s) 21 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 1.1.22 Page(s) 47 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.1.21 Page(s) 45 CIS Ubuntu LTS 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.2.10 Page(s) verbose_message " CIS Solaris 10 v5.1.0
# Refer to Section(s) 2.25   Page(s) 31 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.1.19 Page(s) 43 CIS Amazon Linux Benchmark v2.0.0
#.

audit_autofs () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Automount services"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/system/filesystem/autofs"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      service_name="autofs"
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
      check_systemctl_service disable $service_name
    fi
  fi
}
