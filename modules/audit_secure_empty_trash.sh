# audit_secure_empty_trash
#
# Refer to Section 2.8 Page(s) 33 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_secure_empty_trash() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Secure Empty Trash"
    funct_defaults_check com.apple.finder EmptyTrashSecurely 1 int
  fi
}
