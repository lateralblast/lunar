# audit_ipv6
#
# Although IPv6 has many advantages over IPv4, few organizations have
# implemented IPv6.
# If IPv6 is not to be used, it is recommended that the driver not be installed.
# While use of IPv6 is not a security issue, it will cause operational slowness
# as packets are tried via IPv6, when there are no recipients. In addition,
# disabling unneeded functionality reduces the potential attack surface.
#
# AIX
#
# authoconf6 is used to automatically configure IPv6 interfaces at boot time.
# Running this service may allow other hosts on the same physical subnet to
# connect via IPv6, even when the network does not support it.
# You must disable this unless you utilize IPv6 on the server.
#
# Refer to Section(s) 1.3.11,22-3 Page(s) 47,60-2 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.4.2       Page(s) 94      CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 4.4.2       Page(s) 85-6    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 7.3.3       Page(s) 76      CIS SLES 11 Benchmark v1.0.0
#.

audit_ipv6() {
  if [ "$ipv6_disable" = "yes" ]; then
    if [ "$os_name" = "AIX" ]; then
      funct_verbose_message "IPv6 Autoconf Daemon"
      for service_name in autoconf6 ndpd-host ndpd-router; do
        funct_rctcp_check $service_name off
      done
    fi
    if [ "$os_name" = "Linux" ]; then
      if [ "$disable_ipv6" = "yes" ]; then
        funct_verbose_message "IPv6"
        check_file="/etc/modprobe.conf"
        funct_append_file $check_file "options ipv6 \"disable=1\""
        if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
          check_file="/etc/sysconfig/network"
          funct_file_value $check_file NETWORKING_IPV6 eq no hash
          funct_file_value $check_file IPV6INIT eq no hash
        fi
      fi
    fi
  fi
}
