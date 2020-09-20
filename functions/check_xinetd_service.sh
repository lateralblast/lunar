# audit_xinetd_service
#
# Code to audit an xinetd service, and enable, or disable
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

audit_xinetd_service () {
  if [ "$os_name" = "Linux" ]; then
    service_name=$1
    parameter_name=$2
    correct_status=$3
    check_file="/etc/xinetd.d/$service_name"
    log_file="$work_dir/$service_name.log"
    if [ -f "$check_file" ]; then
      actual_status=$( grep $parameter_name $check_file | awk '{print $3}' )
      if [ "$audit_mode" != 2 ]; then
        string="If xinetd service $service_name has $parameter_name set to $correct_status"
        verbose_message "$string"
        if [ "$actual_status" != "$correct_status" ]; then
          if [ "$linux_dist" = "debian" ]; then
            command="update-rc.d $service_name $correct_status"
          else
            command="chkconfig $service_name $correct_status"
          fi
          increment_insecure "Service $service_name does not have $parameter_name set to $correct_status"
          log_file="$work_dir/$log_file"
          backup_file $check_file
          lockdown_command "echo \"$parameter_name,$actual_status\" >> $log_file ; cat $check_file |sed 's/$parameter_name.*/$parameter_name = $correct_status/g' > $temp_file ; cp $temp_file $check_file ; $command" "Service to $parameter_name"
          l_command "cat $check_file |sed 's/$parameter_name.*/$parameter_name = $correct_status/g' > $temp_file ; cp $temp_file $check_file ; $command"
        else
          increment_secure "Service $service_name has $parameter_name set to $correct_status"
        fi
        if [ "$ansible" = 1 ]; then
          echo ""
          echo "- name: Checking $string"
          echo "  command:  sh -c \"cat $check_file |grep $parameter_name |awk '{print \$3}'\""
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
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          check_name=$( grep $service_name $restore_file | cut -f1 -d"," )
          if [ "$check_name" = "$service_name" ]; then
            check_status=$( grep $service_name $restore_file | cut -f2 -d"," )
            if [ "$actual_status" != "$check_status" ]; then
              restore_file $check_file $restore_dir
            fi
          fi
        fi
      fi
    fi
  fi
}
