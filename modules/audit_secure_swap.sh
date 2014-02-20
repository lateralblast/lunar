# audit_secure_swap
#
# Passwords and other sensitive information can be extracted from insecure
# virtual memory, so it’s a good idea to secure virtual memory. If an attacker
# gained control of the Mac, the attacker would be able to extract user names
# and passwords or other kinds of data from the virtual memory swap files.
#.

audit_secure_swap () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Secure swap"
    funct_defaults_check /Library/Preferences/com.apple.virtualMemory UseEncryptedSwap yes bool
  fi
}
