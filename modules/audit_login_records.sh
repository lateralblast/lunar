# audit_login_records
#
# Refer to Section(s) 4.5 Page(s) 69-70 CIS Solaris 10 Benchmark v5.1.0
#.

audit_login_records () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "Login Records"
      audit_logadm_value loginlog none
    fi
  fi
}
