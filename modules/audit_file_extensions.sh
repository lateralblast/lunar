# audit_file_extensions
#
# A filename extension is a suffix added to a base filename that indicates
# he base filename's file format.
# Visible filename extensions allows the user to identify the file type and
# the application it is associated with which leads to quick identification
# of misrepresented malicious files.
#
# Refer to Section 6.2 Page(s) 77-78 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_file_extensions() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "File Extensions"
    funct_defaults_check NSGlobalDomain AppleShowAllExtensions 1 int
  fi
}
