# audit_secure_empty_trash
#
# Configuring Secure Empty Trash mitigates the risk of an admin user on the
# system recovering sensitive files that the user has deleted. It is possible
# for anyone with physical access to the device to get access if FileVault is
# not used.
#
# Refer to Section 2.8 Page(s) 33 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_secure_empty_trash() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Secure Empty Trash"
    funct_defaults_check com.apple.finder EmptyTrashSecurely 1 int
  fi
}
