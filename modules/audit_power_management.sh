# audit_power_management
#
# The settings in /etc/default/power control which users have access to the
# configuration settings for the system power management and checkpoint and
# resume features. By setting both values to -, configuration changes are
# restricted to only the root user.
#.

audit_power_management () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Power Management"
    total=`expr $total + 1`
    if [ "$os_version" = "10" ]; then
      funct_file_value /etc/default/power PMCHANGEPERM eq "-" hash
      funct_file_value /etc/default/power CPRCHANGEPERM eq "-" hash
    fi
    if [ "$os_version" = "11" ]; then
      poweradm_test=`poweradm list |grep suspend |awk '{print $2}' |cut -f2 -d"="`
      log_file="poweradm.log"
      if [ "$audit_mode" = 2 ]; then
        log_file="$restore_dir"
        if [ -f "$log_file" ]; then
          restore_value=`cat $log_file`
          if [ "$poweradm_test" != "$restore_value" ]; then
            echo "Restoring: Power suspend to $restore_value"
            poweradm set suspend-enable=$restore_value
            poweradm update
          fi
        fi
      fi
      if [ "$poweradm_test" != "false" ]; then
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score - 1`
          echo "Warning:   Power suspend enabled [$score]"
          funct_verbose_message "" fix
          funct_verbose_message "poweradm set suspend-enable=false" fix
          funct_verbose_message "poweradm update" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          log_file="$work_dir/$log_file"
          echo "Setting:   Power suspend to disabled"
          echo "$poweradm_test" > $log_file
          poweradm set suspend-enable=false
          poweradm update
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          score=`expr $score + 1`
          echo "Secure:    Power suspend disabled [$score]"
        fi
      fi
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Power Management"
    service_name="apmd"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
  fi
}
