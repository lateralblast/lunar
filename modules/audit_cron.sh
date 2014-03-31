# audit_cron_perms
#
# While there may not be user jobs that need to be run on the system,
# the system does have maintenance jobs that may include security
# monitoring that have to run and cron to execute them.
#
# Refer to Section(s) 6.1.1-2 Page(s) 138-9 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.1.1-2 Page(s) 121-2 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

audit_cron_perms () {
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
