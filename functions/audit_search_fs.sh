#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_search_fs
#
# Audit Filesystem
#
# Run various filesystem audits, add support for NetBackup
#.

audit_search_fs () {
  if [ "${os_name}" = "SunOS" ]; then
    verbose_message "Filesystem Search"
    check=$( pkginfo -l | grep SYMCnbclt | grep PKG | awk '{print $2}' )
    if [ "${check}" != "SYMCnbclt" ]; then
      audit_bpcd
      audit_vnetd
      audit_vopied
      audit_bpjava_msvc
    else
      funct_file_value "/etc/hosts.allow" "bpcd"  "colon"       " ALL" "hash"
      funct_file_value "/etc/hosts.allow" "vnetd" "colon"       " ALL" "hash"
      funct_file_value "/etc/hosts.allow" "bpcd"  "vopied"      " ALL" "hash"
      funct_file_value "/etc/hosts.allow" "bpcd"  "bpjava-msvc" " ALL" "hash"
    fi
    audit_extended_attributes
  fi
  audit_writable_files
  audit_suid_files
  audit_file_perms
  audit_sticky_bit
}
