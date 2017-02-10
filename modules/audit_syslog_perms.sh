# audit_syslog_perms
#
# Refer to Section(s) 11.7-8 Page(s) 146-7 CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 5.1.2  Page(s) 105-6 CIS RHEL 5 Benchmark v2.1.0
#.

audit_syslog_perms () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Syslog Permissions"
    if [ "$os_name" = "SunOS" ]; then
      check_file_perms /var/log/syslog 0600 root sys
    fi
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
      check_file_perms /var/log/secure 0600 root root
      check_file_perms /var/log/messages 0600 root root
      check_file_perms /var/log/daemon.log 0600 root root
      check_file_perms /var/log/unused.log 0600 root root
    fi
  fi
}
