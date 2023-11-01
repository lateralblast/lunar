# audit_app_perms
#
# Check Application Permissions
# 
# Refer to Section(s) 5.1.2   Page(s) 109    CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 5.1.5-6 Page(s) 307-10 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_app_perms () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Application Permissions"
    if [ "$audit_mode" != 2 ]; then
      OFS=$IFS
      IFS=$'\n'
      for check_dir in Applications System; do
        test_dirs=$( ls -d /$check_dir/* )
        for test_dir in $test_dirs; do
          check_file_perms "$test_dir" 0755
        done
      done
      IFS=$OFS
    fi
  fi
}
