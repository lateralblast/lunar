# audit_file_sharing
#
# Refer to Section 2.4.8 Page(s) 23-24 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_file_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Apple File Sharing"
    check_launchctl_service com.apple.AppleFileServer off
    verbose_message "FTP Services"
    check_launchctl_service ftp off
    verbose_message "Samba Services"
    check_launchctl_service nmbd off
    check_launchctl_service smbd off
  fi
}
