# audit_cron
#
# While there may not be user jobs that need to be run on the system,
# the system does have maintenance jobs that may include security
# monitoring that have to run and cron to execute them.
#
# Refer to Section(s) 6.1.1 Page(s) 138-9 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.1.1 Page(s) 121-2 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 9.1.1 Page(s) 114-5 SLES 11 Benchmark v1.0.0
#.

audit_cron () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Cron Daemon"
    service_name="crond"
    funct_chkconfig_service $service_name 3 on
    funct_chkconfig_service $service_name 5 on
    if [ "$anacron_enable" = "yes" ]; then
      service_name="anacron"
      funct_chkconfig_service $service_name 3 on
      funct_chkconfig_service $service_name 5 on
    fi
  fi
}
