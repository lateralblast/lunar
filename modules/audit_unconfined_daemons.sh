# audit_unconfined_daemons
#
# Refer to Section(s) 1.4.6   Page(s) 40   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.4.6   Page(s) 45-6 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.4.6   Page(s) 43   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.6.1.4 Page(s) 68   CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_unconfined_daemons () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Unconfined Daemons"
    daemon_check=`ps -eZ | egrep "initrc" | egrep -vw "tr|ps|egrep|bash|awk" | tr ':' ' ' | awk '{ print $NF }'`
    total=`expr $total + 1`
    if [ "$daemon_check" = "" ]; then
      if [ "$audit_mode" = 1 ]; then
        insecure=`expr $insecure + 1`
        echo "Warning:   Unconfined daemons $daemon_check [$insecure Warnings]"
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        secure=`expr $secure + 1`
        echo "Secure:    No unconfined daemons [$secure Passes]"
      fi
    fi
  fi
}
