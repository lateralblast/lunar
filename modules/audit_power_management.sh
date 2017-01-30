# audit_power_management
#
# Refer to Section(s) 2.12.5 Page(s) 209-210 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 10.1   Page(s) 91-2    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 10.3   Page(s) 139     CIS Solaris 10 Benchmark v1.1.0
#.

audit_power_management () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Power Management"
    if [ "$os_name" = "AIX" ]; then
      funct_itab_check pmd off
    fi
    if [ "$os_name" = "SunOS" ]; then
      total=`expr $total + 1`
      if [ "$os_version" = "10" ]; then
        funct_file_value /etc/default/power PMCHANGEPERM eq "-" hash
        funct_file_value /etc/default/power CPRCHANGEPERM eq "-" hash
      fi
      if [ "$os_version" = "11" ]; then
        poweradm_test=`poweradm list |grep suspend |awk '{print $2}' |cut -f2 -d"="`
        log_file="poweradm.log"
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/#log_file"
          if [ -f "$log_file" ]; then
            restore_value=`cat $restore_file`
            if [ "$poweradm_test" != "$restore_value" ]; then
              echo "Restoring: Power suspend to $restore_value"
              poweradm set suspend-enable=$restore_value
              poweradm update
            fi
          fi
        fi
        if [ "$poweradm_test" != "false" ]; then
          if [ "$audit_mode" = 1 ]; then
            insecure=`expr $insecure + 1`
            echo "Warning:   Power suspend enabled [$insecure Warnings]"
            funct_verbose_message "" fix
            funct_verbose_message "poweradm set suspend-enable=false" fix
            funct_verbose_message "poweradm update" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            backup_file="$work_dir/$log_file"
            echo "Setting:   Power suspend to disabled"
            echo "$poweradm_test" > $backup_file
            poweradm set suspend-enable=false
            poweradm update
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Power suspend disabled [$secure Passes]"
          fi
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      service_name="apmd"
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
    fi
  fi
}
