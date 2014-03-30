# audit_rsh_client
#
# The rsh package contains the client commands for the rsh services.
#
# This module is not enabled by default as the rsh client cna be used as a
# debug tool to ensure the rsh service isn't running on other machines
#
# Refer to Section(s) 2.1.4 Page(s) 49 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.4 Page(s) 57 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

audit_rsh_client () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      funct_verbose_message "RSH Client"
      funct_linux_package uninstall rsh
    fi
  fi
}
