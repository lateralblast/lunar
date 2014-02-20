# audit_snmp
#
# Simple Network Management Protocol (SNMP) is an "Internet-standard protocol
# for managing devices on IP networks". Devices that typically support SNMP
# include routers, switches, servers, workstations, printers, modem racks, and
# more. It is used mostly in network management systems to monitor network-
# attached devices for conditions that warrant administrative attention.
# Turn off SNMP if not used. If SNMP is used lock it down. SNMP can reveal
# configuration information about systems leading to vectors of attack.
#.

audit_snmp () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "SNMP Daemons"
      service_name="svc:/application/management/seaport:default"
      funct_service $service_name disabled
      service_name="svc:/application/management/snmpdx:default"
      funct_service $service_name disabled
      service_name="svc:/application/management/dmi:default"
      funct_service $service_name disabled
      service_name="svc:/application/management/sma:default"
      funct_service $service_name disabled
    fi
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "SNMP Daemons"
      service_name="init.dmi"
      funct_service $service_name disabled
      service_name="init.sma"
      funct_service $service_name disabled
      service_name="init.snmpdx"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "SNMP Daemons"
    funct_rpm_check net-snmp
    if [ "$rpm_check" = "net-snmp" ]; then
      service_name="snmpd"
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
      service_name="snmptrapd"
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
      funct_append_file /etc/snmp/snmpd.conf "com2sec notConfigUser default public" hash
    fi
  fi
}
