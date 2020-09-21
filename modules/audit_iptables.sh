# audit_iptables
#
# Turn on iptables
#
# Refer to Section(s) 5.7-8   Page(s) 114-8  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.7-8   Page(s) 101-3  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 4.7-8   Page(s) 92-3   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.6.1   Page(s) 153-4  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 3.6.1   Page(s) 139-40 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 3.6.1-3 Page(s) 149-52 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_iptables () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "IP Tables"
    check_linux_package install iptables
    for service_name in iptables ip6tables; do
      check_systemctl_service enable $service_name
      check_chkconfig_service $service_name 3 on
      check_chkconfig_service $service_name 5 on
    done
    if [ "$audit_mode" != 2 ]; then
      check=$( command -v iptables 2> /dev/null )
      if [ "$check" ]; then
        check=$( iptables -L INPUT -v -n | grep "127.0.0.0" | grep "0.0.0.0" | grep DROP )
        if [ ! "$check" ]; then
          increment_insecure "All other devices allow trafic to the loopback network"
        else
          increment_secure "All other devices deny trafic to the loopback network"
        fi
      fi
    fi
  fi
}
