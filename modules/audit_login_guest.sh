# audit_login_guest
#
# ￼The Guest account allows a guest to log in to a Mac and use all of its
# services. When the guest logs out, the Mac clears most of whatever the guest
# did on the Mac. This allows one person to let another borrow the computer for
# a short period, and still protect information in other accounts on the Mac.
# The usage of a Guest account may give the Mac owner a false sense of security.
# If the guest has physical access to the Mac and the owner is not present,
# the guest could gain full access to the Mac. That said, use of the Guest
# account allows for quick and moderately safe computer sharing.
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
