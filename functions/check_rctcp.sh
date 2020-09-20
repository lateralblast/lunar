# check_rctcp
#
# Function to check rctcp under AIX
#.

check_rctcp() {
  if [ "$os_name" = "AIX" ]; then
    service_name=$1
    correct_value=$2
    if [ "$correct_value" = "off" ]; then
      enabled="disabled"
    else
      enabled="enabled"
    fi
    log_file="$service_name.log"
    actual_value=$( lssrc -a | grep '$service_name ' | awk '{print $4}' )
    if [ "$actual_value" = "active" ]; then
      actual_value="off"
    else
      actual_value="on"
    fi
    if [ "$audit_mode" != 2 ]; then
      string="Service $service_name is $correct_value"
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
      if [ "$actual_value" != "$correct_value" ]; then
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "Service \"$service_name\" is not \"$correct_value\""
          verbose_message "" fix
          if [ "$correct_value" = "off" ]; then
            verbose_message "chrctcp -d $service_name" fix
            verbose_message "stopsrc -s $service_name" fix
            verbose_message "cat /etc/rc.tcpip |sed '/$service_name /s/^/#/g' > /tmp/zzz" fix
            verbose_message "cat /tmp/zzz > /etc/rc.tcpip" fix
            verbose_message "rm /tmp/zzz" fix
          else
            verbose_message "chrctcp -a $service_name" fix
            verbose_message "startsrc -s $service_name" fix
            verbose_message "cat /etc/rc.tcpip |sed '/$service_name /s/^#.//g' > /tmp/zzz" fix
            verbose_message "cat /tmp/zzz > /etc/rc.tcpip" fix
            verbose_message "rm /tmp/zzz" fix
          fi
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          log_file="$work_dir/$log_file"
          verbose_message "Setting:   Service \"$service_name\" to \"$correct_value\""
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
          increment_secure "Service \"$service_name\" is \"$correct_value\""
        fi
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=$( cat $log_file )
        if [ "$previous_value" != "$actual_value" ]; then
          verbose_message "Restoring: Service \"$service_name\" to \"$previous_value\""
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
