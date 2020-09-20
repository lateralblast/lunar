# check_svcadm_service
#
# Function to audit a svcadm service and enable or disable
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

check_svcadm_service () {
  if [ "$os_name" = "SunOS" ]; then
    service_name=$1
    correct_status=$2
    service_exists=$( svcs -a |grep "$service_name" | awk '{print $3}' )
    if [ "$audit_mode" = 2 ]; then
      restore_file="$restore_dir/$file_header.log"
      if [ -f "$restore_file" ]; then
        restore_status=$( grep "^$service_name" $restore_file | cut -f2 -d',' )
        if [ $( expr "$restore_status" : "[A-z]" ) = 1 ]; then
          if [ "$restore_status" != "$service_status" ]; then
            restore_status=$( echo $restore_status | sed 's/online/enable/g' | sed 's/offline/disable/g' )
            verbose_message "Restoring: Service $service_name to $restore_status""d"
            svcadm $restore_status $service_name
            svcadm refresh $service_name
          fi
        fi
      fi
    else
      if [ "$service_exists" = "$service_name" ]; then
        service_status=$( svcs -Ho state $service_name )
        file_header="svcadm"
        log_file="$work_dir/$file_header.log"
        string="Service $service_name is $correct_status"
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
        if [ "$service_status" != "$correct_status" ]; then
          increment_insecure "Service $service_name is enabled"
          lockdown_command "echo \"$service_name,$service_status\" >> $log_file ; inetadm -d $service_name ; svcadm refresh $service_name" "Service $service_name to $correct_status"
        else
          increment_secure "Service $service_name is already disabled"
        fi
      fi
    fi
  fi
}
