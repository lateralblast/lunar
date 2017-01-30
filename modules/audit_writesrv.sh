# audit_writesrv
#
# Refer to Section(s) 2.12.6 Page(s) 210-1 CIS AIX Benchmark v1.1.0
#.

audit_writesrv () {
  if [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Writesrv"
    funct_itab_check writesrv off
  fi
}
