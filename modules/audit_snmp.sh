# audit_snmp
#
# Refer to Section(s) 3.15        Page(s) 69         CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.15        Page(s) 81-2       CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.15        Page(s) 71-2       CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.14      Page(s) 114        CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.14        Page(s) 61-2       CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3.7,18-21 Page(s) 41-2,55-60 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 1.13        Page(s) 43-4       CIS ESX Server 4 Benchmark v1.1.0
# Refer to Section(s) 2.2.14      Page(s) 106        CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.14      Page(s) 114        CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_snmp () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ] || [ "$os_name" = "VMkernel" ]; then
    if [ "$snmpd_disable" = "yes" ]; then
      verbose_message "SNMP Daemons and Log Permissions"
      if [ "$os_name" = "VMkernel" ]; then
        log_file="snmpstatus"
        backup_file="$work_dir/$log_file"
        current_value=$( esxcli system snmp get | grep Enable | awk '{print $2}' )
        if [ "$audit_mode" != "2" ]; then
          if [ "$current_value" = "true" ]; then
            if [ "$audit_mode" = "0" ]; then
              echo "$current_value" > $backup_file
              verbose_message "Setting:   SNMP to disabled"
              esxcli system snmp set --enable="false"
            fi
            if [ "$audit_mode" = "1" ]; then
              increment_insecure "SNMP is not enabled"
              verbose_message "" fix
              verbose_message "esxcli system snmp set --enable=\"false\"" fix
              verbose_message "" fix
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              increment_secure "SNMP is disabled"
              verbose_message ""
            fi
          fi
        else
          restore_file="$restore_dir/$log_file"
         if [ -f "$restore_file" ]; then
            previous_value=$( cat $restore_file )
            if [ "$previous_value" != "$current_value" ]; then
              verbose_message "Restoring: SNMP to $previous_value"
              esxcli system snmp set --enable="$previous_value"
            fi
          fi
        fi
      fi
      if [ "$os_name" = "AIX" ]; then
        for service_name in snmpd dpid2 hostmibd snmpmibd aixmibd; do
          check_rctcp $service_name off
        done
        for check_file in /var/tmp/snmpd.log /var/tmp/hostmibd.log \
        /var/tmp/dpid2.log /var/ct/RMstart.log /smit.log; do
          check_file_perms $check_file 0640 root system
        done
        check_dir="/var/adm/ras"
        check_file_perms $check_file 0700 root system
      fi
      if [ "$os_name" = "SunOS" ]; then
        verbose_message "SNMP Daemons"
        if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          for service_name in "svc:/application/management/seaport:default" "svc:/application/management/snmpdx:default" \
                              "svc:/application/management/dmi:default" "svc:/application/management/sma:default"; do
            check_sunos_service $service_name disabled
          done
        else
          for service_name in init.dmi init.sma init.snmpdx; do
            check_sunos_service $service_name disabled
          done
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        check_rpm net-snmp
        if [ "$rpm_check" = "net-snmp" ]; then
          for service_name in snmp snmptrapd; do
            check_systemctl_service disable $service_name
            check_chkconfig_service $service_name 3 off
            check_chkconfig_service $service_name 5 off
          done
          check_append_file /etc/snmp/snmpd.conf "com2sec notConfigUser default public" hash
          check_linux_package uninstall net-snmp
        fi
      fi
    else
      if [ "$os_name" = "AIX" ]; then
        for check_file in /var/tmp/snmpd.log /var/tmp/hostmibd.log \
        /var/tmp/dpid2.log /var/ct/RMstart.log /smit.log; do
          check_file_perms $check_file 0640 root system
        done
        check_dir="/var/adm/ras"
        check_file_perms $check_file 0700 root system
      fi
    fi
  fi
}
