#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_web_sharing
#
# Turn off web sharing
#
# Refer to Section(s) 1.4.14.7 Page(s) 55-6  CIS Apple OS X 10.7  Benchmark v1.0.0
# Refer to Section(s) 4.4      Page(s) 101-2 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 4.2      Page(s) 292-3 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_web_sharing () {
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message   "Web sharing" "check"
    check_file_value "is" "/etc/apache2/httpd.conf" "ServerTokens"    "space" "Prod"     "hash"
    check_file_value "is" "/etc/apache2/httpd.conf" "ServerSignature" "space" "Off"      "hash"
    check_file_value "is" "/etc/apache2/httpd.conf" "UserDir"         "space" "Disabled" "hash"
    check_file_value "is" "/etc/apache2/httpd.conf" "TraceEnable"     "space" "Off"      "hash"
    check_launchctl_service "org.apache.httpd" "off"
  fi
}
