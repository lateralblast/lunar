# audit_encryption_kit
#
# The Solaris 10 Encryption Kit contains kernel modules that implement
# various encryption algorithms for IPsec and Kerberos, utilities that
# encrypt and decrypt files from the command line, and libraries with
# functions that application programs call to perform encryption.
# The Encryption Kit enables larger key sizes (> 128) of the following
# algorithms:
#
# AES (128, 192, and 256-bit key sizes)
# Blowfish (32 to 448-bit key sizes in 8-bit increments)
# RCFOUR/RC4 (8 to 2048-bit key sizes)
#
# This action is not needed for systems running Solaris 10 08/07 and newer
# as the Solaris 10 Encryption Kit is installed by default.
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
