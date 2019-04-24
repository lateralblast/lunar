# audit_ipfw
#
# Refer to Section 1.3 Page(s) 3-4 CIS FreeBSD Benchmark v1.0.5
#.

audit_ipfw () {
  if [ "$os_name" = "FreeBSD" ]; then
    verbose_message "IP Firewall"
    check_file="/etc/rc.conf"
    check_file_value is $check_file firewall_enable eq YES hash
    check_file_value is $check_file firewall_type eq client hash
  fi
}
