# audit_dns_server
#
# Refer to Section(s) 3.9    Page(s) 65-6 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.2.9  Page(s) 109  CIS Ubuntu Linux 16.04 Benchmark v1.0.0
# Refer to Section(s) 3.9    Page(s) 77-8 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.9    Page(s) 68   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.8  Page(s) 108   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.8    Page(s) 58   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 3.6    Page(s) 11   CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.14 Page(s) 50-1 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.2.8  Page(s) 100  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.8  Page(s) 108  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_dns_server () {
  if [ "$named_disable" = "yes" ]; then
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
      verbose_message "DNS Server"
      if [ "$os_name" = "AIX" ]; then
        check_rctcp named off
      fi
      if [ "$os_name" = "SunOS" ]; then
        if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          service_name="svc:/network/dns/server:default"
          check_sunos_service $service_name disabled
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        for service_name in dnsmasq named bind9; do
          check_systemctl_service disable $service_name
          check_chkconfig_service $service_name 3 off
          check_chkconfig_service $service_name 5 off
        done
        if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Amazon" ]; then
          check_linux_package uninstall bind
        fi
      fi
      if [ "$os_name" = "FreeBSD" ]; then
        check_file="/etc/rc.conf"
        check_file_value is $check_file named_enable eq NO hash
      fi
    fi
  fi
}
