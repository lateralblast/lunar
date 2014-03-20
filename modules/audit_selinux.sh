# audit_selinux
#
# Make sure SELinux is configured appropriately.
#
# Refer to Section 1.4.1-5 Page(s) 36-40 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_selinux () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "SELinux"
    check_file="/etc/selinux/config"
    funct_file_value $check_file SELINUX eq enforcing hash
    funct_file_value $check_file SELINUXTYPE eq targeted hash
    check_file="/etc/grub.conf"
    funct_file_value $check_file selinux eq 1 hash
    funct_file_value $check_file enforcing eq 1 hash
    funct_rpm_check uninstall setroubleshoot
    funct_rpm_check uninstall mctrans
  fi
}
