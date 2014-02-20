# audit_cron_logging
#
# Setting the CRONLOG parameter to YES in the /etc/default/cron file causes
# information to be logged for every cron job that gets executed on the system.
# This setting is the default for Solaris.
# A common attack vector is for programs that are run out of cron to be
# subverted to execute commands as the owner of the cron job. Log data on
# commands that are executed out of cron can be found in the /var/cron/log file.
# Review this file on a regular basis.
#.

audit_cron_logging () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Cron Logging"
      check_file="/etc/default/cron"
      funct_file_value $check_file CRONLOG eq YES hash
      check_file="/var/cron/log"
      funct_check_perms $check_file 0640 root root
    fi
  fi
}
