# audit_wheel_group
#
# Make sure there is a wheel group so privileged account access is limited.
#.

audit_wheel_group () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    check_file="/etc/group"
    funct_verbose_message "Wheel Group"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Wheel group exists in $check_file"
      total=`expr $total + 1`
      check_value=`cat $check_file |grep '^$wheel_group:'`
      if [ "$check_value" != "$search_string" ]; then
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score - 1`
          echo "Warning:   Wheel group does not exist in $check_file [$score]"
        fi
        if [ "$audit_mode" = 0 ]; then
          funct_backup_file $check_file
          echo "Setting:   Adding $wheel_group group to $check_file"
          groupadd $wheel_group
          usermod -G $wheel_group root
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          score=`expr $score + 1`
          echo "Secure:    Wheel group exists in $check_file [$score]"
        fi
      fi
    else
      funct_restore_file $check_file $restore_dir
    fi
  fi
}
