# audit_login_autologin
#
# having a computer automatically log in bypasses a major security feature
# (the login) and can allow a casual user access to sensitive data in that
# user’s home directory and keychain.
#
# Refer to Section(s) 1.4.13.5 Page(s) 47 CIS Apple OS X 10.6 Benchmark v1.0.0
#.

audit_login_autologin () {
  if [ "$os_name" = "darwin" ]; then
    funct_verbose_message "autologin"
    funct_defaults_check /library/preferences/.globalpreferences com.apple.userspref.disableautologin yes bool
  fi
}
