# audit_sleep
#
# Refer to Section 2.5.2 Page(s) 52-3 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_sleep() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Sleep"
    check_pmset sleep off
  fi
}
