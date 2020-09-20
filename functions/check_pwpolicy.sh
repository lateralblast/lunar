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
      string="Password Policy for $parameter_name is set to $correct_value"
      verbose_message "$string"
      if [ "$os_release" -ge 12 ]; then
        a_command="pwpolicy -getglobalpolicy |tr ' ' '\\\n' |grep $parameter_name |cut -f2 -d="
        actual_value=$( pwpolicy -getglobalpolicy |tr " " "\n" |grep "$parameter_name" |cut -f2 -d= )
      else
        if [ "$managed_node" = "Error" ]; then
          a_command=$( sudo pwpolicy -n /Local/Default -getglobalpolicy $parameter_name 2>&1 |cut -f2 -d= )
          actual_value=$( sudo pwpolicy -n /Local/Default -getglobalpolicy $parameter_name 2>&1 |cut -f2 -d= )
        else
          a_command='sudo pwpolicy -n -getglobalpolicy $parameter_name 2>&1 |cut -f2 -d='
          actual_value=$( sudo pwpolicy -n -getglobalpolicy $parameter_name 2>&1 |cut -f2 -d= )
        fi
        actual_value=$( $a_command )
      fi
      if [ "$actual_value" != "$correct_value" ]; then
        increment_insecure "Password Policy for \"$parameter_name\" is not set to \"$correct_value\""
        log_file="$work_dir/$log_file"
        if [ "$os_release" -ge 12 ]; then
          l_command="sudo pwpolicy -setglobalpolicy $parameter_name=$correct_value"
          lockdown_command "echo \"$actual_value\" > $log_file ; sudo pwpolicy -setglobalpolicy $parameter_name=$correct_value" "Password Policy for \"$parameter_name\" to \"$correct_value\""
        else
          if [ "$managed_node" = "Error" ]; then
            l_command="sudo pwpolicy -n /Local/Default -setglobalpolicy $parameter_name=$correct_value"
            lockdown_command "echo \"$actual_value\" > $log_file ; sudo pwpolicy -n /Local/Default -setglobalpolicy $parameter_name=$correct_value" "Password Policy for \"$parameter_name\" to \"$correct_value\""
          else
            l_command="sudo pwpolicy -n -setglobalpolicy $parameter_name=$correct_value"
            lockdown_command "echo \"$actual_value\" > $log_file ; sudo pwpolicy -n -setglobalpolicy $parameter_name=$correct_value" "Password Policy for \"$parameter_name\" to \"$correct_value\""
          fi
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
        if [ "$audit_mode" = 1 ]; then
          increment_secure "Password Policy for \"$parameter_name\" is set to \"$correct_value\""
        fi
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=$( cat $log_file )
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
