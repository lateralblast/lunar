# audit_unconfined_daemons
#
# Refer to Section(s) 1.4.6   Page(s) 40   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.4.6   Page(s) 45-6 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.4.6   Page(s) 43   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.6.1.4 Page(s) 68   CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_unconfined_daemons () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Unconfined Daemons"
    daemon_check=$( ps -eZ 2> /dev/null | egrep "initrc" | egrep -vw "tr|ps|egrep|bash|awk" | tr ':' ' ' | awk '{ print $NF }' )
    if [ "$daemon_check" = "" ]; then
      if [ "$audit_mode" = 1 ]; then
        increment_insecure "Unconfined daemons $daemon_check"
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        increment_secure "No unconfined daemons"
      fi
    fi
  fi
}
