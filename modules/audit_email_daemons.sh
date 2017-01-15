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
# Refer to Section(s) 3.12   Page(s) 67    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.2.11 Page(s) 111   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 3.12   Page(s) 79-80 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.11   Page(s) 60    CIS SLES 11 Benchmark v1.0.0
#.

audit_email_daemons () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Cyrus IMAP Daemon"
    service_name="cyrus"
    funct_systemctl_service disable $service_name
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 3 off
    funct_verbose_message "IMAP Daemon"
    service_name="imapd"
    funct_systemctl_service disable $service_name
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 3 off
    funct_verbose_message "Qpopper POP Daemon"
    service_name="qpopper"
    funct_systemctl_service disable $service_name
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 3 off
    funct_verbose_message "Dovecot IMAP and POP3 Services"
    service_name="dovecot"
    funct_systemctl_service disable $service_name
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 3 off
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Amazone" ]; then
      funct_linux_package uninstall dovecot
    fi
  fi
}
