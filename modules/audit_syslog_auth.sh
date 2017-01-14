# audit_syslog_auth
#
# Make sure authentication requests are logged. This is especially important
# for authentication requests to accounts/roles with raised priveleges.
#
# Refer to Section(s) 4.4 Page(s) 68-9 CIS Solaris 10 Benchmark v5.1.0
#.

audit_syslog_auth () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "SYSLOG AUTH Messages"
      audit_logadm_value authlog auth.info
    fi
  fi
}
