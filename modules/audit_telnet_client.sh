# audit_telnet_client
#
# The telnet package contains the telnet client, which allows users to start
# connections to other systems via the telnet protocol.
#
# This module is not included by default as the telnet client is a useful
# debug tool
#
# Refer to Section(s) 2.1.2 Page(s) 49 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.2 Page(s) 56 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.2 Page(s) 51 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

audit_telnet_client () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      funct_verbose_message "Telnet Client"
      funct_linux_package uninstall telnet
    fi
  fi
}
