# audit_wheel_users
#
# Check users in wheel group have recently logged in, if not lock them
#

audit_wheel_users () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    verbose_message "Wheel Users"
    check_file="/etc/group"
    if [ "$audit_mode" != 2 ]; then
      for user_name in $( grep '^$wheel_group:' $check_file | cut -f4 -d: | sed 's/,/ /g' ); do
        last_login=$( last -1 $user_name | grep '[a-z]' | awk '{print $1}' )
        if [ "$last_login" = "wtmp" ]; then
          lock_test=$( grep '^$user_name:' /etc/shadow | grep -v 'LK' | cut -f1 -d: )
          if [ "$lock_test" = "$user_name" ]; then
            if [ "$ansible" = 1 ]; then
              echo ""
              echo "- name: Checking password lock for $user_name"
              echo "  user:"
              echo "    name: $user_name"
              echo "    password_lock: yes"
              echo ""
            fi
            if [ "$audit_mode" = 1 ]; then
              increment_insecure "User $user_name has not logged in recently and their account is not locked"
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $check_file
              verbose_message "Setting:   User $user_name to locked"
              passwd -l $user_name
            fi
          fi
        fi
      done
    else
      restore_file $check_file $restore_dir
    fi
  fi
}
