# audit_safari_auto_run
#
# Refer to Section 6.3 Page(s) 78 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_safari_auto_run() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Safari Auto-run"
    funct_defaults_check com.apple.Safari AutoOpenSafeDownloads 0 int
  fi
}
