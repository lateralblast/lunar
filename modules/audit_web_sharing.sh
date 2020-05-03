# audit_web_sharing
#
# Refer to Section(s) 1.4.14.7 Page(s) 55-6  CIS Apple OS X 10.7  Benchmark v1.0.0
# Refer to Section(s) 4.4      Page(s) 101-2 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_web_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Web sharing"
    check_launchctl_service org.apache.httpd off
    check_file="/etc/apache2/httpd.conf"
    check_file_value is $check_file ServerTokens space Prod hash
    check_file_value is $check_file ServerSignature space Off hash
    check_file_value is $check_file UserDir space Disabled hash
    check_file_value is $check_file TraceEnable space Off hash
  fi
}
