# audit_guest_sharing
#
# Not allowing guests to connect to shared folders mitigates the risk of an untrusted user
# doing basic reconnaissance and possibly using privilege escalation attacks to take
# control of the system.
#
# Refer to Section(s) 6.1.4  Page(s) 75-6  CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 2.12.2 Page(s) 246-7 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_guest_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Guest account file sharing"
    check_osx_defaults /Library/Preferences/com.apple.AppleFileServer guestAccess no bool
    check_osx_defaults /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess no bool
    if [ "$os_version" -ge 14 ]; then
      check_sysadminctl smbGuestAccess off
    fi
  fi
}
