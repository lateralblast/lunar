# audit_gate_keeper
#
# Refer to Section 2.5.1 Page(s) 26-27 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_gate_keeper() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Gatekeeper"
    log_file="gatekeeper.log"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Gatekeeper is enabled"
      actual_value=`sudo spctl --status |awk '{print $2}' |sed 's/d$//g'`
      if [ "$actual_value" = "disable" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          insecure=`expr $insecure + 1`
          echo "Warning:   Gatekeeper is not enabled [$insecure Warnings]"
        fi
        if [ "$audit_mode" = 0 ]; then
          echo "Seting:    Gatekeeper to enabled [$secure Passes]"
          echo "$actual_value" > $work_dir/$log_file
          sudo spctl --master-enable
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          secure=`expr $secure + 1`
          echo "Secure:    Gatekeeper is enabled [$secure Passes]"
        fi
      fi
    else
      restore_file=$retore_dir/$log_file
      if [ -f "$restore_file" ]; then
        $restore_value=`cat $restore_file`
        if [ "$restore_value" != "$actual_value" ]; then
          echo "Restoring: Gatekeeper to $restore_value"
          sudo spctl --master-$restore_value
        fi
      fi
    fi
  fi
}
