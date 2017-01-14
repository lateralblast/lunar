# audit_snmp
#
# Simple Network Management Protocol (SNMP) is an "Internet-standard protocol
# for managing devices on IP networks". Devices that typically support SNMP
# include routers, switches, servers, workstations, printers, modem racks, and
# more. It is used mostly in network management systems to monitor network-
# attached devices for conditions that warrant administrative attention.
# Turn off SNMP if not used. If SNMP is used lock it down. SNMP can reveal
# configuration information about systems leading to vectors of attack.
#
# Refer to Section(s) 3.15        Page(s) 69         CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.15        Page(s) 81-2       CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.15        Page(s) 71-2       CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.14        Page(s) 61-2       CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3.7,18-21 Page(s) 41-2,55-60 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 1.13        Page(s) 43-4       CIS ESX Server 4 Benchmark v1.1.0
# Refer to Section(s) 2.2.14      Page(s) 106        CIS Amazon Linux Benchmark v2.0.0
#.

audit_snmp () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ] || [ "$os_name" = "VMkernel" ]; then
    if [ "$snmpd_disable" = "yes" ]; then
      funct_verbose_message "SNMP Daemons and Log Permissions"
      if [ "$os_name" = "VMkernel" ]; then
        total=`expr $total + 1`
        log_file="snmpstatus"
        backup_file="$work_dir/$log_file"
        current_value=`esxcli system snmp get |grep Enable |awk '{print $2}'`
        if [ "$audit_mode" != "2" ]; then
          if [ "$current_value" = "true" ]; then
            if [ "$audit_more" = "0" ]; then
              echo "$current_value" > $backup_file
              echo "Setting:   SNMP to disabled"
              esxcli system snmp set --enable="false"
            fi
            if [ "$audit_mode" = "1" ]; then
              insecure=`expr $insecure + 1`
              echo "Warning:   SNMP is not enabled [$insecure Warnings]"
              funct_verbose_message "" fix
              funct_verbose_message "esxcli system snmp set --enable=\"false\"" fix
              funct_verbose_message "" fix
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              secure=`expr $secure + 1`
              echo "Secure:    SNMP is disabled [$secure Passes]"
              echo ""
            fi
          fi
        else
          restore_file="$restore_dir/$log_file"
         if [ -f "$restore_file" ]; then
            previous_value=`cat $restore_file`
            if [ "$previous_value" != "$current_value" ]; then
              echo "Restoring: SNMP to $previous_value"
              esxcli system snmp set --enable="$previous_value"
            fi
          fi
        fi
      fi
      if [ "$os_name" = "AIX" ]; then
        for service_name in snmpd dpid2 hostmibd snmpmibd aixmibd; do
          funct_rctcp_check $service_name off
        done
        for check_file in /var/tmp/snmpd.log /var/tmp/hostmibd.log \
        /var/tmp/dpid2.log /var/ct/RMstart.log /smit.log; do
          funct_check_perms $check_file 0640 root system
        done
        check_dir="/var/adm/ras"
        funct_check_perms $check_file 0700 root system
      fi
      if [ "$os_name" = "SunOS" ]; then
        funct_verbose_message "SNMP Daemons"
        if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          service_name="svc:/application/management/seaport:default"
          funct_service $service_name disabled
          service_name="svc:/application/management/snmpdx:default"
          funct_service $service_name disabled
          service_name="svc:/application/management/dmi:default"
          funct_service $service_name disabled
          service_name="svc:/application/management/sma:default"
          funct_service $service_name disabled
        else
          service_name="init.dmi"
          funct_service $service_name disabled
          service_name="init.sma"
          funct_service $service_name disabled
          service_name="init.snmpdx"
          funct_service $service_name disabled
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        funct_rpm_check net-snmp
        if [ "$rpm_check" = "net-snmp" ]; then
          service_name="snmpd"
          funct_chkconfig_service $service_name 3 off
          funct_chkconfig_service $service_name 5 off
          service_name="snmptrapd"
          funct_chkconfig_service $service_name 3 off
          funct_chkconfig_service $service_name 5 off
          funct_append_file /etc/snmp/snmpd.conf "com2sec notConfigUser default public" hash
          if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
            funct_linux_package uninstall net-snmp
          fi
        fi
      fi
    else
      if [ "$os_name" = "AIX" ]; then
        for check_file in /var/tmp/snmpd.log /var/tmp/hostmibd.log \
        /var/tmp/dpid2.log /var/ct/RMstart.log /smit.log; do
          funct_check_perms $check_file 0640 root system
        done
        check_dir="/var/adm/ras"
        funct_check_perms $check_file 0700 root system
      fi
    fi
  fi
}
