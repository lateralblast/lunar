# audit_xinetd_server
#
# The eXtended InterNET Daemon (xinetd) is an open source super daemon that
# replaced the original inetd daemon. The xinetd daemon listens for well known
# services and dispatches the appropriate daemon to properly respond to service
# requests.
# If there are no xinetd services required, it is recommended that the daemon
# be deleted from the system.
#
# Refer to Section 2.1.11 Page(s) 54 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_xinetd_server () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ]; then
      funct_verbose_message "RSH Server Daemon"
      funct_linux_package uninstall xinetd-server
    fi
  fi
}
