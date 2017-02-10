# check_trust
#
# Function to check trustchk under AIX
#.

check_trust() {
  if [ "$os_name" = "AIX" ]; then
    parameter_name=$1
    correct_value=$2
    log_file="trustchk_$parameter_name.log"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Trusted Execution setting for \"$parameter_name\" is set to \"$correct_value\""
      actual_value=`trustchk -p $parameter_name |cut -f2 -d=`
      if [ "$actual_value" != "$correct_value" ]; then
        if [ "$audit_mode" = 1 ]; then
          
          
          increment_insecure "Trusted Execution setting for \"$parameter_name\" is not set to \"$correct_value\""
          verbose_message "" fix
          verbose_message "trustchk -p $parameter_name=$correct_value" fix
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          log_file="$work_dir/$log_file"
          echo "Setting:   Trusted Execution setting for \"$parameter_name\" to \"$correct_value\""
          echo "trustchk-p $parameter_name=$actual_value" > $log_file
          trustchk -p $parameter_name=$correct_value
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          
          
          increment_secure "Password Policy for \"$parameter_name\" is set to \"$correct_value\""
        fi
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=`cat $log_file |cut -f2 -d=`
        if [ "$previous_value" != "$actual_value" ]; then
          echo "Restoring: Password Policy for \"$parameter_name\" to \"$previous_value\""
          cat $log_file |sh
        fi
      fi
    fi
  fi
}
