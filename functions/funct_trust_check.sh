# funct_trust_check
#
# Function to check trustchk under AIX
#.

funct_trust_check() {
  if [ "$os_name" == "AIX" ]; then
    parameter_name=$1
    correct_value=$2
    log_file="trustchk_$parameter_name.log"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Trusted Execution setting for \"$parameter_name\" is set to \"$correct_value\""
      actual_value=`trustchk -p $parameter_name |cut -f2 -d=`
      if [ "$actual_value" != "$correct_value" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          insecure=`expr $insecure + 1`
          echo "Warning:   Trusted Execution setting for \"$parameter_name\" is not set to \"$correct_value\" [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "trustchk -p $parameter_name=$correct_value" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          log_file="$work_dir/$log_file"
          echo "Setting:   Trusted Execution setting for \"$parameter_name\" to \"$correct_value\""
          echo "trustchk-p $parameter_name=$actual_value" > $log_file
          trustchk -p $parameter_name=$correct_value
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          secure=`expr $secure + 1`
          echo "Secure:    Password Policy for \"$parameter_name\" is set to \"$correct_value\" [$secure Passes]"
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
