# audit_web_sharing
#
# Refer to Section(s) 1.4.14.7 Page(s) 55-6 CIS Apple OS X 10.7 Benchmark v1.0.0
#.

audit_web_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Web sharing"
    funct_launchctl_check org.apache.httpd off
    check_file="/etc/apache2/httpd.conf"
    funct_file_value $check_file ServerTokens space Prod hash
    funct_file_value $check_file ServerSignature space Off hash
    funct_file_value $check_file UserDir space Disabled hash
    funct_file_value $check_file TraceEnable space Off hash
  fi
}
