# audit_netrc_files
#
# Refer to Section(s) 6.2.12-3 Page(s) 264-6  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.2.12-3 Page(s) 278-80 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_netrc_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "User Netrc Files"
    audit_dot_files .netrc
  fi
}
