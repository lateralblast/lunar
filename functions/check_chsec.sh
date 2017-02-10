# check_chsec
#
# Function to check sec under AIX
#.

check_chsec() {
  if [ "$os_name" = "AIX" ]; then
    sec_file=$1
    sec_stanza=$2
    parameter_name=$3
    correct_value=$4
    log_file="$sec_file_$sec_stanza_$parameter_name.log"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Security Policy for \"$parameter_name\" is set to \"$correct_value\""
      actual_value=`lssec -f $sec_file -s $sec_stanza -a $parameter_name |awk '{print $2}' |cut -f2 -d=`
      if [ "$actual_value" != "$correct_value" ]; then
        increment_insecure "Security Policy for \"$parameter_name\" is not set to \"$correct_value\""
        log_file="$work_dir/$log_file"
        lockdown_command "echo \"chsec -f $sec_file -s $sec_stanza -a $parameter_name=$actual_value\" > $log_file ; chsec -f $sec_file -s $sec_stanza -a $parameter_name=$correct_value" "Security Policy for \"$parameter_name\" to \"$correct_value\""
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
