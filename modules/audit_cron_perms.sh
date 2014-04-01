# audit_cron_perms
#
# Make sure system cron entries are only viewable by system accounts.
# Viewing cron entries may provide vectors of attack around temporary
# file creation and race conditions.
#
# Refer to Section(s) 6.1.2-9 Page(s) 119-125 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.1.2-9 Page(s) 138-9 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.1.2-9 Page(s) 122-8 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 9.1.2-8 Page(s) 115-9 SLES 11 Benchmark v1.0.0
#.

audit_cron_perms () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Cron Permissions"
    for check_file in /etc/crontab /var/spool/cron /etc/cron.daily /etc/cron.d \
    /etc/cron.weekly /etc/cron.mounthly /etc/cron.hourly /etc/anacrontab; do
        funct_check_perms $check_file 0700 root root
    done
  fi
}
