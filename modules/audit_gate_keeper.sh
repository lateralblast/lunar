# audit_gate_keeper
#
# Refer to Section 2.5.1 Page(s) 26-27 CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section 2.6.2 Page(s) 55    CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_gate_keeper() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Gatekeeper"
    log_file="gatekeeper.log"
    if [ "$audit_mode" != 2 ]; then
      actual_value=$( sudo spctl --status | awk '{print $2}' | sed 's/d$//g' )
      if [ "$actual_value" = "disable" ]; then
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "Gatekeeper is not enabled"
        fi
        if [ "$audit_mode" = 0 ]; then
          verbose_message "Seting:    Gatekeeper to enabled"
          echo "$actual_value" > $work_dir/$log_file
          sudo spctl --master-enable
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          increment_secure "Gatekeeper is enabled"
        fi
      fi
    else
      restore_file=$restore_dir/$log_file
      if [ -f "$restore_file" ]; then
        restore_value=$( cat $restore_file )
        if [ "$restore_value" != "$actual_value" ]; then
          verbose_message "Restoring: Gatekeeper to $restore_value"
          sudo spctl --master-$restore_value
        fi
      fi
    fi
  fi
}
