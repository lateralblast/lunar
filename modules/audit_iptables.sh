# audit_iptables
#
# Turn on iptables
#
# IPtables is an application that allows a system administrator to configure
# the IPv4 tables, chains and rules provided by the Linux kernel firewall.
# IPtables provides extra protection for the Linux system by limiting
# communications in and out of the box to specific IPv4 addresses and ports.
#
# Refer to Section(s) 5.7-8 Page(s) 114-8  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.7-8 Page(s) 101-3  CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 4.7-8 Page(s) 92-3   CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 3.6.1 Page(s) 153-4  CIS Red Hat Linux 7 Benchmark v2.1.0
# Refer to Section(s) 3.6.1 Page(s) 139-40 CIS Amazon Linux Benchmark v2.0.0

#.

audit_iptables () {
  if [ "$os_name" = "Linux" ]; then
    for service_name in iptables ip6tables; do
      funct_chkconfig_service $service_name 3 on
      funct_chkconfig_service $service_name 5 on
    done
  fi
}
