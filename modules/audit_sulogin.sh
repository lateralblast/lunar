# audit_sulogin
#
# Check single user mode requires password.
#
# Permissions on /etc/inittab.
#
# With remote console access it is possible to gain access to servers as though
# you were in front of them, therefore entering single user mode should require
# a password.
#
# Refer to Section 1.5.4-5 Page(s) 43-44 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_sulogin () {
  if [ "$os_name" = "Linux" ]; then
    check_file="/etc/inittab"
    if [ -f "$check_file" ]; then
      funct_verbose_message "Single User Mode Requires Password"
      sulogin_check=`grep -l sulogin $check_file`
      total=`expr $total + 1`
      if [ "$sulogin_check" = "" ]; then
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score - 1`
          echo "Warning:   No Authentication required for single usermode [$score]"
          funct_verbose_message "" fix
          funct_verbose_message "cat $check_file |awk '{ print }; /^id:[0123456sS]:initdefault:/ { print \"~~:S:wait:/sbin/sulogin\" }' > $temp_file" fix
          funct_verbose_message "cat $temp_file > $check_file" fix
          funct_verbose_message "rm $temp_file" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          echo "Setting:   Single user mode to require authentication"
          funct_backup_file $check_file
          cat $check_file |awk '{ print }; /^id:[0123456sS]:initdefault:/ { print "~~:S:wait:/sbin/sulogin" }' > $temp_file
          cat $temp_file > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score + 1`
          echo "Secure:    Single usermode requires authentication [$score]"
        fi
        if [ "$audit_mode" = 2 ]; then
          funct_restore_file $check_file $restore_dir
        fi
        funct_check_perms $check_file 0600 root root
      fi
      check_file="/etc/sysconfig/init"
      funct_file_value $check_file SINGLE eq "/sbin/sulogin" hash
      funct_file_value $check_file PROMPT eq no hash
      funct_check_perms $check_file 0600 root root
    fi
  fi
}
