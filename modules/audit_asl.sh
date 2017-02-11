# audit_asl
#
# Check how long system logs are being kept for
#
# Refer to Section 3.1.1 Page(s) 85-6 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_asl () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_release" -ge 12 ]; then
      check_append_file /etc/asl.conf "> system.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=90" hash
    fi
  fi
}
