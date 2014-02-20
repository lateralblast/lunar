# audit_cron_perms
#
# Make sure system cron entries are only viewable by system accounts.
# Viewing cron entries may provide vectors of attack around temporary
# file creation and race conditions.
#.

audit_cron_perms () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Cron Permissions"
    check_file="/etc/crontab"
    funct_check_perms $check_file 0640 root root
    check_file="/var/spool/cron"
    funct_check_perms $check_file 0750 root root
    check_file="/etc/cron.daily"
    funct_check_perms $check_file 0750 root root
    check_file="/etc/cron.weekly"
    funct_check_perms $check_file 0750 root root
    check_file="/etc/cron.mounthly"
    funct_check_perms $check_file 0750 root root
    check_file="/etc/cron.hourly"
    funct_check_perms $check_file 0750 root root
    check_file="/etc/anacrontab"
    funct_check_perms $check_file 0750 root root
  fi
}
