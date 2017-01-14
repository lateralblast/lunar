# audit_dns_server
#
# The Domain Name System (DNS) is a hierarchical distributed naming system
# for computers, services, or any resource connected to the Internet or a
# private network. It associates various information with domain names
# assigned to each of the participating entities.
# In general servers will be clients of an upstream DNS server within an
# organisation so do not need to provide DNS server services themselves.
# An obvious exception to this is DNS servers themselves and servers that
# provide boot and install services such as Jumpstart or Kickstart servers.
#
# Refer to Section(s) 3.9    Page(s) 65-6 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.9    Page(s) 77-8 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.9    Page(s) 68   CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.8    Page(s) 58   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 3.6    Page(s) 11   CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.14 Page(s) 50-1 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.2.8  Page(s) 100  CIS Amazon Linux Benchmark v2.0.0
#.

audit_dns_server () {
  if [ "$named_disable" = "yes" ]; then
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
      funct_verbose_message "DNS Server"
      if [ "$os_name" = "AIX" ]; then
        funct_rctcp_check named off
      fi
      if [ "$os_name" = "SunOS" ]; then
        if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          service_name="svc:/network/dns/server:default"
          funct_service $service_name disabled
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        for service_name in dnsmasq named; do
          funct_chkconfig_service $service_name 3 off
          funct_chkconfig_service $service_name 5 off
        done
        if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
          funct_linux_package uninstall bind
        fi
      fi
      if [ "$os_name" = "FreeBSD" ]; then
        check_file="/etc/rc.conf"
        funct_file_value $check_file named_enable eq NO hash
      fi
    fi
  fi
}
