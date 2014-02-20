# audit_yum_conf
#
# Make sure GPG checks are enabled for yum so that malicious sofware can not
# be installed.
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
