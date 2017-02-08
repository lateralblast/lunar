# funct_rctcp_check
#
# Function to check rctcp under AIX
#.

funct_rctcp_check() {
  if [ "$os_name" = "AIX" ]; then
    service_name=$1
    correct_value=$2
    log_file="$service_name.log"
    actual_value=`lssrc -a |grep '$service_name ' |awk '{print $4}'`
    if [ "$actual_value" = "active" ]; then
      actual_value="off"
    else
      actual_value="on"
    fi
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Service \"$service_name\" is \"$correct_value\""
      if [ "$actual_value" != "$correct_value" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          insecure=`expr $insecure + 1`
          echo "Warning:   Service \"$service_name\" is not \"$correct_value\" [$insecure Warnings]"
          funct_verbose_message "" fix
          if [ "$correct_value" = "off" ]; then
            funct_verbose_message "chrctcp -d $service_name" fix
            funct_verbose_message "stopsrc -s $service_name" fix
            funct_verbose_message "cat /etc/rc.tcpip |sed '/$service_name /s/^/#/g' > /tmp/zzz" fix
            funct_verbose_message "cat /tmp/zzz > /etc/rc.tcpip" fix
            funct_verbose_message "rm /tmp/zzz" fix
          else
            funct_verbose_message "chrctcp -a $service_name" fix
            funct_verbose_message "startsrc -s $service_name" fix
            funct_verbose_message "cat /etc/rc.tcpip |sed '/$service_name /s/^#.//g' > /tmp/zzz" fix
            funct_verbose_message "cat /tmp/zzz > /etc/rc.tcpip" fix
            funct_verbose_message "rm /tmp/zzz" fix
          fi
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          log_file="$work_dir/$log_file"
          echo "Setting:   Service \"$service_name\" to \"$correct_value\""
          echo "$actual_value" > $log_file
          if [ "$correct_value" = "off" ]; then
            chrctcp -d $service_name
            stopsrc -s $service_name
            cat /etc/rc.tcpip |sed '/$service_name /s/^/#/g' > /tmp/zzz
            cat /tmp/zzz > /etc/rc.tcpip
            rm /tmp/zzz
          else
            chrctcp -a $service_name
            startsrc -s $service_name
            cat /etc/rc.tcpip |sed '/$service_name /s/^#.//g' > /tmp/zzz
            cat /tmp/zzz > /etc/rc.tcpip
            rm /tmp/zzz
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          secure=`expr $secure + 1`
          echo "Secure:    Service \"$service_name\" is \"$correct_value\" [$secure Passes]"
        fi
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=`cat $log_file`
        if [ "$previous_value" != "$actual_value" ]; then
          echo "Restoring: Service \"$service_name\" to \"$previous_value\""
          if [ "$previous_value" = "off" ]; then
            chrctcp -d $service_name
            stopsrc -s $service_name
            cat /etc/rc.tcpip |sed '/$service_name /s/^/#/g' > /tmp/zzz
            cat /tmp/zzz > /etc/rc.tcpip
            rm /tmp/zzz
          else
            chrctcp -a $service_name
            startsrc -s $service_name
            cat /etc/rc.tcpip |sed '/$service_name /s/^#.//g' > /tmp/zzz
            cat /tmp/zzz > /etc/rc.tcpip
            rm /tmp/zzz
          fi
        fi
      fi
    fi
  fi
}
