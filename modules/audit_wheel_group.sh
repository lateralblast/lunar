# audit_wheel_group
#
# Make sure there is a wheel group so privileged account access is limited.
#.

audit_wheel_group () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    check_file="/etc/group"
    verbose_message "Wheel Group"
    if [ "$audit_mode" != 2 ]; then
      total=`expr $total + 1`
      check_value=`cat $check_file |grep '^$wheel_group:'`
      if [ "$check_value" != "$search_string" ]; then
        if [ "$audit_mode" = "1" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Wheel group does not exist in $check_file [$insecure Warnings]"
        fi
        if [ "$audit_mode" = 0 ]; then
          backup_file $check_file
          echo "Setting:   Adding $wheel_group group to $check_file"
          groupadd $wheel_group
          usermod -G $wheel_group root
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Wheel group exists in $check_file [$secure Passes]"
        fi
      fi
    else
      restore_file $check_file $restore_dir
    fi
  fi
}
