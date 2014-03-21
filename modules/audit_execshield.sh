# audit_execshield
#
# Execshield is made up of a number of kernel features to provide protection
# against buffer overflow attacks. These features include prevention of
# execution in memory data space, and special handling of text buffers.
#
# Enabling any feature that can protect against buffer overflow attacks
# enhances the security of the system.
#
# Refer to Section 1.6.2 Page(s) 45-46 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_execshield () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] && [ "$os_version" = "6" ]; then
      check_file="/etc/sysctl.conf"
      funct_file_vale $check_file kernel.exec-shield eq 1 hash
    fi
  fi
}
