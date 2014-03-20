# audit_yum_conf
#
# Make sure GPG checks are enabled for yum so that malicious sofware can not
# be installed.
#
# Refer to Section 1.2.2 Page(s) 32 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_yum_conf () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$linux_dist" = "redhat" ]; then
      funct_verbose_message "Yum Configuration"
      check_file="/etc/yum.conf"
      funct_file_value $check_file gpgcheck eq 1 hash
    fi
  fi
}
