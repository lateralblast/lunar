# funct_svcadm_service
#
# Function to audit a svcadm service and enable or disable
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

funct_svcadm_service () {
  if [ "$os_name" = "SunOS" ]; then
    service_name=$1
    correct_status=$2
    service_exists=`svcs -a |grep "$service_name" | awk '{print $3}'`
    if [ "$service_exists" = "$service_name" ]; then
      total=`expr $total + 1`
      service_status=`svcs -Ho state $service_name`
      file_header="svcadm"
      log_file="$work_dir/$file_header.log"
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  Service $service_name is $correct_status"
      fi
      if [ "$service_status" != "$correct_status" ]; then
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score - 1`
          echo "Warning:   Service $service_name is enabled [$score]"
          funct_verbose_message "" fix
          funct_verbose_message "inetadm -d $service_name" fix
          funct_verbose_message "svcadm refresh $service_name" fix
          funct_verbose_message "" fix
        else
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Service $service_name to $correct_status"
            echo "Notice:    Previous state stored in $log_file"
            echo "$service_name,$service_status" >> $log_file
            inetadm -d $service_name
            svcadm refresh $service_name
          fi
        fi
      else
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/$file_header.log"
          if [ -f "$restore_file" ]; then
            restore_status=`cat $restore_file |grep "^$service_name" |cut -f2 -d','`
            if [ `expr "$restore_status" : "[A-z]"` = 1 ]; then
              if [ "$restore_status" != "$service_status" ]; then
                restore_status=`echo $restore_status |sed 's/online/enable/g' |sed 's/offline/disable/g'`
                echo "Restoring: Service $service_name to $restore_status""d"
                svcadm $restore_status $service_name
                svcadm refresh $service_name
              fi
            fi
          fi
        else
          if [ "$audit_mode" != 2 ]; then
            if [ "$audit_mode" = 1 ]; then
              score=`expr $score + 1`
              echo "Secure:    Service $service_name is already disabled [$score]"
            fi
          fi
        fi
      fi
    fi
  fi
}
