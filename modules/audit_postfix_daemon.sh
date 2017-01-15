# audit_postfix_daemon
#
# Postfix is installed and active by default on SUSE.
# If the system need not accept remote SMTP connections, disable remote SMTP
# connections by setting SMTPD_LISTEN_REMOTE="no" in the /etc/sysconfig/mail
# SMTP connections are not accepted in a default configuration.
#
# Refer to Section(s) 3.16   Page(s) 69-70 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.2.15 Page(s) 115-6 CIS Red Hat Linux 7 Benchmark v2.1.0
# Refer to Section(s) 2.2.15 Page(s) 107-8 CIS Amazon Linux Benchmark v2.0.0
#.

audit_postfix_daemon () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message="Postfix Daemon"
    if [ "$os_vendor" = "SuSE" ]; then
      check_file="/etc/sysconfig/mail"
      funct_file_value $check_file SMTPD_LISTEN_REMOTE eq no hash
    fi
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Amazon" ]; then
      check_file="/etc/postfix/main.cf"
      funct_file_value $check_file inet_interfaces eq localhost hash
    fi
  fi
}
