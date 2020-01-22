# audit_yum_conf
#
# Make sure GPG checks are enabled for yum so that malicious sofware can not
# be installed.
#
# Refer to Section(s) 1.2.3 Page(s) 32 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.2.2 Page(s) 50 CIS RHEL 7 Benchmark v1.0.0
# Refer to Section(s) 1.2.3 Page(s) 34 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.3 Page(s) 34 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.2.3 Page(s) 46 CIS Amazon Linux Benchmark v2.0.0
#.

audit_yum_conf () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      verbose_message "Checkin:  Yum Configuration"
      check_file="/etc/yum.conf"
      check_file_value is $check_file gpgcheck eq 1 hash
    fi
  fi
}
