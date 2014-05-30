# audit_root_primary_group
#
# Set Default Group for root Account
# For Solaris 9 and earlier, the default group for the root account is the
# "other" group, which may be shared by many other accounts on the system.
# Solaris 10 has adopted GID 0 (group "root") as default group for the root
# account.
# If your system has been upgraded from an earlier version of Solaris, the
# password file may contain the older group classification for the root user.
# Using GID 0 for the root account helps prevent root-owned files from
# accidentally becoming accessible to non-privileged users.
#
# Refer to Section(s) 7.3 Page(s) 147 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.3 Page(s) 170 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 7.3 Page(s) 150 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 10.3 Page(s) 139-140 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.4 Page(s) 104-5 CIS Solaris 10 v5.1.0
#.

audit_root_primary_group () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Root Primary Group"
    log_file="root_primary_grooup.log"
    check_file="/etc/group"
    group_check=`grep "^root:" /etc/passwd | cut -f4 -d:`
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Primary group for root is root"
      if [ "$group_check" != "0" ];then
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Group $group_id does not exist in group file [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "usermod -g 0 root" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ];then
          log_file="$work_dir/$log_file"
          echo "$group_check" > $log_file
          echo "Setting:   Primary group for root to root"
          usermod -g 0 root
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Primary group for root is root [$secure Passes]"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -e "$restore_file" ]; then
        restore_value=`cat $restore_file`
        if [ "$restore_value" != "$group_check" ]; then
          echo "Restoring: Primary root group to $restore_value"
          usermod -g $restore_value root
        fi
      fi
    fi
  fi
}
