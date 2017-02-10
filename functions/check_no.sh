# check_no
#
# Function to check no under AIX
#.

check_no() {
  if [ "$os_name" = "AIX" ]; then
    parameter_name=$1
    correct_value=$2
    log_file="$parameter_name.log"
    actual_value=`no -a |grep '$parameter_name ' |cut -f2 -d= |sed 's/ //g'`
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Parameter \"$parameter_name\" is \"$correct_value\""
      if [ "$actual_value" != "$correct_value" ]; then
        if [ "$audit_mode" = 1 ]; then
          
          
          increment_insecure "Parameter \"$parameter_name\" is not \"$correct_value\""
          verbose_message "" fix
          verbose_message "no -p -o $parameter_name=$correct_value" fix
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          log_file="$work_dir/$log_file"
          echo "Setting:   Parameter \"$parameter_name\" to \"$correct_value\""
          echo "$actual_value" > $log_file
          no -p -o $parameter_name=$correct_value
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          
          
          increment_secure "Parameter \"$parameter_name\" is \"$correct_value\""
        fi
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=`cat $log_file`
        if [ "$previous_value" != "$actual_value" ]; then
          echo "Restoring: Parameter \"$parameter_name\" to \"$previous_value\""
          no -p -o $parameter_name=$previous_value
        fi
      fi
    fi
  fi
}
