# audit_ncs
#
# Refer to Section(s) 2.12.3 Page(s) 208 CIS AIX Benchmark v1.1.0
#.

audit_ncs () {
  if [ "$os_name" = "AIX" ]; then
    verbose_message "NCS"
    check_itab ncs off
  fi
}
