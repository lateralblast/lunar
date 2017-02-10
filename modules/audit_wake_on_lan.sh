# audit_wake_on_lan
#
# Refer to Section 2.5.1 Page(s) 26-7 CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section 2.5.1 Page(s) 50-1 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_wake_on_lan() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Wake on Lan"
    check_pmset womp off
  fi
}
