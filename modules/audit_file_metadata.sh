#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_file_metadata
#
# Check Auditing of File Metadata Modification Events
#
# Refer to Section(s) 4.3 Page(s) 41-2 CIS Solaris 11.1 Benchmark v1.0.0
#.

audit_file_metadata () {
  print_module "audit_file_metadata"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "11" ]; then
      verbose_message   "Auditing of File Metadata Modification Events" "check"
      check_append_file "/etc/security/audit_event" "lck:AUE_CHMOD"     "hash"
      check_append_file "/etc/security/audit_event" "lck:AUE_CHOWN"     "hash"
      check_append_file "/etc/security/audit_event" "lck:AUE_FCHOWN"    "hash"
      check_append_file "/etc/security/audit_event" "lck:AUE_FCHMOD"    "hash"
      check_append_file "/etc/security/audit_event" "lck:AUE_LCHOWN"    "hash"
      check_append_file "/etc/security/audit_event" "lck:AUE_ACLSET"    "hash"
      check_append_file "/etc/security/audit_event" "lck:AUE_FACLSET"   "hash"
    fi
  fi
}
