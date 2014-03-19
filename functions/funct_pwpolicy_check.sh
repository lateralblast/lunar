# funct_pwpolicy_check
#
# Function to check pwpolicy output under OS X
#.

funct_pwpolicy_check() {
  if [ "$os_name" == "Darwin" ]; then
    parameter_name=$1
    correct_value=$2
    log_file="$parameter_name.log"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Password Policy for \"$parameter_name\" is set to \"$correct_value\""
      if [ "$managed_node" == "Error" ]; then
        actual_value=`sudo pwpolicy -n /Local/Default -getglobalpolicy $parameter_name 2>&1 |cut -f2 -d=`
      else
        actual_value=`sudo pwpolicy -n -getglobalpolicy $parameter_name 2>&1 |cut -f2 -d=`
      fi
      if [ "$actual_value" != "$correct_value" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score - 1`
          echo "Warning:   Password Policy for \"$parameter_name\" is not set to \"$correct_value\" [$score]"
          funct_verbose_message "" fix
          if [ "$managed_node" == "Error" ]; then
            funct_verbose_message "sudo pwpolicy -n /Local/Default -setglobalpolicy $parameter_name=$correct_value" fix
          else
            funct_verbose_message "sudo pwpolicy -n -setglobalpolicy $parameter_name=$correct_value" fix
          fi
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          log_file="$work_dir/$log_file"
          echo "Setting:   Password Policy for \"$parameter_name\" to \"$correct_value\""
          echo "$actual_value" > $log_file
          if [ "$managed_node" == "Error" ]; then
            sudo pwpolicy -n /Local/Default -setglobalpolicy $parameter_name=$correct_value
          else
            sudo pwpolicy -n -setglobalpolicy $parameter_name=$correct_value
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    Password Policy for \"$parameter_name\" is set to \"$correct_value\" [$score]"
        fi
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=`cat $log_file`
       if [ "$previous_value" != "$actual_value" ]; then
          echo "Restoring: Password Policy for \"$parameter_name\" to \"$previous_value\""
          if [ "$managed_node" == "Error" ]; then
            sudo pwpolicy -n /Local/Default -setglobalpolicy $parameter_name=$previous_value
          else
            sudo pwpolicy -n -setglobalpolicy $parameter_name=$previous_value
          fi
        fi
      fi
    fi
  fi
}
