# audit_wheel_sudo
#
# Check wheel group settings in sudoers
#.

audit_wheel_sudo () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    for check_dir in /etc /usr/local/etc /usr/sfw/etc /opt/csw/etc; do
      check_file="$check_dir/sudoers"
      if [ -f "$check_file" ]; then
        if [ "$audit_mode" != 2 ]; then
          nopasswd_check=`cat $check_file |grep $wheel_group |awk '{print $3}'`
          if [ "$nopasswd_check" = "NOPASSWD" ]; then
            if [ "$audit_mode" = 1 ]; then
              score=`expr $score - 1`
              echo "Warning:   Group $wheel_group does not require password to escalate privileges [$score]"
            fi
            if [ "$audit_mode" = 0 ]; then
              funct_backup_file $check_file
              echo "Setting:   User $user_name to locked"
              passwd -l $user_name
            fi
          fi
        else
          funct_restore_file $check_file $restore_dir
        fi
      fi
    done
  fi
}
