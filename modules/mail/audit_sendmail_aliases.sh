#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sendmail_aliases
#
# Make sure sendmail aliases are configured appropriately.
# Remove decode/uudecode alias
#.

audit_sendmail_aliases () {
  print_function "audit_sendmail_aliases"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message  "Sendmail Aliases" "check"
    disable_value    "/etc/aliases"     "decode" "hash"
    check_file_perms "/etc/aliases"     "0644"   "root" "root"
  fi
}
