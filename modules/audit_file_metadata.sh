# audit_file_metadata
#
# Refer to Section(s) 4.3 Page(s) 41-2 CIS Solaris 11.1 Benchmark v1.0.0
#.

audit_file_metadata () {
  check_file="/etc/security/audit_event"
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "11" ]; then
      verbose_message "Auditing of File Metadata Modification Events"
      check_append_file $check_file "lck:AUE_CHMOD" hash
      check_append_file $check_file "lck:AUE_CHOWN" hash
      check_append_file $check_file "lck:AUE_FCHOWN" hash
      check_append_file $check_file "lck:AUE_FCHMOD" hash
      check_append_file $check_file "lck:AUE_LCHOWN" hash
      check_append_file $check_file "lck:AUE_ACLSET" hash
      check_append_file $check_file "lck:AUE_FACLSET" hash
    fi
  fi
}
