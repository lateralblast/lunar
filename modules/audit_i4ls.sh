# audit_i4ls
#
# Refer to Section(s) 2.12.2 Page(s) 207 CIS AIX Benchmark v1.1.0
#.

audit_i4ls() {
  if [ "$os_name" = "AIX" ]; then
    funct_verbose_message "License Manager"
    funct_itab_check i4ls off
  fi
}
