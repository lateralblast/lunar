# audit_syslog_perms
#
# The log file for sendmail (by default in Solaris 10, /var/log/syslog)
# is set to 644 so that sendmail (running as root) can write to the file and
# anyone can read the file.
# Setting the log file /var/log/syslog to 644 allows sendmail (running as root)
# to create entries, but prevents anyone (other than root) from modifying the
# log file, thus rendering the log data worthless.
#
# Refer to Section(s) 11.7-8 Page(s) 146-7 CIS Solaris 10 v1.1.0
# Refer to Section(s) 5.1.2 Page(s) 105-6 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

audit_syslog_perms () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Syslog Permissions"
    if [ "$os_name" = "SunOS" ]; then
      funct_check_perms /var/log/syslog 0600 root sys
    fi
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
      funct_check_perms /var/log/secure 0600 root root
      funct_check_perms /var/log/messages 0600 root root
      funct_check_perms /var/log/daemon.log 0600 root root
      funct_check_perms /var/log/unused.log 0600 root root
    fi
  fi
}
