# audit_sendmail_aliases
#
# Make sure sendmail aliases are configured appropriately.
# Remove decode/uudecode alias
#.

audit_sendmail_aliases () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Sendmail Aliases"
    check_file="/etc/aliases"
    disable_value $check_file "decode" hash
    check_file_perms $check_file 0644 root root
  fi
}
