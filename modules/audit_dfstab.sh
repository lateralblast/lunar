# audit_dfstab
#
# Refer to Section(s) 10.2 Page(s) 138-9 CIS Solaris 10 Benchmark v1.1.0
#.

audit_dfstab () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Full Path Names in Exports"
    replace_file_value /etc/dfs/dfstab share /usr/bin/share start
  fi
}
