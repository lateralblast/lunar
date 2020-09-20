# check_systemctl_service
#
# Code to audit a service managed by systemctl, and enable, or disable
#
# service_name    = Name of service
# service_level   = Level service runs at
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

check_systemctl_service () {
  temp_status=$1
  temp_name=$2
  use_systemctl="no"
  if [ "$temp_name" = "on" ] || [ "$temp_name" = "off" ]; then
    correct_status=$temp_name 
    service_name=$temp_status
  else
    correct_status=$temp_status
    service_name=$temp_name
  fi
  if [ "$correct_status" = "enable" ] || [ "$correct_status" = "enabled" ] || [ "$correct_status" = "on" ]; then
    service_switch="enable"
    correct_status="enabled"
  else
    service_switch="disable"
    correct_status="disabled"
  fi
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "Ubuntu" ] && [ "$os_version" -ge 16 ]; then
      use_systemctl="yes"
    fi
    if [ "$os_vendor" = "Centos" ] || [ "$os_vendor" = "Red" ] && [ "$os_version" -ge 7 ]; then
      use_systemctl="yes"
    fi
  fi
  if [ "$use_systemctl" = "yes" ]; then
    log_file="systemctl.log"
    actual_status=$( systemctl is-enabled $service_name 2> /dev/null )
    if [ "$audit_mode" = 2 ]; then
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        check_status=$( grep $service_name $restore_file | cut -f2 -d"," )
        if [ "$check_status" = "enabled" ] || [ "$check_status" = "disabled" ]; then
          if [ "$check_status" != "$actual_status" ]; then
            verbose_message "Restoring: Service $service_name at run level $service_level to $check_status"
            if [ "$check_status" = "enable" ] || [ "$check_status" = "enabled" ]; then
              service_switch="enable"
            else
              service_switch="disable"
            fi
            systemctl $service_name $service_switch
          fi
        fi
      fi
    else
      string="Service $service_name is $correct_status"
      verbose_message "$string"
      if [ "$audit_mode" != 2 ]; then
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
      if [ "$actual_status" = "enabled" ] || [ "$actual_status" = "disabled" ]; then
        if [ "$actual_status" != "$correct_status" ]; then
          increment_insecure "Service $service_name is not $correct_status"
          log_file="$work_dir/$log_file"
          lockdown_command "echo \"$service_name,$actual_status\" >> $log_file ; systemctl $service_name $service_switch" "Service $service_name to $correct_status"
        else
          increment_secure "Service $service_name is $correct_status"
        fi
      fi
    fi
  fi
}
