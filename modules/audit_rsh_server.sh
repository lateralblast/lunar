# audit_rsh_server
#
# The Berkeley rsh-server (rsh, rlogin, rcp) package contains legacy services
# that exchange credentials in clear-text.
# These legacy service contain numerous security exposures and have been
# replaced with the more secure SSH package.
#
# Refer to Section(s) 2.1.3  Page(s) 48   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.3  Page(s) 56-7 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.3  Page(s) 51-2 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.17 Page(s) 118  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.1.3  Page(s) 41-2 CIS SLES 11 Benchmark v1.0.0
#.

audit_rsh_server () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
     funct_verbose_message "RSH Server Daemon"
    	if [ "$os_version" = "7" ]; then
    		funct_systemctl_service disable rsh.socket
    		funct_systemctl_service disable rlogin.socket
    		funct_systemctl_service disable rexec.socket
    	else
	      funct_linux_package uninstall rsh-server
	    fi
    fi
  fi
}
