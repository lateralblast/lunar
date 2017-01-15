# funct_chkconfig_service
#
# Code to audit a service managed by chkconfig, and enable, or disbale
#
# service_name    = Name of service
# service_level   = Level service runs at
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

funct_chkconfig_service () {
  if [ "$os_name" = "VMkernel" ]; then
    service_name=$1
    correct_status=$2
    chk_config="/bin/chkconfig"
    log_file="chkconfig.log"
    actual_status=`$chk_config --list $service_name |awk '{print $2}'`
    if [ "$actual_status" = "on" ] || [ "$actual_status" = "off" ]; then
      total=`expr $total + 1`
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  Service $service_name is $correct_status"
      fi
      if [ "$actual_status" != "$correct_status" ]; then
        if [ "$audit_mode" != 2 ]; then
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Service $service_name is not $correct_status [$insecure Warnings]"
            command_line="$chk_config $service_name $correct_status"
            funct_verbose_message "" fix
            funct_verbose_message "$command_line" fix
            funct_verbose_message "" fix
          else
            if [ "$audit_mode" = 0 ]; then
              log_file="$work_dir/$log_file"
              echo "$service_name,$actual_status" >> $log_file
              echo "Setting:   Service $service_name to $correct_status"
              $chk_config $service_name $correct_status
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
          if [ "$check_status" = "on" ] || [ "$check_status" = "off" ]; then
            if [ "$check_status" != "$actual_status" ]; then
              echo "Restoring: Service $service_name at run level $service_level to $check_status"
              $chk_config --level $service_level $service_name $check_status
            fi
          fi
        fi
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        total=`expr $total + 1`
        secure=`expr $secure + 1`
        echo "Checking:  Service $service_name at run level $service_level"
        echo "Notice:    Service $service_name is not installed [$secure Passes]"
      fi
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    service_name=$1
    service_level=$2
    correct_status=$3
    if [ "$linux_dist" = "debian" ]; then
      chk_config="/usr/sbin/sysv-rc-conf"
    else
      chk_config="/usr/sbin/chkconfig"
    fi
    log_file="chkconfig.log"
    if [ "$service_level" = "3" ]; then
      actual_status=`$chk_config --list $service_name 2> /dev/null |awk '{print $5}' |cut -f2 -d':' |awk '{print $1}'`
    fi
    if [ "$service_level" = "5" ]; then
      actual_status=`$chk_config --list $service_name 2> /dev/null |awk '{print $7}' |cut -f2 -d':' |awk '{print $1}'`
    fi
    if [ "$actual_status" = "on" ] || [ "$actual_status" = "off" ]; then
      total=`expr $total + 1`
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  Service $service_name at run level $service_level is $correct_status"
      fi
      if [ "$actual_status" != "$correct_status" ]; then
        if [ "$audit_mode" != 2 ]; then
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Service $service_name at run level $service_level is not $correct_status [$insecure Warnings]"
            command_line="$chk_config --level $service_level $service_name $correct_status"
            funct_verbose_message "" fix
            funct_verbose_message "$command_line" fix
            funct_verbose_message "" fix
          else
            if [ "$audit_mode" = 0 ]; then
              log_file="$work_dir/$log_file"
              echo "$service_name,$service_level,$actual_status" >> $log_file
              echo "Setting:   Service $service_name at run level $service_level to $correct_status"
              $chk_config --level $service_level $service_name $correct_status
            fi
          fi
        fi
      else
        if [ "$audit_mode" != 2 ]; then
          if [ "$audit_mode" = 1 ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Service $service_name at run level $service_level is $correct_status [$secure Passes]"
          fi
        fi
      fi
      if [ "$audit_mode" = 2 ]; then
        restore_file="$restore_dir/$log_file"
        if [ -f "$restore_file" ]; then
          check_status=`cat $restore_file |grep $service_name |grep ",$service_level," |cut -f3 -d","`
          if [ "$check_status" = "on" ] || [ "$check_status" = "off" ]; then
            if [ "$check_status" != "$actual_status" ]; then
              echo "Restoring: Service $service_name at run level $service_level to $check_status"
              $chk_config --level $service_level $service_name $check_status
            fi
          fi
        fi
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        total=`expr $total + 1`
        secure=`expr $secure + 1`
        echo "Checking:  Service $service_name at run level $service_level"
        echo "Notice:    Service $service_name is not installed [$secure Passes]"
      fi
    fi
  fi
}
