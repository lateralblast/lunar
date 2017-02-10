# audit_guest_sharing
#
# Refer to Section(s) 6.1.4 Page(s) 75-76 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_guest_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Guest account file sharing"
    check_osx_defaults /Library/Preferences/com.apple.AppleFileServer guestAccess no bool
    check_osx_defaults /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess no bool
  fi
}
