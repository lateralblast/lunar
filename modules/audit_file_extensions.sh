# audit_file_extensions
#
# Check File Extensions
#
# Refer to Section(s) 6.2   Page(s) 77-8  CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 6.2   Page(s) 162-3 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 6.1.1 Page(s) 362-4 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_file_extensions() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "File Extensions"
    check_osx_defaults NSGlobalDomain AppleShowAllExtensions 1 int
  fi
}
