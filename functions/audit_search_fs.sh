# audit_search_fs
#
# Audit Filesystem
#
# Run various filesystem audits, add support for NetBackup
#.

audit_search_fs () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Filesystem Search"
    nb_check=$( pkginfo -l | grep SYMCnbclt | grep PKG | awk '{print $2}' )
    if [ "$nb_check" != "SYMCnbclt" ]; then
      audit_bpcd
      audit_vnetd
      audit_vopied
      audit_bpjava_msvc
    else
      check_file="/etc/hosts.allow"
      funct_file_value $check_file bpcd colon " ALL" hash
      funct_file_value $check_file vnetd colon " ALL" hash
      funct_file_value $check_file bpcd vopied " ALL" hash
      funct_file_value $check_file bpcd bpjava-msvc " ALL" hash
    fi
    audit_extended_attributes
  fi
  audit_writable_files
  audit_suid_files
  audit_file_perms
  audit_sticky_bit
}
