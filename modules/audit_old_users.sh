# audit_old_users
#
# Audit users to check for accounts that have not been logged into etc
#.

audit_old_users () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Old users"
    never_count=0
    finger_bin=$( command -v finger 2> /dev/null )
    if [ "$audit_mode" = 2 ]; then
      check_file="/etc/shadow"
      restore_file $check_file $restore_dir
    else
      check_file="/etc/passwd"
      for user_name in $( grep -v "/usr/bin/false" $check_file | egrep -v "^halt|^shutdown|^root|^sync|/sbin/nologin" | cut -f1 -d: ); do
        check_file="/etc/shadow"
        shadow_field=$( grep "^$user_name:" $check_file | cut -f2 -d":" | egrep -v "\*|\!\!|NP|LK|UP" )
        if [ "$shadow_field" != "" ]; then
          if [ -f "$finger_bin" ]; then
            login_status=$( finger $user_name | grep "Never logged in" | awk '{print $1}' )
          else
            login_status=$( last $user_name | awk '{print $1}' | grep "$user_name" )
          fi
          if [ "$login_status" = "Never" ] || [ "$login_status" = "$user_name" ]; then
            if [ "$audit_mode" = 1 ]; then
              never_count=$( expr $never_count + 1 )
              
              
              if [ -f "$finger_bin" ]; then
                increment_insecure "User $user_name has never logged in and their account is not locked"
              else
                increment_insecure "User $user_name has not logged in recently and their account is not locked"
              fi
              verbose_message "" fix
              verbose_message "passwd -l $user_name" fix
              verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $check_file
              echo "Setting:   User $user_name to locked"
              passwd -l $user_name
            fi
          fi
        fi
      done
      if [ "$never_count" = 0 ]; then
        if [ "$audit_mode" = 1 ]; then
          increment_secure "There are no users who have never logged that do not have their account locked"
        fi
      fi
    fi
  fi
}
