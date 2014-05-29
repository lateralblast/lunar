# audit_wake_on_lan
#
# Disabling this feature mitigates the risk of an attacker remotely waking
# the system and gaining access.
#
# Refer to Section 2.5.1 Page(s) 26-27 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_wake_on_lan() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Wake on Lan"
    log_file="womp.log"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Wake on Lan is disabled"
      actual_value=`pmset -g | grep womp |awk '{print $2}'`
      if [ "$actual_value" = "1" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          insecure=`expr $insecure + 1`
          echo "Warning:   Wake on Lan is enabled [$insecure Warnings]"
        fi
        if [ "$audit_mode" = 0 ]; then
          echo "Seting:    Wake on Lan to disabled [$score]"
          echo "$actual_value" > $work_dir/$log_file
          pmset -c womp 0
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          secure=`expr $secure + 1`
          echo "Secure:    Wake on Lan is disabled [$secure Passes]"
        fi
      fi
    else
      restore_file = $retore_dir/$log_file
      if [ -f "$restore_file" ]; then
        $restore_value=`cat $restore_file`
        if [ "$restore_value" != "$actual_value" ]; then
          echo "Restoring: Wake on lan to enabled"
          pmset -c womp 1
        fi
      fi
    fi
  fi
}
