# audit_email_daemons
#
# Remote mail clients (like Eudora, Netscape Mail and Kmail) may retrieve mail
# from remote mail servers using IMAP, the Internet Message Access Protocol,
# or POP, the Post Office Protocol. If this system is a mail server that must
# offer the POP protocol then either qpopper or cyrus may be activated.
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
  fi
}
