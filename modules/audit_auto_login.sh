# audit_auto_login
#
# The automatic login feature saves a user's system access credentials and
# bypasses the login screen, instead the system automatically loads to the
# user's desktop screen.
#
# Disabling automatic login decreases the likelihood of an unauthorized person
# gaining access to a system.
#
# Refer to Section 5.7 Page(s) 53-54 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_auto_login() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Autologin"
    funct_defaults_check /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin yes bool
  fi
}
