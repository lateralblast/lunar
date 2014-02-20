# audit_postfix_daemon
#
# Postfix is installed and active by default on SUSE.
# If the system need not accept remote SMTP connections, disable remote SMTP
# connections by setting SMTPD_LISTEN_REMOTE="no" in the /etc/sysconfig/mail
# SMTP connections are not accepted in a default configuration.
#.

audit_postfix_daemon () {
  if [ "$os_name" = "Linux" ]; then
    if [ "$linux_dist" = "suse" ]; then
      check_file="/etc/sysconfig/mail"
      funct_file_value $check_file SMTPD_LISTEN_REMOTE eq no hash
    fi
  fi
}
