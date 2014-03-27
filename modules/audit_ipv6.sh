# audit_ipv6
#
# authoconf6 is used to automatically configure IPv6 interfaces at boot time.
# Running this service may allow other hosts on the same physical subnet to
# connect via IPv6, even when the network does not support it.
# You must disable this unless you utilize IPv6 on the server.
#
# Refer to Section(s) 1.3.11 Page(s) 47 CIS AIX Benchmark v1.1.0
#.

audit_ipv6() {
  if [ "$ipv6_disable" = "yes" ]; then
    funct_verbose_message "IPv6 Autoconf Daemon"
    if [ "$os_name" = "AIX" ]; then
      funct_rctcp_check autoconf6 off
    fi
  fi
}
