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
      funct_verbose_message "Auditing of Privileged Events"
      funct_append_file $check_file "lck:AUE_CHROOT" hash
      funct_append_file $check_file "lck:AUE_SETREUID" hash
      funct_append_file $check_file "lck:AUE_SETREGID" hash
      funct_append_file $check_file "lck:AUE_FCHROOT" hash
      funct_append_file $check_file "lck:AUE_PFEXEC" hash
      funct_append_file $check_file "lck:AUE_SETUID" hash
      funct_append_file $check_file "lck:AUE_NICE" hash
      funct_append_file $check_file "lck:AUE_SETGID" hash
      funct_append_file $check_file "lck:AUE_PRIOCNTLSYS" hash
      funct_append_file $check_file "lck:AUE_SETEGID" hash
      funct_append_file $check_file "lck:AUE_SETEUID" hash
      funct_append_file $check_file "lck:AUE_SETPPRIV" hash
      funct_append_file $check_file "lck:AUE_SETSID" hash
      funct_append_file $check_file "lck:AUE_SETPGID" hash
    fi
  fi
}
