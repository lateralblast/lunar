# audit_root_default_group
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

audit_root_default_group () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Default Group for root Account"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Root default group"
    fi
    group_check=`grep root /etc/passwd | cut -f4 -d":"`
    log_file="$work_dir/rootgroup.log"
    total=`expr $total + 1`
    if [ "$group_check" != 0 ]; then
      if [ "$audit_mode" = 1 ]; then
        score=`expr $score - 1`
        echo "Warning:   Root default group incorrectly set [$score]"
        funct_verbose_message "" fix
        funct_verbose_message "passmgmt -m -g 0 root" fix
        funct_verbose_message "" fix
      fi
      if [ "$audit_mode" = 0 ]; then
        echo "$group_check" >> $log_file
        echo "Setting:   Root default group correctly"
        passmgmt -m -g 0 root
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        score=`expr $score + 1`
        echo "Secure:    Root default group correctly set [$score]"
      fi
    fi
    if [ "$audit_mode" = 2 ]; then
      restore_file="$restore_dir/rootgroup.log"
      if [ -f "$restore_file" ]; then
        $group_check=`cat $restore_file`
        echo "Restoring: Root default group $group_check"
        passmgmt -m -g $group_check root
      fi
    fi
  fi
}
