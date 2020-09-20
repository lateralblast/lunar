# check_no
#
# Function to check no under AIX
#.

check_no() {
  if [ "$os_name" = "AIX" ]; then
    parameter_name=$1
    correct_value=$2
    log_file="$parameter_name.log"
    actual_value=$( no -a | grep '$parameter_name ' | cut -f2 -d= | sed 's/ //g' )
    if [ "$audit_mode" != 2 ]; then
      string="Parameter $parameter_name is $correct_value"
      verbose_message "$string"
      if [ "$ansible" = 1 ]; then
        echo ""
        echo "- name: Checking $string"
        echo "  command: sh -c \"no -a |grep '$parameter_name ' |cut -f2 -d= |sed 's/ //g' |grep '$correct_value'\""
        echo "  register: no_check"
        echo "  failed_when: no_check == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '$os_name'"
        echo ""
        echo "- name: Fixing $string"
        echo "  command: sh -c \"no -p -o $parameter_name=$correct_value\""
        echo "  when: no_check.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
        echo ""
      fi
      if [ "$actual_value" != "$correct_value" ]; then
        increment_insecure "Parameter \"$parameter_name\" is not \"$correct_value\""
        log_file="$work_dir/$log_file"
        lockdown_command "echo \"$actual_value\" > $log_file ; no -p -o $parameter_name=$correct_value" "Parameter \"$parameter_name\" to \"$correct_value\""
      else
        increment_secure "Parameter \"$parameter_name\" is \"$correct_value\""
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=$( cat $log_file )
        if [ "$previous_value" != "$actual_value" ]; then
          verbose_message "Restoring: Parameter \"$parameter_name\" to \"$previous_value\""
          no -p -o $parameter_name=$previous_value
        fi
      fi
    fi
  fi
}
