# audit_execshield
#
# Execshield is made up of a number of kernel features to provide protection
# against buffer overflow attacks. These features include prevention of
# execution in memory data space, and special handling of text buffers.
#
# Enabling any feature that can protect against buffer overflow attacks
# enhances the security of the system.
#
# Refer to Section(s) 1.6.2   Page(s) 45-46   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.6.2,4 Page(s) 51,52-3 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.6.2   Page(s) 48      CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 4.2     Page(s) 36-7    CIS SLES 11 Benchmark v1.0.0
#.

audit_execshield () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "XD/NS Support"
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      if [ "$os_version" > 4 ]; then
        check_linux_package install kernel-PAE
        check_file="/etc/sysctl.conf"
        # Configure kernel shield
        check_file_value is $check_file kernel.exec-shield eq 1 hash
        # Restrict core dumps
        check_file_value is $check_file fs.suid.dumpable eq 0 hash
      fi
    else
      if [ "$os_vendor" = "SuSE" ]; then
        check_linux_package install kernel-pae
      fi
    fi
  fi
}
