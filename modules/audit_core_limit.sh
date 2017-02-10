# audit_core_limit
#
# Refer to Section(s) 2.10 Page(s) 34-35 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_core_limit () {
  if [ "$os_name" = "Darwin" ]; then
    
    verbose_message "Core dump limits"
    log_file="corelimit"
    backup_file="$work_dir/$log_file"
    current_value=`launchctl limit core |awk '{print $3}'`
    if [ "$audit_mode" != 2 ]; then
      if [ "$current_value" != "0" ]; then
        if [ "$audit_mode" = 0 ]; then
          
          increment_insecure "Core dumps unlimited"
          verbose_message "" fix
          verbose_message "launchctl limit core 0" fix
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          echo "Setting:   Core dump limits"
          echo "$current_value" > $log_file
          launchctl limit core 0
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          
          increment_secure "Core dump limits exist"
        fi
      fi
    else
      restore_file="$restore_dir/$log_file"
      if [ -f "$restore_file" ]; then
        previous_value=`cat $restore_file`
        if [ "$current_value" != "$previous_value" ]; then
          echo "Restoring: Core limit to $previous_value"
          launchctl limit core unlimited
        fi
      fi
    fi
  fi
}
