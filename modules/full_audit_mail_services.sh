# full_audit_mail_services
#
# Audit sendmail

full_audit_mail_services () {
  audit_sendmail_daemon
  audit_sendmail_greeting
  audit_sendmail_aliases
  audit_email_daemons
  audit_postfix_daemon
}
