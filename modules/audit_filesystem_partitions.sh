# audit_filesystem_partitions
#
# Check filesystems are on separate partitions
#
# Refer to Section(s) 1.1.1,5,7,8,9   Page(s) 14-21     CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.1,5,7,8,9   Page(s) 15-22     CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.1,5,7,8,9   Page(s) 18-26     CIS RHEL 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.2,6-7       Page(s) 26-7,31-2 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.1.2.6-7       Page(s) 27-8,32-3 CIS Ubuntu LTS 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.1,5,7,8,9     Page(s) 14-21     CIS SLES 11 Benchmark v1.2.0
# Refer to Section(s) 2.1,5,7,8,9     Page(s) 14-21     CIS SLES 11 Benchmark v1.2.0
# Refer to Section(s) 1.1.2,6-7,11-13 Page(s) 24-6,35-7 CIS Amazon Linux Benchmark v2.0.0
#.

audit_filesystem_partitions() {
  if [ "$os_name" = "Linux" ]; then
    for filesystem in /tmp /var /var/log /var/log/audit /home; do
      verbose_message "Filesystem $filesystem is a separate filesystem"
      mount_test=$( df |awk '{print $6}' | grep "^$filesystem$" )
      if [ "$mount_test" = "$filesystem" ]; then
        increment_secure "Filesystem $filesystem is a separate filesystem"
	    else
        increment_insecure "Filesystem $filesystem is not a separate filesystem"
      fi
    done
  fi
}
