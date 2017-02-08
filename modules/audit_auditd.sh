# audit_auditd
#
# Check auditd is installed - Required for various other tests like docker
# Refer to Section(s) 4.1 Page(s) 157-8 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_auditd () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Audit Daemon"
    funct_linux_package install auditd
  fi
}
