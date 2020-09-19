# audit_tcp_wrappers
#
# Refer to Section(s) 5.5.1-5  Page(s) 110-114 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.5.1-5  Page(s) 95-8    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 4.5.1-5  Page(s) 86-9    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.4.1-5  Page(s) 143-8   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 7.4.1-5  Page(s) 77-80   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3      Page(s) 3-4     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.10.1-4 Page(s) 188-192 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.11     Page(s) 22-3    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.4      Page(s) 36-7    CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 3.4.1-5  Page(s) 1verbose_message "-4   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 3.4.1-5  Page(s) 139-43  CIS Ubuntu 16.04 Benchmark v2.0.0
#.

audit_tcp_wrappers () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "Darwin" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "TCP Wrappers"
    if [ "$os_name" = "AIX" ]; then
      package_name="netsec.options.tcpwrapper.base"
      check_lslpp $package_name
      if [ "$audit_mode" != 2 ]; then
        if [ "$lslpp_check" != "$package_name" ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "TCP Wrappers not installed"
            verbose_message "" fix
            verbose_message "TCP Wrappers not installed" fix
            verbose_message "Install TCP Wrappers" fix
            verbose_message "" fix
          fi
        else
          increment_secure "TCP Wrappers installed"
        fi
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        audit_rpc_bind
        for service_name in $( inetadm | awk '{print $3}' | grep "^svc" ); do
          check_command_value inetadm tcp_wrappers TRUE $service_name
        done
      fi
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/rc.conf"
      check_file_value is $check_file inetd_enable eq YES hash
      check_file_value is $check_file inetd_flags eq "-Wwl -C60" hash
    fi
    check_file="/etc/hosts.deny"
    check_file_value is $check_file ALL colon " ALL" hash
    check_file="/etc/hosts.allow"
    check_file_value is $check_file ALL colon " localhost" hash
    check_file_value is $check_file ALL colon " 127.0.0.1" hash
    if [ ! -f "$check_file" ]; then
      for ip_address in $( ifconfig -a | grep 'inet addr' | grep -v ':127.' | awk '{print $2}' | cut -f2 -d":" ); do
        netmask=$( ifconfig -a | grep '$ip_address' | awk '{print $3}' | cut -f2 -d":" )
        check_file_value is $check_file ALL colon " $ip_address/$netmask" hash
      done
    fi
    if [ "$os_name" = "AIX" ]; then
      group_name="system"
    else
      group_name="root"
    fi
    check_file_perms /etc/hosts.deny 0644 root $group_name
    check_file_perms /etc/hosts.allow 0644 root $group_name
    if [ "$os_name" = "Linux" ]; then
      if [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "SuSE" ] || [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Amazon" ] ; then
        check_linux_package install tcp_wrappers
      else
        check_linux_package install tcpd
      fi
    fi
  fi
}
