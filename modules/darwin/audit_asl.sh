#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_asl
#
# Check how long system logs are being kept for
#
# Refer to Section(s) 3.1.1-3,3.5 Page(s) 85-60,94-5  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 3.3         Page(s) 276-7       CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_asl () {
  print_function "audit_asl"
  string="System Logging"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    check_append_file "/etc/asl.conf"              "> system.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=90"                 "hash"
    check_append_file "/etc/asl.conf"              "> appfirewall.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=90"            "hash"
    check_append_file "/etc/asl/com.apple.authd"   "* file /var/log/authd.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=90"    "hash"
    check_append_file "/etc/asl/com.apple.install" "* file /var/log/install.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=365" "hash"
  else
    na_message "${string}"
  fi
}
