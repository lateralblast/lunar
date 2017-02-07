# audit_auditd
#
# Check auditd is installed - Required for various other tests like docker
#.

audit_auditd () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Audit Daemon"
    funct_linux_package install auditd
  fi
}
