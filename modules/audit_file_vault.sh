# audit_file_vault
#
# Encrypting sensitive data minimizes the likelihood of unauthorized users
# gaining access to it.
#
# Refer to Section 2.6.1 Page(s) 28 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_file_vault() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "File Vault"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  File Vault is enabled"
      actual_value=`diskutil cs list`
      if [ "$actual_value" = "No CoreStorage logical volume groups found" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score - 1`
          echo "Warning:   File Vault is not enabled [$score]"
        fi
        if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
          funct_verbose_message "" fix
          funct_verbose_message "Open System Preferences" fix
          funct_verbose_message "Select Security & Privacy" fix
          funct_verbose_message "Select FileVault" fix
          funct_verbose_message "Select Turn on FileVault" fix
          funct_verbose_message "" fix
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    File Vault is enabled [$score]"
        fi
      fi
    else
      funct_verbose_message "" fix
      funct_verbose_message "Open System Preferences" fix
      funct_verbose_message "Select Security & Privacy" fix
      funct_verbose_message "Select FileVault" fix
      funct_verbose_message "Select Turn on FileVault" fix
      funct_verbose_message "" fix
    fi
  fi
}
