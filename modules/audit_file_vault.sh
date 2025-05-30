#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_file_vault
#
# FileVault secures a system's data by automatically encrypting its boot volume and
# requiring a password or recovery key to access it.
#
# Refer to Section 2.6.1 Page(s) 28     CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 2.6.5 Page(s) 177-80 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_file_vault () {
  print_function "audit_file_vault"
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message "File Vault" "check"
    if [ "${audit_mode}" != 2 ]; then
      actual_value=$( diskutil cs list )
      if [ "${actual_value}" = "No CoreStorage logical volume groups found" ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "File Vault is not enabled"
        fi
        if [ "${audit_mode}" = 1 ] || [ "${audit_mode}" = 0 ]; then
          verbose_message "Open System Preferences"   "fix"
          verbose_message "Select Security & Privacy" "fix"
          verbose_message "Select FileVault"          "fix"
          verbose_message "Select Turn on FileVault"  "fix"
        fi
      else
        if [ "${audit_mode}" = 1 ]; then
          increment_secure "File Vault is enabled"
        fi
      fi
    else
      verbose_message     "Open System Preferences"   "fix"
      verbose_message     "Select Security & Privacy" "fix"
      verbose_message     "Select FileVault"          "fix"
      verbose_message     "Select Turn on FileVault"  "fix"
    fi
  fi
}
