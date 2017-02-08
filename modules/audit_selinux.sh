# audit_selinux
#
# Make sure SELinux is configured appropriately.
#
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 36-40,41-2  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 41-45,46-7  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 39-42,43-4  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.6.1.1-5       Page(s) 69-74       CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.6.1.1-3       Page(s) 64-7        CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 1.6.1.1-5       Page(s) 60-66       CIS Amazon Linux Benchmark v2.0.0
#.

audit_selinux () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "SELinux"
    check_file="/etc/selinux/config"
    funct_file_value $check_file SELINUX eq enforcing hash
    funct_file_value $check_file SELINUXTYPE eq targeted hash
    funct_check_perms $check_file 0400 root root
    for check_file in /etc/grub.conf /boot/grub/grub.cfg; do
      if [ -e "$check_file" ]; then
        funct_check_perms $check_file 0400 root root
        funct_file_value $check_file selinux eq 1 hash
        funct_file_value $check_file enforcing eq 1 hash
      fi
    done
    funct_rpm_check uninstall setroubleshoot
    funct_rpm_check uninstall mctrans
  fi
}
