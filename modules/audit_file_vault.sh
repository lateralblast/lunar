# audit_file_vault
#
# Refer to Section 2.6.1 Page(s) 28 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_file_vault() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "File Vault"
    if [ "$audit_mode" != 2 ]; then
      actual_value=$( diskutil cs list )
      if [ "$actual_value" = "No CoreStorage logical volume groups found" ]; then
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "File Vault is not enabled"
        fi
        if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
          verbose_message "" fix
          verbose_message "Open System Preferences" fix
          verbose_message "Select Security & Privacy" fix
          verbose_message "Select FileVault" fix
          verbose_message "Select Turn on FileVault" fix
          verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          increment_secure "File Vault is enabled"
        fi
      fi
    else
      verbose_message "" fix
      verbose_message "Open System Preferences" fix
      verbose_message "Select Security & Privacy" fix
      verbose_message "Select FileVault" fix
      verbose_message "Select Turn on FileVault" fix
      verbose_message "" fix
    fi
  fi
}
