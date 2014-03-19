# audit_guest_sharing
#
# If files need to be shared, a dedicated file server should be used.
# If file sharing on the client Mac must be used, then only authenticated
# access should be used. Guest access allows guest to access files they
# might not need access to.
#
# Refer to Section 6.1.4 Page(s) 75-76 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_guest_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Guest account file sharing"
    funct_defaults_check /Library/Preferences/com.apple.AppleFileServer guestAccess no bool
    funct_defaults_check /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess no bool
  fi
}
