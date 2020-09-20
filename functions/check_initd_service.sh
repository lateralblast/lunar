
# check_initd_service
#
# Code to audit an init.d service, and enable, or disable service
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

check_initd_service () {
  if [ "$os_name" = "SunOS" ]; then
    service_name=$1
    correct_status=$2
    log_file="initd.log"
    service_check=$( ls /etc/init.d | grep -c "^$service_name$" | sed 's/ //g' )
    if [ "$service_check" != 0 ]; then
      if [ "$correct_status" = "disabled" ]; then
        check_file="/etc/init.d/_$service_name"
        if [ -f "$check_file" ]; then
          actual_status="disabled"
        else
          actual_status="enabled"
        fi
      else
        check_file="/etc/init.d/$service_name"
        if [ -f "$check_file" ]; then
          actual_status="enabled"
        else
          actual_status="disabled"
        fi
      fi
      if [ "$audit_mode" != 2 ]; then
        string="If init.d service $service_name is $correct_status"
        verbose_message "$string"
        if [ "$ansible" = 1 ]; then
          echo ""
          echo "- name: Checking $string"
          echo "  service:"
          echo "    name: $service_name"
          echo "    enabled: $enabled"
          echo "  when: ansible_facts['ansible_system'] == '$os_name'"
          echo ""
        fi
      fi
      if [ "$actual_status" != "$correct_status" ]; then
        increment_insecure "Service $service_name is not $correct_status"
        log_file="$work_dir/$log_file"
        if [ "$correct_status" = "disabled" ]; then
          lockdown_command "echo \"$service_name,$actual_status\" >> $log_file ; /etc/init.d/$service_name stop ; mv /etc/init.d/$service_name /etc/init.d/_$service_name" "Service $service_name to $correct_status"
        else
          lockdown_command "echo \"$service_name,$actual_status\" >> $log_file ; mv /etc/init.d/_$service_name /etc/init.d/$service_name ; /etc/init.d/$service_name start" "Service $service_name to $correct_status"
        fi
      else
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/$log_file"
          if [ -f "$restore_file" ]; then
            check_name=$( grep $service_name $restore_file | cut -f1 -d"," )
            if [ "$check_name" = "$service_name" ]; then
              check_status=$( grep "$service_name" $restore_file | cut -f2 -d"," )
              if [ "$check_status" = "disabled" ]; then
                restore_command "/etc/init.d/$service_name stop ; mv /etc/init.d/$service_name /etc/init.d/_$service_name" "Service $service_name to $check_status"
              else
                restore_command "mv /etc/init.d/_$service_name /etc/init.d/$service_name ; /etc/init.d/$service_name start" "Restoring: Service $service_name to $check_status"
              fi
            fi
          fi
        else
          increment_secure "Service $service_name is $correct_status"
        fi
      fi
    fi
  fi
}
