# audit_file_sharing
#
# Refer to Section 2.4.8       Page(s) 23-4 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 2.4.8,6.1.4 Page(s) 46-7,158-9 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_file_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Apple File Sharing"
    check_launchctl_service com.apple.AppleFileServer off
    check_osx_defaults /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess no bool
    verbose_message "Samba Services"
    check_launchctl_service nmbd off
    check_launchctl_service smbd off
  fi
}
