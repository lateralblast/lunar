# audit_aide
#
# Refer to Section(s) 1.3.1-2 Page(s) 73-7  CIS Ubuntu LTS 16.04 Benchmark v2.0.0
# Refer to Section(s) 1.3.1-2 Page(s) 73-7  CIS Ubuntu LTS 18.04 Benchmark v2.1.0
# Refer to Section(s) 1.3.1-2 Page(s) 74-8  CIS Ubuntu LTS 20.04 Benchmark v1.0.0
# Refer to Section(s) 1.3.1-2 Page(s) 104-8 CIS Ubuntu LTS 22.04 Benchmark v1.0.0
#.

audit_aide() {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "AIDE"
    check_linux_package install aide
    check_linux_package install aide-common
    check_append_file /etc/cron.d/aide "0 5 * * * /usr/bin/aide.wrapper --config /etc/aide/aide.conf --check"
  fi
}
