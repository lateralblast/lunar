# audit_retry_limit
#
# Solaris:
#
# The RETRIES parameter is the number of failed login attempts a user is
# allowed before being disconnected from the system and forced to reconnect.
# When LOCK_AFTER_RETRIES is set in /etc/security/policy.conf, then the user's
# account is locked after this many failed retries (the account can only be
# unlocked by the administrator using the command:passwd -u <username>
# Setting these values helps discourage brute force password guessing attacks.
# The action specified here sets the lockout limit at 3, which complies with
# NSA and DISA recommendations. This may be too restrictive for some operations
# with large user populations.
#
# AIX:
#
# /etc/security/login.cfg - logininterval:
#
# Defines the time interval, in seconds, when the unsuccessful logins must
# occur to disable a port. This parameter is applicable to all tty connections
# and the system console.
# In setting the logininterval attribute, a port will be disabled if the
# incorrect password is entered a pre-defined number of times, set via
# logindisable, within this interval.
#
# /etc/security/login.cfg - logindisable:
#
# Defines the number of unsuccessful login attempts required before a port
# will be locked. This parameter is applicable to all tty connections and the
# system console.
# In setting the logindisable attribute, a port will be disabled if the
# incorrect password is entered a set number of times within a specified
# interval, set via logininterval.
#
# /etc/security/login.cfg - loginreenable:
#
# Defines the number of minutes after a port is locked when it will be
# automatically un-locked. This parameter is applicable to all tty connections
# and the system console.
# In setting the loginreenable attribute, a locked port will be automatically
# re-enabled once a given number of minutes have passed.
#
# /etc/security/login.cfg - logindelay:
#
# Defines the number of seconds delay between each failed login attempt.
# This works as a multiplier, so if the parameter is set to 10, after the
# first failed login it would delay for 10 seconds, after the second failed
# login 20 seconds etc.
# In setting the logindelay attribute, this implements a delay multiplier
# in-between unsuccessful login attempts.
#
# /etc/security/user - loginretries:
#
# Defines the number of attempts a user has to login to the system before
# their account is disabled.
# In setting the loginretries attribute, this ensures that a user can have a
# pre-defined number of attempts to get their password right, prior to locking
# the account.
#
# Refer to Section(s) 1.2.1-6 Page(s) 26-31 CIS FreeBSD Benchmark v1.1.0
#.

audit_retry_limit () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Retry Limit for Account Lockout"
    if [ "$os_name" = "AIX" ]; then
      funct_sec_check /etc/security/login.cfg default logininterval 300
      funct_sec_check /etc/security/login.cfg default logindisable 10
      funct_sec_check /etc/security/login.cfg default loginreenable 360
      funct_sec_check /etc/security/login.cfg usw logintimeout 30
      funct_sec_check /etc/security/login.cfg default logindelay 10
      funct_sec_check /etc/security/user default loginretries 3
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        check_file="/etc/default/login"
        funct_file_value $check_file RETRIES eq 3 hash
        check_file="/etc/security/policy.conf"
        funct_file_value $check_file LOCK_AFTER_RETRIES eq YES hash
        if [ "$os_version" = "11" ]; then
          svcadm restart svc:/system/name-service/cache
        fi
      fi
    fi
  fi
}
