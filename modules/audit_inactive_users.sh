# audit_inactive_users
#
# Guidelines published by the U.S. Department of Defense specify that user
# accounts must be locked out after 35 days of inactivity. This number may
# vary based on the particular site's policy.
# Inactive accounts pose a threat to system security since the users are not
# logging in to notice failed login attempts or other anomalies.
#
# Refer to Section(s) 7.5 Page(s) 171-2 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 7.5 Page(s) 151-2 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 10.5 Page(s) 141 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.6 Page(s) 66-7 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 7.9 Page(s) 109-110 CIS Solaris 10 v5.1.0
#.

audit_inactive_users () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Inactive User Accounts"
    if [ "$os_name" = "SunOS" ]; then
      check_file="/usr/sadm/defadduser"
      funct_file_value $check_file definact eq 35 hash
    fi
    check_file="/etc/shadow"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Lockout status for inactive user accounts"
      total=`expr $total + 1`
      for user_check in `cat $check_file |grep -v 'nobody4' |grep -v 'root'` ; do
        total=`expr $total + 1`
        inactive_check=`echo $user_check |cut -f 7 -d":"`
        user_name=`echo $user_check |cut -f 1 -d":"`
        if [ "$inactive_check" = "" ]; then
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score - 1`
            echo "Warning:   Inactive lockout not set for $user_name [$score]"
            funct_verbose_message "" fix
            funct_verbose_message "usermod -f 35 $user_name" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Saving:    File $check_file to $work_dir$check_file"
            find $check_file | cpio -pdm $work_dir 2> /dev/null
            echo "Setting:   Inactive lockout for $user_name [$score]"
            usermod -f 35 $user_name
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            score=`expr $score + 1`
            echo "Secure:    Inactive lockout set for $user_name [$score]"
          fi
        fi
      done
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
