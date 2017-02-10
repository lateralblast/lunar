# audit_privilege_events
#
# Auditing of Process and Privilege Events
#
# Refer to Section(s) 4.4 Page(s) 43-44 CIS Solaris 11.1 Benchmark v1.0.0
#.

audit_privilege_events () {
  check_file="/etc/security/audit_event"
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "11" ]; then
      verbose_message "Auditing of Privileged Events"
      check_append_file $check_file "lck:AUE_CHROOT" hash
      check_append_file $check_file "lck:AUE_SETREUID" hash
      check_append_file $check_file "lck:AUE_SETREGID" hash
      check_append_file $check_file "lck:AUE_FCHROOT" hash
      check_append_file $check_file "lck:AUE_PFEXEC" hash
      check_append_file $check_file "lck:AUE_SETUID" hash
      check_append_file $check_file "lck:AUE_NICE" hash
      check_append_file $check_file "lck:AUE_SETGID" hash
      check_append_file $check_file "lck:AUE_PRIOCNTLSYS" hash
      check_append_file $check_file "lck:AUE_SETEGID" hash
      check_append_file $check_file "lck:AUE_SETEUID" hash
      check_append_file $check_file "lck:AUE_SETPPRIV" hash
      check_append_file $check_file "lck:AUE_SETSID" hash
      check_append_file $check_file "lck:AUE_SETPGID" hash
    fi
  fi
}
