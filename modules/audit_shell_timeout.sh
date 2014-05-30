# audit_shell_timeout
#
# If a user forgets to log out of their SSH session the idle connection will
# remain indefinitely, increasing the potential for someone to gain privileged
# access to the host.
# The ESXiShellInteractiveTimeOut allows you to automatically terminate idle
# shell sessions.
#
# When the ESXi Shell or SSH services are enabled on a host they will run
# indefinitely.  To avoid having these services left running set the
# ESXiShellTimeOut.  The ESXiShellTimeOut defines a window of time after
# which the ESXi Shell and SSH services will automatically be terminated.
#
# Refre to: http://pubs.vmware.com/vsphere-55/topic/com.vmware.wssdk.apiref.doc/vim.option.OptionManager.html
#.

audit_shell_timeout () {
  if [ "$os_name" = "VMkernel" ]; then
    for test in ESXiShellInteractiveTimeOut ESXiShellTimeOut; do
      timeout="3600"
      funct_verbose_message "Timeoute value for $test"
      total=`expr $total + 1`
      backup_file="$work_dir/$test"
      current_value=`esxcli --formatter=csv --format-param=fields="Path,Int Value" system settings advanced list | grep /UserVars/$test |cut -f2 -d,`
      if [ "$audit_mode" != "2" ]; then
        if [ "$current_value" != "$timeout" ]; then
          if [ "$audit_more" = "0" ]; then
            esxcli system settings advanced set -o /UserVars/$test -i $timeout
          fi
          if [ "$audit_mode" = "1" ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Timeout value for $test not set to $timeout [$insecure Warnings]"
            funct_verbose_message "" fix
            funct_verbose_message "esxcli system settings advanced set -o /UserVars/$test -i $timeout" fix
          fi
        else
          if [ "$audit_mode" = "1" ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Timeout value for $test is set to $timeout [$secure Passes]"
          fi
        fi
      else
        if [ -f "$backup_file" ]; then
          previous_value=`cat $backup_file`
          if [ "$previous_value" != "$current_value" ]; then
            esxcli system settings advanced set -o /UserVars/$test -i $previous_value
          fi
        fi
      fi
    done
  fi
}
