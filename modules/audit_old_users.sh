# audit_old_users
#
# Audit users to check for accounts that have not been logged into etc
#.

audit_old_users () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    never_count=0
    if [ "$audit_mode" = 2 ]; then
      check_file="/etc/shadow"
      funct_restore_file $check_file $restore_dir
    else
      check_file="/etc/passwd"
      for user_name in `cat $check_file |grep -v "/usr/bin/false" |egrep -v "^halt|^shutdown|^root|^sync|/sbin/nologin" |cut -f1 -d:`; do
        check_file="/etc/shadow"
        shadow_field=`cat $check_file |grep "^$user_name:" |cut -f2 -d":" |egrep -v "\*|\!\!|NP|LK|UP"`
        if [ "$shadow_field" != "" ]; then
          login_status=`finger $user_name |grep "Never logged in" |awk '{print $1}'`
          if [ "$login_status" = "Never" ]; then
            if [ "$audit_mode" = 1 ]; then
              never_count=`expr $never_count + 1`
              total=`expr $total + 1`
              score=`expr $score - 1`
              echo "Warning:   User $user_name has never logged in and their account is not locked [$score]"
              funct_verbose_message "" fix
              funct_verbose_message "passwd -l $user_name" fix
              funct_verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              funct_backup_file $check_file
              echo "Setting:   User $user_name to locked"
              passwd -l $user_name
            fi
          fi
        fi
      done
      if [ "$never_count" = 0 ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    No user has never logged in and their account is not locked [$score]"
        fi
      fi
    fi
  fi
}
