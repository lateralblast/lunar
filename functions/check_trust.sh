# check_trust
#
# Function to check trustchk under AIX
#.

check_trust() {
  if [ "$os_name" = "AIX" ]; then
    parameter_name=$1
    correct_value=$2
    log_file="trustchk_$parameter_name.log"
    actual_value=$( trustchk -p $parameter_name |cut -f2 -d= )
    a_command="trustchk -p $parameter_name | cut -f2 -d= | grep $correct_value"
    l_command="trustchk -p $parameter_name=$correct_value"
    if [ "$audit_mode" != 2 ]; then
      string="Trusted Execution setting for $parameter_name is set to $correct_value"
      verbose_message "$string"
      if [ "$actual_value" != "$correct_value" ]; then
        increment_insecure "Trusted Execution setting for \"$parameter_name\" is not set to \"$correct_value\""
        log_file="$work_dir/$log_file"
        lockdown_command "echo \"trustchk-p $parameter_name=$actual_value\" > $log_file ; trustchk -p $parameter_name=$correct_value" "Trusted Execution setting for \"$parameter_name\" to \"$correct_value\""
      else
        increment_secure "Password Policy for \"$parameter_name\" is set to \"$correct_value\""
      fi
      if [ "$ansible" = 1 ]; then
        echo ""
        echo "- name: Checking $string"
        echo "  command:  sh -c \"$a_command\""
        echo "  register: pwpolicy_check"
        echo "  failed_when: pwpolicy_check == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '$os_name'"
        echo ""
        echo "- name: Fixing $string"
        echo "  command: sh -c \"$l_command\""
        echo "  when: pwpolicy_check.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
        echo ""
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=$( cut -f2 -d= $log_file )
        if [ "$previous_value" != "$actual_value" ]; then
          verbose_message "Restoring: Password Policy for \"$parameter_name\" to \"$previous_value\""
          cat $log_file | sh
        fi
      fi
    fi
  fi
}
