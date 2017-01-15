# funct_systemctl_service
#
# Code to audit a service managed by systemctl, and enable, or disable
#
# service_name    = Name of service
# service_level   = Level service runs at
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

funct_systemctl_service () {
  use_systemctl="no"
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "Ubuntu" ] && [ "$os_version" = "16" ]; then
      use_systemctl="yes"
    fi
    if [ "$os_vendor" = "Centos" ]|| [ "$os_vendor" = "Red" ] && [ "$os_version" = "7" ]; then
      use_systemctl="yes"
    fi
  fi
  if [ "$os_name" = "Linux" ] && [ "$use_systemctl" = "yes" ]; then
    correct_status=$1
    service_name=$2
    if [ "$correct_status" = "enable" ] || [ "$correct_status" = "enabled" ]; then
      service_switch="enable"
      correct_status="enabled"
    else
      service_switch="disable"
      correct_status="disabled"
    fi
    log_file="systemctl.log"
    actual_status=`systemctl is-enabled $service_name`
    if [ "$actual_status" = "enabled" ] || [ "$actual_status" = "disabled" ]; then
      total=`expr $total + 1`
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  Service $service_name is $correct_status"
      fi
      if [ "$actual_status" != "$correct_status" ]; then
        if [ "$audit_mode" != 2 ]; then
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Service $service_name is not $correct_status [$insecure Warnings]"
            command_line="systemctl $service_name $service_switch"
            funct_verbose_message "" fix
            funct_verbose_message "$command_line" fix
            funct_verbose_message "" fix
          else
            if [ "$audit_mode" = 0 ]; then
              log_file="$work_dir/$log_file"
              echo "$service_name,$actual_status" >> $log_file
              echo "Setting:   Service $service_name to $correct_status"
              systemctl $service_name $service_switch
            fi
          fi
        fi
      else
        if [ "$audit_mode" != 2 ]; then
          if [ "$audit_mode" = 1 ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Service $service_name is $correct_status [$secure Passes]"
          fi
        fi
      fi
      if [ "$audit_mode" = 2 ]; then
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          check_status=`cat $restore_file |grep $service_name |cut -f2 -d","`
          if [ "$check_status" = "enabled" ] || [ "$check_status" = "disabled" ]; then
            if [ "$check_status" != "$actual_status" ]; then
              echo "Restoring: Service $service_name at run level $service_level to $check_status"
              if [ "$check_status" = "enable" ] || [ "$check_status" = "enabled" ]; then
                service_switch="enable"
              else
                service_switch="disable"
              fi
              systemctl $service_name $service_switch
            fi
          fi
        fi
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        total=`expr $total + 1`
        secure=`expr $secure + 1`
        echo "Notice:    Service $service_name is not installed [$score]"
      fi
    fi
  fi
}
