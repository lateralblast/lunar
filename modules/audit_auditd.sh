# audit_auditd
#
# Check auditd is installed - Required for various other tests like docker
#
# Refer to Section(s) 4.1 Page(s) 157-8 CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 3.2 Page(s) 91    CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_auditd () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
    verbose_message "Audit Daemon"
    if [ "$os_name" = "Linux" ]; then
      check_linux_package install auditd
    fi
    if [ "$os_name" = "Darwin" ]; then
      check_launchctl_service com.apple.auditd on
    fi
  fi
}
