# audit_file_extensions
#
# Refer to Section 6.2 Page(s) 77-78 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_file_extensions() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "File Extensions"
    funct_defaults_check NSGlobalDomain AppleShowAllExtensions 1 int
  fi
}
