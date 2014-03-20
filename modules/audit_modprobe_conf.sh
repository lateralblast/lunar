# audit_modprobe_conf
#
# Check entries are in place so kernel modules can't be force loaded.
# Some modules may getting unintentionally loaded that could reduce system
# security.
#
# Refer to Section 1.18-24 Page(s) 26-30 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_modprobe_conf () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Modprobe Configuration"
    check_file="/etc/modprobe.conf"
    funct_append_file $check_file "install tipc /bin/true"
    funct_append_file $check_file "install rds /bin/true"
    funct_append_file $check_file "install sctp /bin/true"
    funct_append_file $check_file "install dccp /bin/true"
    funct_append_file $check_file "install udf /bin/true"
    funct_append_file $check_file "install squashfs /bin/true"
    funct_append_file $check_file "install hfs /bin/true"
    funct_append_file $check_file "install hfsplus /bin/true"
    funct_append_file $check_file "install jffs2 /bin/true"
    funct_append_file $check_file "install freevxfs /bin/true"
    funct_append_file $check_file "install cramfs /bin/true"
  fi
}
