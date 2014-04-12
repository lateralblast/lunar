# audit_web_sharing
#
# Web Sharing uses the Apache 2.2.x Web server to turn the Mac into an HTTP/Web
# server. When Web Sharing is on, files in /Library/WebServer/Documents as well
# as each user's "Sites" folder are made available on the Web. As with File
# Sharing, Web Sharing is best left off and a dedicated, well-managed Web server
# is recommended.
# Web Sharing can be configured using the /etc/apache2/httpd.conf file
# (for global configurations). By default, Apache is fairly secure, but it can
# be made more secure with a few additions to the /etc/apache2/httpd.conf file.
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
