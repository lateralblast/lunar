# check_trust
#
# Function to check trustchk under AIX
#.

check_trust() {
  if [ "$os_name" = "AIX" ]; then
    parameter_name=$1
    correct_value=$2
    log_file="trustchk_$parameter_name.log"
    actual_value=`trustchk -p $parameter_name |cut -f2 -d=`
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Trusted Execution setting for \"$parameter_name\" is set to \"$correct_value\""
      if [ "$actual_value" != "$correct_value" ]; then
        increment_insecure "Trusted Execution setting for \"$parameter_name\" is not set to \"$correct_value\""
        log_file="$work_dir/$log_file"
        lockdown_commans "echo \"trustchk-p $parameter_name=$actual_value\" > $log_file ; trustchk -p $parameter_name=$correct_value" "Trusted Execution setting for \"$parameter_name\" to \"$correct_value\""
      else
        increment_secure "Password Policy for \"$parameter_name\" is set to \"$correct_value\""
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
