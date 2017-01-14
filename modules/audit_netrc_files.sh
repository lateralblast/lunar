# audit_netrc_files
#
# .netrc files contain data for logging into a remote host for file transfers
# via FTP
# The .netrc file presents a significant security risk since it stores passwords
# in unencrypted form.
#
# Refer to Section(s) 6.2.12-3 Page(s) 264-6 CIS Amazon Linux Benchmark v1.0.0
#.

audit_netrc_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "User Netrc Files"
    audit_dot_files .netrc
  fi
}
