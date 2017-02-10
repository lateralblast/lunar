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
      actual_status=`cat $check_file |grep $parameter_name |awk '{print $3}'`
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  If xinetd service $service_name has $parameter_name set to $correct_status"
        
        if [ "$actual_status" != "$correct_status" ]; then
          if [ "$audit_mode" = 1 ]; then
            
            increment_insecure "Service $service_name does not have $parameter_name set to $correct_status"
            if [ "$linux_dist" = "debian" ]; then
              command_line="update-rc.d $service_name $correct_status"
            else
              command_line="chkconfig $service_name $correct_status"
            fi
            verbose_message "" fix
            verbose_message "$command_line" fix
            verbose_message "" fix
          else
            if [ "$audit_mode" = 0 ]; then
              log_file="$work_dir/$log_file"
              echo "$parameter_name,$actual_status" >> $log_file
              echo "Setting:   Parameter $parameter_name for $service_name to $correct_status"
              backup_file $check_file
              if [ "$parameter_name" != "disable" ]; then
                cat $check_file |sed 's/$parameter_name.*/$parameter_name = $correct_status/g' > $temp_file
                cp $temp_file $check_file
              else
                if [ "$linux_dist" = "debian" ]; then
                  update-rc.d $service_name $correct_status
                else
                  chkconfig $service_name $correct_status
                fi
              fi
            fi
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            
            increment_secure "Service $service_name has $parameter_name set to $correct_status"
          fi
        fi
      else
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          check_name=`cat $restore_file |grep $service_name |cut -f1 -d","`
          if [ "$check_name" = "$service_name" ]; then
            check_status=`cat $restore_file |grep $service_name |cut -f2 -d","`
            if [ "$actual_status" != "$check_status" ]; then
              restore_file $check_file $restore_dir
            fi
          fi
        fi
      fi
    fi
  fi
}
