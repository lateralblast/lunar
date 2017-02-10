# audit_secure_empty_trash
#
# Refer to Section 2.8 Page(s) 33 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_secure_empty_trash() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Secure Empty Trash"
    check_osx_defaults com.apple.finder EmptyTrashSecurely 1 int
  fi
}
