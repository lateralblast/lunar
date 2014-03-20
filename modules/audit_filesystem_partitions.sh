# audit_filesystem_partitions
#
# Check filesystems are on separate partitions
#
# Refer to Section 1.1.1,5,7,8,9 Page(s) 14 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_filesystem_partitions() {
  if [ "$os_name" = "Linux" ]; then
    for filesystem in /tmp /var /var/log /var/log/audit /home; do
      funct_verbose_message "Filesystem $filesystem is a separate partition"
      mount_test=`mount |awk '{print $3}' |grep "^filesystem$"`
      if [ "$mount_test" != "$filesystem" ]; then
        if [ "$audit_mode" != "2" ]; then
          if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
            score=`expr $score - 1`
            echo "Warning:   Filesystem $filesystem is not a separate partition [$score]"
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    Filesystem $filesystem is a separate filesystem [$score]"
          fi
        fi
      fi
    done
  fi
}
