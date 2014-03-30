# audit_execshield
#
# Execshield is made up of a number of kernel features to provide protection
# against buffer overflow attacks. These features include prevention of
# execution in memory data space, and special handling of text buffers.
#
# Enabling any feature that can protect against buffer overflow attacks
# enhances the security of the system.
#
# Refer to Section(s) 1.6.2 Page(s) 45-46 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.6.2 Page(s) 51 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

audit_execshield () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      if [ "$os_version" > 4 ]; then
      check_file="/etc/sysctl.conf"
      funct_file_vale $check_file kernel.exec-shield eq 1 hash
    fi
  fi
}
