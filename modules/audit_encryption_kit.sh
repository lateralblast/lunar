# audit_encryption_kit
#
# Refer to Section(s) 1.3 Page(s) 15-6 CIS Solaris 10 Benchmark v5.1.0
#.

audit_encryption_kit () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Encryption Toolkit"
      funct_solaris_package SUNWcry
      funct_solaris_package SUNWcryr
      if [ $os_update -le 4 ]; then
        funct_solaris_package SUNWcryman
      fi
    fi
  fi
}
