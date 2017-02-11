# audit_asl
#
# Check how long system logs are being kept for
#
# Refer to Section 3.1.1 Page(s) 85-6  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section 3.1.2 Page(s) 87-8  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section 3.1.3 Page(s) 89-90 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_asl () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_release" -ge 12 ]; then
      check_append_file /etc/asl.conf "> system.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=90" hash
      check_append_file /etc/asl.conf "> appfirewall.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=90" hash
      check_append_file /etc/asl/com.apple.authd "* file /var/log/authd.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=90" hash
    fi
  fi
}
