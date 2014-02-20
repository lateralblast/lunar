# audit_retry_limit
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
#.

audit_retry_limit () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Retry Limit for Account Lockout"
      check_file="/etc/default/login"
      funct_file_value $check_file RETRIES eq 3 hash
      check_file="/etc/security/policy.conf"
      funct_file_value $check_file LOCK_AFTER_RETRIES eq YES hash
      if [ "$os_version" = "11" ]; then
        svcadm restart svc:/system/name-service/cache
      fi
    fi
  fi
}
