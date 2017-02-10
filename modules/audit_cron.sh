# audit_cron
#
# Refer to Section(s) 6.1.1 Page(s) 138-9 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.1.1 Page(s) 121-2 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 9.1.1 Page(s) 114-5 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.1.1 Page(s) 192   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 5.1.1 Page(s) 204   CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_cron () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Cron Daemon"
    service_name="crond"
    check_chkconfig_service $service_name 3 on
    check_chkconfig_service $service_name 5 on
    check_systemctl_service enable $service_name
    if [ "$anacron_enable" = "yes" ]; then
      service_name="anacron"
      check_chkconfig_service $service_name 3 on
      check_chkconfig_service $service_name 5 on
    fi
  fi
}
