# audit_modprobe_conf
#
# Refer to Section(s) 1.18-24,5.6.1-4    Page(s) 26-30,114-6   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.18-24,4.6.1-4    Page(s) 27-32,90-2    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.1.1.1-8,3.5.1-4  Page(s) 17-25,149-152 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 1.1.1.1-8          Page(s) 16-24         CIS Ubuntu LTS 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.18-24,7.5.1-4    Page(s) 26-30,80-3    CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.1.18-24,4.6.1-2  Page(s) 28-33,98-100  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.1.1-18,3.5.1-4 Page(s) 16-24,135-8   CIS Amazon Linux Benchmark v2.0.0
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
    funct_append_file $check_file "install vfat /bin/true"
  fi
}
