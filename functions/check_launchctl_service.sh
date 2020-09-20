# check_launchctl_service
#
# Function to check launchctl output under OS X
#.

check_launchctl_service () {
  if [ "$os_name" = "Darwin" ]; then
    launchctl_service=$1
    required_status=$2
    log_file="$launchctl_service.log"
    if [ "$required_status" = "on" ] || [ "$required_status" = "enable" ]; then
      required_status="enabled"
      change_status="load"
    else
      required_status="disabled"
      change_status="unload"
    fi
    check_value=$( launchctl list |grep $launchctl_service | awk '{print $3}' )
    if [ "$check_value" = "$launchctl_service" ]; then
      actual_status="enabled"
    else
      actual_status="disabled"
    fi
    if [ "$audit_mode" != 2 ]; then
      string="Service $launchctl_service is $required_status"
      verbose_message "$string"
      if [ "$ansible" = 1 ]; then
        echo ""
        echo "- name: Checking $string"
        echo "  command: sh -c \"launchctl list |grep $launchctl_service |awk '{print \$3}'\""
        echo "  register: launchd_check"
        echo "  failed_when: launchd_check == 1"
        echo "  changed_when: false"
        echo "  ignore_errors: true"
        echo "  when: ansible_facts['ansible_system'] == '$os_name'"
        echo ""
        echo "- name: Fixing $string"
        echo "  command: sh -c \"sudo launchctl $change_status -w $launchctl_service.plist\""
        echo "  when: launchd_check.rc == 1 and ansible_facts['ansible_system'] == '$os_name'"
        echo ""
      fi
      if [ "$actual_status" != "$required_status" ]; then
        increment_insecure "Service $launchctl_service is $actual_status"
        log_file="$work_dir/$log_file"
        lockdown_command "echo \"$actual_status\" > $log_file ; sudo launchctl $change_status -w $launchctl_service.plist" "Service $launchctl_service to $required_status"
      else
        increment_secure "Service $launchctl_service is $required_status"
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        restore_status=$( cat $log_file )
        if [ "$restore_status" = "enabled" ]; then
          change_status="load"
        else
          change_status="unload"
        fi
        if [ "$restore_status" != "$actual_status" ]; then
          sudo launchctl $change_status -w $launchctl_service.plist
        fi
      fi
    fi
  fi
}
