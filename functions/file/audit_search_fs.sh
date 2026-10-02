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
    print_function  "audit_search_fs"
    verbose_message "Filesystem Search"
    command="pkginfo -l | grep SYMCnbclt | grep PKG | awk '{print \$2}'"
    command_message "${command}"
    check=$( eval   "${command}" )
    if [ "${check}" != "SYMCnbclt" ]; then
      audit_bpcd
      audit_vnetd
      audit_vopied
      audit_bpjava_msvc
    else
      check_file_value "is" "/etc/hosts.deny" "bpcd"        "colon" " ALL" "hash"
      check_file_value "is" "/etc/hosts.deny" "vnetd"       "colon" " ALL" "hash"
      check_file_value "is" "/etc/hosts.deny" "vopied"      "colon" " ALL" "hash"
      check_file_value "is" "/etc/hosts.deny" "bpjava-msvc" "colon" " ALL" "hash"
    fi
    audit_extended_attributes
  fi
  audit_writable_files
  audit_suid_files
  audit_file_perms
  audit_sticky_bit
}
