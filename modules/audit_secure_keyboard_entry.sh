# audit_secure_keyboard_entry
#
# Refer to Section 2.8  Page(s) 33 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 2.10 Page(s) 81 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_secure_keyboard_entry() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Secure Keyboard Entry"
    check_osx_defaults Terminal SecureKeyboardEntry 1 int
  fi
}
