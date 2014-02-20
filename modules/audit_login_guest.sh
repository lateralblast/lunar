# audit_login_guest
#
# Password hints can give an attacker a hint as well, so the option to display
# hints should be turned off. If your organization has a policy to enter a help
# desk number in the password hints areas, do not turn off the option.
#.

audit_login_guest () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Guest login"
    funct_dscl_check /Users/Guest AuthenticationAuthority ";basic;"
    funct_dscl_check /Users/Guest passwd "*"
    funct_dscl_check /Users/Guest UserShell "/sbin/nologin"
  fi
}
