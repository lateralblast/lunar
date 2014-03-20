# audit_aide
#
# In some installations, AIDE is not installed automatically.
# Install AIDE to make use of the file integrity features to monitor critical
# files for changes that could affect the security of the system.
#
# Refer to Section 1.3.1,2 Page(s) 34-35 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_aide () {
  if [ "$os_name" = "Linux" ]; then
    check_file="/etc/sysconfig/prelink"
    if [ -f "$check_file" ]; then
      prelink_check=`cat $check_file |grep PRELINKING |cut -f2 -d= |sed 's/ //g'`
    else
      prelink_check="no"
    fi
    if [ "$prelink_check" = "no" ]; then
      funct_verbose_message "AIDE"
      audit_linux_package install aide
      audit_append_file /etc/cron.d/aide "0 5 * * * /usr/sbin/aide --check"
    fi
  fi
}
