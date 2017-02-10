# audit_file_extensions
#
# Refer to Section 6.2 Page(s) 77-78 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_file_extensions() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "File Extensions"
    check_osx_defaults NSGlobalDomain AppleShowAllExtensions 1 int
  fi
}
