#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_privilege_events
#
# Auditing of Process and Privilege Events
#
# Refer to Section(s) 4.4 Page(s) 43-44 CIS Solaris 11.1 Benchmark v1.0.0
#.

audit_privilege_events () {
  print_module "audit_privilege_events"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "11" ]; then
      verbose_message   "Auditing of Privileged Events" "check"
      check_append_file "/etc/security/audit_event"     "lck:AUE_CHROOT"      "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_SETREUID"    "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_SETREGID"    "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_FCHROOT"     "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_PFEXEC"      "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_SETUID"      "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_NICE"        "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_SETGID"      "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_PRIOCNTLSYS" "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_SETEGID"     "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_SETEUID"     "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_SETPPRIV"    "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_SETSID"      "hash"
      check_append_file "/etc/security/audit_event"     "lck:AUE_SETPGID"     "hash"
    fi
  fi
}
