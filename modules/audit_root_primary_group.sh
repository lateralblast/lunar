# audit_root_primary_group
#
# Refer to Section(s) 7.3   Page(s) 147     CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.3   Page(s) 170     CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 7.3   Page(s) 150     CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.4.3 Page(s) 253     CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 10.3  Page(s) 139-140 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.4.3 Page(s) 232     CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 7.4   Page(s) 104-5   CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 5.4.3 Page(s) 245     CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_root_primary_group () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Root Primary Group"
    log_file="root_primary_group.log"
    check_file="/etc/group"
    group_check=$( grep "^root:" /etc/passwd | cut -f4 -d: )
    if [ "$audit_mode" != 2 ]; then
      if [ "$group_check" != "0" ];then
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "Group $group_id does not exist in group file"
          verbose_message "" fix
          verbose_message "usermod -g 0 root" fix
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ];then
          log_file="$work_dir/$log_file"
          echo "$group_check" > $log_file
          verbose_message "Setting:   Primary group for root to root"
          usermod -g 0 root
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          increment_secure "Primary group for root is root"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -e "$restore_file" ]; then
        restore_value=$( cat $restore_file )
        if [ "$restore_value" != "$group_check" ]; then
          verbose_message "Restoring: Primary root group to $restore_value"
          usermod -g $restore_value root
        fi
      fi
    fi
  fi
}
