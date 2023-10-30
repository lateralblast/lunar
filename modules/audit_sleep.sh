# audit_sleep
#
# Refer to Section 2.5.2    Page(s) 52-3  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section 2.9.1.1  Page(s) 200-2 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_sleep() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Sleep"
    if [ "$os_version" -ge 14 ]; then
      if [ "$os_machine" = "arm64" ]; then
        check_pmset sleep 10
        check_pmset displaysleep 15
        check_pmset hibernatemode 25
      else
        check_pmset standbydelaylow 900
        check_pmset standbydelayhigh 900
        check_pmset highstandbythreshold 90
        check_pmset destroyfvkeyonstandby 1
        check_pmset hibernatemode 25
      fi
    else
      check_pmset sleep off
    fi
  fi
}
