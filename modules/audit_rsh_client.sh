# audit_rsh_client
#
# The rsh package contains the client commands for the rsh services.
#
# This module is not enabled by default as the rsh client cna be used as a
# debug tool to ensure the rsh service isn't running on other machines
#
# Refer to Section(s) 2.1.4 Page(s) 49   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.4 Page(s) 57   CIS Red Hat Enterprise Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.4 Page(s) 52-3 CIS Red Hat Enterprise Linux 6 Benchmark v1.2.0
# Refer to Section(s) 2.3.2 Page(s) 125  CIS Red Hat Enterprise Linux 7 Benchmark v2.1.0
# Refer to Section(s) 5.1.4 Page(s) 42-3 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.3.2 Page(s) 112  CIS Amazon Linux Benchmark v2.0.0
#.

audit_rsh_client () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Amazon" ]; then
      funct_verbose_message "RSH Client"
      funct_linux_package uninstall rsh
    fi
  fi
}
