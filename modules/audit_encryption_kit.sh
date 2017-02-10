# audit_encryption_kit
#
# Refer to Section(s) 1.3 Page(s) 15-6 CIS Solaris 10 Benchmark v5.1.0
#.

audit_encryption_kit () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "Encryption Toolkit"
      check_solaris_package SUNWcry
      check_solaris_package SUNWcryr
      if [ $os_update -le 4 ]; then
        check_solaris_package SUNWcryman
      fi
    fi
  fi
}
