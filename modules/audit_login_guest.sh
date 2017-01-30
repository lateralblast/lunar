# audit_login_guest
#
# Refer to Section(s) 1.4.2.7 Page(s) 29-30 CIS Apple OS X 10.6 Benchmark v1.0.0
#.

audit_login_guest () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Guest login"
    funct_dscl_check /Users/Guest AuthenticationAuthority ";basic;"
    funct_dscl_check /Users/Guest passwd "*"
    funct_dscl_check /Users/Guest UserShell "/sbin/nologin"
  fi
}
