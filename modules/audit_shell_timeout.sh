# audit_shell_timeout
#
# Refer to: http://pubs.vmware.com/vsphere-55/topic/com.vmware.wssdk.apiref.doc/vim.option.OptionManager.html
#.

audit_shell_timeout () {
  if [ "$os_name" = "VMkernel" ]; then
    for test in ESXiShellInteractiveTimeOut ESXiShellTimeOut; do
      timeout="3600"
      verbose_message "Timeoute value for $test"
      backup_file="$work_dir/$test"
      current_value=$( esxcli --formatter=csv --format-param=fields="Path,Int Value" system settings advanced list | grep /UserVars/$test | cut -f2 -d, )
      if [ "$audit_mode" != "2" ]; then
        if [ "$current_value" != "$timeout" ]; then
          if [ "$audit_mode" = "0" ]; then
            echo "$current_value" > $backup_file
            verbose_message "Setting:   Timeout value for $test to $timeout"
            esxcli system settings advanced set -o /UserVars/$test -i $timeout
          fi
          if [ "$audit_mode" = "1" ]; then
            increment_insecure "Timeout value for $test not set to $timeout"
            verbose_message "" fix
            verbose_message "esxcli system settings advanced set -o /UserVars/$test -i $timeout" fix
            verbose_message "" fix
          fi
        else
          if [ "$audit_mode" = "1" ]; then
            increment_secure "Timeout value for $test is set to $timeout"
          fi
        fi
      else
        restore_file="$restore_dir/$test"
        if [ -f "$restore_file" ]; then
          previous_value=$( cat $restore_file )
          if [ "$previous_value" != "$current_value" ]; then
            verbose_message "Restoring: Shell timeout to $previous_value"
            esxcli system settings advanced set -o /UserVars/$test -i $previous_value
          fi
        fi
      fi
    done
  fi
}
