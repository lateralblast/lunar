# audit_email_daemons
#
# Remote mail clients (like Eudora, Netscape Mail and Kmail) may retrieve mail
# from remote mail servers using IMAP, the Internet Message Access Protocol,
# or POP, the Post Office Protocol. If this system is a mail server that must
# offer the POP protocol then either qpopper or cyrus may be activated.
#
# Dovecot is an open source IMAP and POP3 server for Linux based systems.
# Unless POP3 and/or IMAP servers are to be provided to this server, it is
# recommended that the service be deleted.
#
# Refer to Section 3.12 Page(s) 67 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_email_daemons () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Cyrus IMAP Daemon"
    service_name="cyrus"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 3 off
    funct_verbose_message "IMAP Daemon"
    service_name="imapd"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 3 off
    funct_verbose_message "Qpopper POP Daemon"
    service_name="qpopper"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 3 off
    funct_verbose_message "Dovecot IMAP and POP3 Services"
    service_name="dovecot"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 3 off
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
      funct_linux_package uninstall dovecot
    fi
  fi
}
