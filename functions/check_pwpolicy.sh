# check_pwpolicy
#
# Function to check pwpolicy output under OS X
#.

check_pwpolicy() {
  if [ "$os_name" = "Darwin" ]; then
    parameter_name=$1
    correct_value=$2
    log_file="$parameter_name.log"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Password Policy for \"$parameter_name\" is set to \"$correct_value\""
      if [ "$os_release" -ge 12 ]; then
        actual_value=`pwpolicy -getglobalpolicy |tr " " "\n" |grep "$parameter_name" |cut -f2 -d=`
      else
        if [ "$managed_node" = "Error" ]; then
          actual_value=`sudo pwpolicy -n /Local/Default -getglobalpolicy $parameter_name 2>&1 |cut -f2 -d=`
        else
          actual_value=`sudo pwpolicy -n -getglobalpolicy $parameter_name 2>&1 |cut -f2 -d=`
        fi
      fi
      if [ "$actual_value" != "$correct_value" ]; then
        increment_insecure "Password Policy for \"$parameter_name\" is not set to \"$correct_value\""
        log_file="$work_dir/$log_file"
        if [ "$os_release" -ge 12 ]; then
          lockdown_command "echo \"$actual_value\" > $log_file ; sudo pwpolicy -setglobalpolicy $parameter_name=$correct_value" "Password Policy for \"$parameter_name\" to \"$correct_value\""
        else
          if [ "$managed_node" = "Error" ]; then
            lockdown_command "echo \"$actual_value\" > $log_file ; sudo pwpolicy -n /Local/Default -setglobalpolicy $parameter_name=$correct_value" "Password Policy for \"$parameter_name\" to \"$correct_value\""
          else
            lockdown_command "echo \"$actual_value\" > $log_file ; sudo pwpolicy -n -setglobalpolicy $parameter_name=$correct_value" "Password Policy for \"$parameter_name\" to \"$correct_value\""
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          increment_secure "Password Policy for \"$parameter_name\" is set to \"$correct_value\""
        fi
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=`cat $log_file`
        if [ "$previous_value" != "$actual_value" ]; then
          if [ "$os_release" -ge 12 ]; then
            restore_command "sudo pwpolicy -setglobalpolicy $parameter_name=$previous_value" "Password Policy for \"$parameter_name\" to \"$correct_value\""
          else
            if [ "$managed_node" = "Error" ]; then
              restore_command "sudo pwpolicy -n /Local/Default -setglobalpolicy $parameter_name=$previous_value" "Password Policy for \"$parameter_name\" to \"$previous_value\""
            else
              restore_command "sudo pwpolicy -n -setglobalpolicy $parameter_name=$previous_value" "Restoring: Password Policy for \"$parameter_name\" to \"$previous_value\""
            fi
          fi
        fi
      fi
    fi
  fi
}
