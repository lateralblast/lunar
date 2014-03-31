# audit_telnet_server
#
# The telnet-server package contains the telnetd daemon, which accepts
# connections from users from other systems via the telnet protocol.
# The telnet protocol is insecure and unencrypted. The use of an unencrypted
# transmission medium could allow a user with access to sniff network traffic
# the ability to steal credentials. The ssh package provides an encrypted
# session and stronger security and is included in most Linux distributions.
#
# Refer to Section(s) 2.1.1 Page(s) 47-48 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.1 Page(s) 55 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.1 Page(s) 50-1 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 2.1.1 Page(s) 55 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

audit_telnet_server () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      funct_verbose_message "Telnet Server Daemon"
      funct_linux_package uninstall telnet-server
    fi
  fi
}
