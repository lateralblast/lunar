# audit_netrc_files
#
# .netrc files contain data for logging into a remote host for file transfers
# via FTP
# The .netrc file presents a significant security risk since it stores passwords
# in unencrypted form.
#.

audit_netrc_files () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "User Netrc Files"
    audit_dot_files .netrc
  fi
}
