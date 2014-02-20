# audit_password_expiry
#
# Many organizations require users to change passwords on a regular basis.
# Since /etc/default/passwd sets defaults in terms of number of weeks
# (even though the actual values on user accounts are kept in terms of days),
# it is probably best to choose interval values that are multiples of 7.
# Actions for this item do not work on accounts stored on network directories
# such as LDAP.
# The commands for this item set all active accounts (except the root account)
# to force password changes every 91 days (13 weeks), and then prevent password
# changes for seven days (one week) thereafter. Users will begin receiving
# warnings 28 days (4 weeks) before their password expires. Sites also have the
# option of expiring idle accounts after a certain number of days (see the on-
# line manual page for the usermod command, particularly the -f option).
# These are recommended starting values, but sites may choose to make them more
# restrictive depending on local policies.
# For Linux this will apply to new accounts
#
# To fix existing accounts:
# useradd -D -f 7
# chage -m 7 -M 90 -W 14 -I 7
#.

audit_password_expiry () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Password Expiration Parameters on Active Accounts"
    check_file="/etc/default/passwd"
    funct_file_value $check_file MAXWEEKS eq 13 hash
    funct_file_value $check_file MINWEEKS eq 1 hash
    funct_file_value $check_file WARNWEEKS eq 4 hash
    check_file="/etc/default/login"
    funct_file_value $check_file DISABLETIME eq 3600 hash
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Password Expiration Parameters on Active Accounts"
    check_file="/etc/login.defs"
    funct_file_value $check_file PASS_MAX_DAYS eq 90 hash
    funct_file_value $check_file PASS_MIN_DAYS eq 7 hash
    funct_file_value $check_file PASS_WARN_AGE eq 14 hash
    funct_file_value $check_file PASS_MIN_LEN eq 9 hash
    funct_check_perms $check_file 0640 root root
  fi
}
