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
# Linux:
#
# To fix existing accounts:
# useradd -D -f 7
# chage -m 7 -M 90 -W 14 -I 7
#
# The PASS_MAX_DAYS parameter in /etc/login.defs allows an administrator to
# force passwords to expire once they reach a defined age. It is recommended
# that the PASS_MAX_DAYS parameter be set to less than or equal to 90 days.
#
# The PASS_MIN_DAYS parameter in /etc/login.defs allows an administrator to
# prevent users from changing their password until a minimum number of days
# have passed since the last time the user changed their password.
# It is recommended that PASS_MIN_DAYS parameter be set to 7 or more days.
#
# The PASS_WARN_AGE parameter in /etc/login.defs allows an administrator to
# notify users that their password will expire in a defined number of days.
# It is recommended that the PASS_WARN_AGE parameter be set to 7 or more days.
#
# AIX:
#
# /etc/security/user - mindiff:
#
# In setting the mindiff attribute, it ensures that users are not able to
# reuse the same or similar passwords.
# In /etc/security/user, set the default user stanza mindiff attribute to be
# greater than or equal to 4.
# This means that when a user password is set it needs to comprise of at least
# 4 characters not present in the previous password.
#
# /etc/security/user - minage:
#
# Defines the minimum number of weeks before a password can be changed.
# In setting the minage attribute, it prohibits users changing their password
# until a set number of weeks have passed.
#
# /etc/security/user - maxage:
#
# Defines the maximum number of weeks that a password is valid.
# In setting the maxage attribute, it enforces regular password changes.
#
# /etc/security/user - minlen:
#
# Defines the minimum length of a password.
# In setting the minlen attribute, it ensures that passwords meet the required
# length criteria.
#
# /etc/security/user - minalpha:
#
# Defines the minimum number of alphabetic characters in a password.
# In setting the minalpha attribute, it ensures that passwords have a minimum
# number of alphabetic characters.
#
# /etc/security/user- minother:
#
# Defines the number of characters within a password which must be
# non-alphabetic.
# In setting the minother attribute, it increases password complexity by
# enforcing the use of non-alphabetic characters in every user password.
#
# /etc/security/user - maxrepeats:
#
# Defines the maximum number of times a character may appear in a password.
# In setting the maxrepeats attribute, it enforces a maximum number of
# character repeats within a password
#
# /etc/security/user - histexpire:
#
# Defines the period of time in weeks that a user will not be able to reuse
# a password.
# In setting the histexpire attribute, it ensures that a user cannot reuse
# a password within a set period of time.
#
# /etc/security/user - histsize:
#
# Defines the number of previous passwords that a user may not reuse.
# In setting the histsize attribute, it enforces a minimum number of previous
# passwords a user cannot reuse.
#
# /etc/security/user - maxexpired:
#
# Defines the number of weeks after maxage, that a password can be reset by
# the user
# In setting the maxexpired attribute, it limits the number of weeks after
# password expiry when it may be changed by the user.
#
# /etc/security/login.cfg – pwd_algorithm:
#
# Defines the loadable password algorithm used when storing user passwords.
# The management of the password encryption algorithm is not performed within
# the default AIX Security Expert framework. This change is managed as a
# customized entry in the XML files.
# A development of AIX 6.1 was the ability to use different password algorithms
# as defined in /etc/security/pwdalg.cfg. This functionality has been back
# ported into AIX 5.3 TL-07 and above. The traditional UNIX password algorithm
# is crypt, which is a one-way hash function supporting only 8 character
# passwords. The use of brute force password guessing attacks means that crypt
# no longer provides an appropriate level of security and so other encryption
# mechanisms are recommended.
# The recommendation of this benchmark is to set the password algorithm to
# ssha256. This algorithm supports long passwords, up to 255 characters in
# length and allows passphrases including the use of the extended ASCII table
# and the space character. Any passwords already set using crypt will remain
# supported, but there can only one system password algorithm active at any
# one time.
#
#
#
# Refer to Section(s) 7.1.1-3 Page(s) 143-146 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 8.3 Page(s) 27 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.1.1-11 Page(s) 17-26 CIS AIX Benchmark v1.1.0
#.

audit_password_expiry () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Password Expiration Parameters on Active Accounts"
    if [ "$os_name" = "AIX" ]; then
      funct_sec_check /etc/security/user default mindiff 4
      funct_sec_check /etc/security/user default minage 1
      funct_sec_check /etc/security/user default maxage 13
      funct_sec_check /etc/security/user default minlen 8
      funct_sec_check /etc/security/user default minalpha 2
      funct_sec_check /etc/security/user default minother 2
      funct_sec_check /etc/security/user default maxrepeats 2
      funct_sec_check /etc/security/user default histexpire 13
      funct_sec_check /etc/security/user default histsize 20
      funct_sec_check /etc/security/user default maxexpired 2
      if [ "$os_version" > 4 ]; then
        if [ "$os_version" = "5" ]
          if [ "$os_update" > 3 ]; then
            funct_sec_check /etc/security/login.cfg usw pwd_algorithm ssha256
          fi
        else
          funct_sec_check /etc/security/login.cfg usw pwd_algorithm ssha256
        fi
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      check_file="/etc/default/passwd"
      funct_file_value $check_file MAXWEEKS eq 13 hash
      funct_file_value $check_file MINWEEKS eq 1 hash
      funct_file_value $check_file WARNWEEKS eq 4 hash
      check_file="/etc/default/login"
      funct_file_value $check_file DISABLETIME eq 3600 hash
    fi
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/login.defs"
      funct_file_value $check_file PASS_MAX_DAYS eq 90 hash
      funct_file_value $check_file PASS_MIN_DAYS eq 7 hash
      funct_file_value $check_file PASS_WARN_AGE eq 14 hash
      funct_file_value $check_file PASS_MIN_LEN eq 9 hash
      funct_check_perms $check_file 0640 root root
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      if [ "$os_version" > 5 ]; then
        check_file="/etc/adduser.conf"
        funct_file_value $check_file passwdtype eq yes hash
        funct_file_value $check_file upwexpire eq 91d hash
      fi
    fi
  fi
}
