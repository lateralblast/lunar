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
# Refer to Section(s) 1.5.4-5 Page(s) 43-44 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.2 Page(s) 9 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.5.4-5 Page(s) 48-9 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.5.4-4 Page(s) 45-6 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

audit_sulogin () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "Single User Mode Requires Password"
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/ttys"
      check_string="console"
      ttys_test=`cat $check_file |grep $check_string |awk '{print $5}'`
      if [ "$ttys_test" != "insecure" ]; then
        if [ "$audit_mode" != 2 ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   Single user mode does not require a password [$score]"
          fi
          if [ "$audit_mode" = 2 ]; then
            echo "Setting:   Single user mode to require a password"
            backup_file $check_file
            tmp_file="/tmp/ttys_$check_string"
            awk '($4 == "console") { $5 = "insecure" } { print }' $check_file > $tmp_file
            cat $tmp_file > $check_file
          fi
        else
          funct_restore_file $check_file $restore_dir
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score + 1`
          echo "Secure:    Single user login requires password [$score]"
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/inittab"
      if [ -f "$check_file" ]; then
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
  fi
}
