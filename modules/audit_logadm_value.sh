# audit_logadm_value
#
# Enable Debug Level Daemon Logging. Improved logging capability.
#
# Refer to Section(s) 4.3 Page(s) 67-8 CIS Solaris 10 Benchmark v5.1.0
#.

audit_logadm_value () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Debug Level Daemon Logging"
      log_name=$1
      log_facility=$2
      check_file="/etc/logadm.conf"
      check_log=`logadm -V |grep -v '^#' |grep "$log_name"`
      log_file="/var/log/$log_name"
      total=`expr $total + 1`
      if [ `expr "$check_log" : "[A-z]"` != 1 ]; then
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   Logging for $log_name not enabled [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "logadm -w $log_name -C 13 -a 'pkill -HUP syslogd' $log_file" fix
          funct_verbose_message "svcadm refresh svc:/system/system-log" fix
          funct_verbose_message "" fix
        else
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Syslog to capture $log_facility"
          fi
          funct_backup_file $check_file
          if [ "$log_facility" != "none" ]; then
            check_file="/etc/syslog.conf"
            if [ ! -f "$work_dir$check_file" ]; then
              echo "Saving:    File $check_file to $work_dir$check_file"
              find $check_file | cpio -pdm $work_dir 2> /dev/null
            fi
          fi
          echo "$log_facility\t\t\t$log_file" >> $check_file
          touch $log_file
          chown root:root $log_file
          if [ "$log_facility" = "none" ]; then
            logadm -w $log_name -C 13 $log_file
          else
            logadm -w $log_name -C 13 -a 'pkill -HUP syslogd' $log_file
            svcadm refresh svc:/system/system-log
          fi
        fi
        if [ "$audit_mode" = 2 ]; then
          if [ -f "$restore_dir/$check_file" ]; then
            cp -p $restore_dir/$check_file $check_file
            if [ "$os_version" != "11" ]; then
              pkgchk -f -n -p $check_file 2> /dev/null
            else
              pkg fix `pkg search $check_file |grep pkg |awk '{print $4}'`
            fi
          fi
          if [ "$log_facility" = "none" ]; then
            check_file="/etc/syslog.conf"
            if [ -f "$restore_dir/$check_file" ]; then
              cp -p $restore_dir/$check_file $check_file
              if [ "$os_version" != "11" ]; then
                pkgchk -f -n -p $check_file 2> /dev/null
              else
                pkg fix `pkg search $check_file |grep pkg |awk '{print $4}'`
              fi
            fi
            svcadm refresh svc:/system/system-log
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          secure=`expr $secure + 1`
          echo "Secure:    Logging for $log_name already enabled [$secure Passes]"
        fi
      fi
    fi
  fi
}
