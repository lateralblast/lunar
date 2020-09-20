# check_chkconfig_service
#
# Code to audit a service managed by chkconfig, and enable, or disbale
#
# service_name    = Name of service
# service_level   = Level service runs at
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

check_chkconfig_service () {
  if [ "$os_name" = "VMkernel" ]; then
    service_name=$1
    correct_status=$2
    chk_config="/bin/chkconfig"
    log_file="chkconfig.log"
    actual_status=$( $chk_config --list $service_name | awk '{print $2}' )
    if [ "$audit_mode" = 2 ]; then
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        check_status=$( grep $service_name $restore_file | cut -f2 -d"," )
        if [ "$check_status" = "on" ] || [ "$check_status" = "off" ]; then
          if [ "$check_status" != "$actual_status" ]; then
            verbose_message "Restoring: Service $service_name at run level $service_level to $check_status"
            $chk_config --level $service_level $service_name $check_status
          fi
        fi
      fi
    else
      if [ "$actual_status" = "on" ] || [ "$actual_status" = "off" ]; then
       verbose_message "Service $service_name is $correct_status"
        if [ "$actual_status" != "$correct_status" ]; then
          increment_insecure "Service $service_name is not $correct_status"
          log_file="$work_dir/$log_file"
          lockdown_command "echo \"$service_name,$actual_status\" >> $log_file ; $chk_config $service_name $correct_status" "Service $service_name to $correct_status"
        else
          increment_secure "Service $service_name is $correct_status"
        fi
      fi
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    service_name=$1
    service_level=$2
    correct_status=$3
    if [ "$correct_status" = "on" ]; then
      enabled="yes"
    else
      enabled="no"
    fi
    if [ "$linux_dist" = "debian" ]; then
      chk_config="/usr/sbin/sysv-rc-conf"
    else
      chk_config="/usr/sbin/chkconfig"
      if [ ! -f "$chk_config" ]; then
        chk_config="/sbin/chkconfig"
      fi
    fi
    log_file="chkconfig.log"
    if [ "$service_level" = "3" ]; then
      actual_status=$( $chk_config --list $service_name 2> /dev/null | awk '{print $5}' | cut -f2 -d':' | awk '{print $1}' )
    fi
    if [ "$service_level" = "5" ]; then
      actual_status=$( $chk_config --list $service_name 2> /dev/null | awk '{print $7}' | cut -f2 -d':' | awk '{print $1}' )
    fi
    if [ "$audit_mode" = 2 ]; then
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        check_status=$( grep $service_name $restore_file | grep ",$service_level," | cut -f3 -d"," )
        if [ "$check_status" = "on" ] || [ "$check_status" = "off" ]; then
          if [ "$check_status" != "$actual_status" ]; then
            verbose_message "Restoring: Service $service_name at run level $service_level to $check_status"
            $chk_config --level $service_level $service_name $check_status
          fi
        fi
      fi
    else
      if [ "$actual_status" = "on" ] || [ "$actual_status" = "off" ]; then
        string="$service_name at run level $service_level is $correct_status"
       verbose_message "$string"
        if [ "$ansible" = 1 ]; then
          echo ""
          echo "- name: Checking $string"
          echo "  service:"
          echo "    name: $service_name"
          echo "    enabled: $enabled"
          echo ""
        fi
        if [ "$actual_status" != "$correct_status" ]; then
          increment_insecure "Service $service_name at run level $service_level is not $correct_status"
          log_file="$work_dir/$log_file"
          lockdown_command "echo \"$service_name,$service_level,$actual_status\" >> $log_file ; $chk_config --level $service_level $service_name $correct_status" "Service $service_name at run level $service_level to $correct_status"
        else
          increment_secure "Service $service_name at run level $service_level is $correct_status"
        fi
      fi
    fi
  fi
}
