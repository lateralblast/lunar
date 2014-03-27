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
# Refer to Section 3.15 Page(s) 69 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.11.12-6 Page(s) 198-201 CIS AIX Benchmark v1.1.0
#.

audit_snmp () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "SNMP Daemons"
    if [ "$os_name" = "AIX" ]; then
      check_file="/var/tmp/snmpd.log"
      funct_check_perms $check_file 0640 root system
      check_file="/var/tmp/hostmibd.log"
      funct_check_perms $check_file 0640 root system
      check_file="/var/tmp/dpid2.log"
      funct_check_perms $check_file 0640 root system
      check_file="/var/ct/RMstart.log"
      funct_check_perms $check_file 0640 root system
      check_dir="/var/adm/ras"
      funct_check_perms $check_file 0700 root system
    fi
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
      if [ "$os_vendor" = "CentOS" ]; then
        funct_linux_package uninstall net-snmp
      fi
    fi
  fi
}
