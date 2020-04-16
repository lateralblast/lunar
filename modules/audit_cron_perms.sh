# audit_cron_perms
#
# Refer to Section(s) 6.1.2-9 Page(s) 119-125 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.1.2-9 Page(s) 138-9   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.1.2-9 Page(s) 122-8   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.1.2-9 Page(s) 210-7   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 9.1.2-8 Page(s) 115-9   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.1.2-9 Page(s) 193-200 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 5.1.2-8 Page(s) 205-12  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_cron_perms () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Cron Permissions"
    for check_file in /etc/crontab /var/spool/cron /etc/cron.daily /etc/cron.d \
    /etc/cron.weekly /etc/cron.monthly /etc/cron.hourly /etc/anacrontab; do
        check_file_perms $check_file 0700 root root
    done
  fi
}
