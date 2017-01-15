# audit_selinux
#
# Make sure SELinux is configured appropriately.
#
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 36-40,41-2  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 41-45,46-7  CIS Red Hat Enterprise Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.4.1-5,1.5.1-2 Page(s) 39-42,43-4  CIS Red Hat Enterprise Linux 6 Benchmark v1.2.0
# Refer to Section(s) 1.6.1.1-5,1.6.2 Page(s) 69-74 ,76-7 CIS Red Hat Enterprise Linux 7 Benchmark v2.1.0
# Refer to Section(s) 1.6.1.1-5,1.6.2 Page(s) 60-66       CIS Amazon Linux Benchmark v2.0.0
#.

audit_selinux () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "SELinux"
    check_file="/etc/selinux/config"
    funct_file_value $check_file SELINUX eq enforcing hash
    funct_file_value $check_file SELINUXTYPE eq targeted hash
    funct_check_perms $check_file 0400 root root
    check_file="/etc/grub.conf"
    funct_check_perms $check_file 0400 root root
    funct_file_value $check_file selinux eq 1 hash
    funct_file_value $check_file enforcing eq 1 hash
    funct_rpm_check uninstall setroubleshoot
    funct_rpm_check uninstall mctrans
  fi
}
