# audit_rsh_server
#
# The Berkeley rsh-server (rsh, rlogin, rcp) package contains legacy services
# that exchange credentials in clear-text.
# These legacy service contain numerous security exposures and have been
# replaced with the more secure SSH package.
#
# Refer to Section 2.1.3 Page(s) 48 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_rsh_server () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      funct_verbose_message "RSH Server Daemon"
      funct_linux_package uninstall rsh-server
    fi
  fi
}
