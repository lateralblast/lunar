# audit_aide
#
# In some installations, AIDE is not installed automatically.
# Install AIDE to make use of the file integrity features to monitor critical
# files for changes that could affect the security of the system.
#
# Refer to Section(s) 1.3.1-2 Page(s) 34-5  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.3.1-2 Page(s) 39-40 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.3.1-2 Page(s) 36-7  CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 8.3.1-2 Page(s) 112-3 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3.1-2 Page(s) 47-9  CIS Amazon Linux Benchmark v2.0.0
#.

audit_aide() {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Amazon" ]; then
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
      funct_linux_package uninstall prelink
    fi
  fi
}
