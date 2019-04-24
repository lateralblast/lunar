# audit_avahi_conf
#
# Refer to Section(s) 3.1.3-6 Page(s) 68-72 CIS RHEL 5 Benchmark v2.1.0
#.

audit_avahi_conf () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Multicast DNS Server"
    check_file="/etc/avahi/avahi-daemon.conf"
    check_file_value is $check_file disable-user-service-publishing eq yes hash after "\[publish\]"
    check_file_value is $check_file disable-publishing eq yes hash after "\[publish\]"
    check_file_value is $check_file publish-address eq no hash after "\[publish\]"
    check_file_value is $check_file publish-binfo eq no hash after "\[publish\]"
    check_file_value is $check_file publish-workstation eq no hash after "\[publish\]"
    check_file_value is $check_file publish-domain eq no hash after "\[publish\]"
    check_file_value is $check_file disallow-other-stacks eq yes hash after "\[server\]"
    check_file_value is $check_file check-response-ttl eq yes hash after "\[server\]"
  fi
}
