# audit_tftp_client
#
# Trivial File Transfer Protocol (TFTP) is a simple file transfer protocol,
# typically used to automatically transfer configuration or boot files between
# machines. TFTP does not support authentication and can be easily hacked.
# The package tftp is a client program that allows for connections to a tftp
# server.
#
# This module is not included by default as the tftp client is a useful debug
# tool for tftp services
#
# Refer to Section(s) 2.1.7 Page(s) 51   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.7 Page(s) 59   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.7 Page(s) 54-5 CIS RHEL 6 Benchmark v1.2.0
#.

audit_tftp_client () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "TFTP Client"
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      funct_linux_package uninstall tftp
    fi
  fi
}
