# audit_iptables
#
# Turn on iptables
#
# Refer to Section(s) 5.7-8 Page(s) 114-8  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.7-8 Page(s) 101-3  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 4.7-8 Page(s) 92-3   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.6.1 Page(s) 153-4  CIS RHEL 7 Benchmark v2.1.0
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
