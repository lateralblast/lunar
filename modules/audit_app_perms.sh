# audit_app_perms
#
# Refer to Section(s) 5.1.2 Page(s) 109 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_app_perms () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Application Permissions"
    if [ "$audit_mode" != 2 ]; then
      OFS=$IFS
      IFS=$'\n'
      app_dirs=$( ls /Applications )
      for app_dir in $app_dirs; do
        check_file_perms "/Applications/$app_dir" 0755
      done
      IFS=$OFS
    fi
  fi
}
