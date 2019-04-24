# audit_sudo_timeout
#
# Refer to Section 5.1 Page(s) 48-9  CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 5.3 Page(s) 128-9 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_sudo_timeout() {
  if [ "$os_name" = "Darwin" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "SunOS" ]; then
    check_file="/etc/sudoers"
    check_file_value is $check_file "Defaults timestamp_timeout" eq 0 hash after "# Defaults specification"
  fi
}
