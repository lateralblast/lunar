# audit_login_hints
#
# Password hints can give an attacker a hint as well, so the option to display
# hints should be turned off. If your organization has a policy to enter a help
# desk number in the password hints areas, do not turn off the option.
#.

audit_login_hints () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Password hints"
    funct_defaults_check /Library/Preferences/com.apple.loginwindow RetriesUntilHint 0 int
  fi
}
