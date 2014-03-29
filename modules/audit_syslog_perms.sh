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
#.

audit_syslog_perms () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "Syslog Permissions"
    funct_check_perms /var/log/syslog 0640 root sys
  fi
}
