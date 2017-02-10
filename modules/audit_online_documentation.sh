# audit_online_documentation
#
# Refer to Section(s) 2.12.4 Page(s) 209 CIS AIX Benchmark v1.1.0
#.

audit_online_documentation () {
  if [ "$os_name" = "AIX" ] || [ "$os_name" = "SunOS" ]; then
    verbose_message "Online Documenation"
    if [ "$os_name" = "AIX" ]; then
      check_itab httpdlite off
    fi
    if [ "$os_name" = "SunOS" ]; then
      check_initd_service ab2mgr disabled
    fi
  fi
}
