
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
    service_check=`ls /etc/init.d |grep "^$service_name$" |wc -l |sed 's/ //g'`
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
        echo "Checking:  If init.d service $service_name is $correct_status"
      fi
      total=`expr $total + 1`
      if [ "$actual_status" != "$correct_status" ]; then
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Service $service_name is not $correct_status [$insecure Warnings]"
          verbose_message "" fix
          verbose_message "mv /etc/init.d/$service_name /etc/init.d/_$service_name" fix
          verbose_message "/etc/init.d/$service_name stop" fix
          verbose_message "" fix
        else
          if [ "$audit_mode" = 0 ]; then
            log_file="$work_dir/$log_file"
            echo "$service_name,$actual_status" >> $log_file
            echo "Setting:   Service $service_name to $correct_status"
            if [ "$correct_status" = "disabled" ]; then
              /etc/init.d/$service_name stop
              mv /etc/init.d/$service_name /etc/init.d/_$service_name
            else
              mv /etc/init.d/_$service_name /etc/init.d/$service_name
              /etc/init.d/$service_name start
            fi
          fi
        fi
      else
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/$log_file"
          if [ -f "$restore_file" ]; then
            check_name=`cat $restore_file |grep $service_name |cut -f1 -d","`
            if [ "$check_name" = "$service_name" ]; then
              check_status=`cat $restore_file |grep "$service_name" |cut -f2 -d","`
              echo "Restoring: Service $service_name to $check_status"
              if [ "$check_status" = "disabled" ]; then
                /etc/init.d/$service_name stop
                mv /etc/init.d/$service_name /etc/init.d/_$service_name
              else
                mv /etc/init.d/_$service_name /etc/init.d/$service_name
                /etc/init.d/$service_name start
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
      fi
    fi
  fi
}
