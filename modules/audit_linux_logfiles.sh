# audit_linux_logfiles
#
# Check permission on log files under Linux. Make sure they are only readable
# by system accounts. 
#.

audit_linux_logfiles () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Log File Permissions"
    for log_file in boot.log btml cron dmesg ksyms httpd lastlog maillog \
      mailman messages news pgsql rpm pkgs sa samba scrollkeeper.log \
      secure spooler squid vbox wtmp; do
      if [ -f "/var/log/$log_file" ]; then
        check_file_perms /var/log/$log_file 0600 root root
      fi
    done
  fi
}
