# audit_secure_swap
#
# Refer to Section(s) 1.4.13.6 Page(s) 47-8 CIS Apple OS X 10.6 Benchmark v1.0.0
#.

audit_secure_swap () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Secure swap"
    funct_defaults_check /Library/Preferences/com.apple.virtualMemory UseEncryptedSwap yes bool
  fi
}
