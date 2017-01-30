# audit_secure_keyboard_entry
#
# Refer to Section 2.8 Page(s) 33 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_secure_keyboard_entry() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Secure Keyboard Entry"
    funct_defaults_check Terminal SecureKeyboardEntry 1 int
  fi
}
