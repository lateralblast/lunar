# audit_selinux
#
# Make sure SELinux is configured appropriately.
#.

audit_selinux () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "SELinux"
    check_file="/etc/selinux/config"
    funct_file_value $check_file SELINUX eq enforcing hash
    funct_file_value $check_file SELINUXTYPE eq targeted hash
  fi
}
