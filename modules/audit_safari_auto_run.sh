# audit_safari_auto_run
#
# Refer to Section 6.3   Page(s) 78    CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 6.3-4 Page(s) 164-6 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_safari_auto_run() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Safari"
    check_osx_defaults com.apple.Safari AutoOpenSafeDownloads 0 int
    check_osx_defaults ~/Library/Preferences/com.apple.safari.plist PlugInFirstVisitPolicy PlugInPolicyAllowWithSecurityRestrictions string
  fi
}
