# audit_login_autologin
#
# having a computer automatically log in bypasses a major security feature
# (the login) and can allow a casual user access to sensitive data in that
# user’s home directory and keychain.
#.

audit_login_autologin () {
  if [ "$os_name" = "darwin" ]; then
    funct_verbose_message "core dumps"
    funct_defaults_check /library/preferences/.globalpreferences com.apple.userspref.disableautologin yes bool
  fi
}
