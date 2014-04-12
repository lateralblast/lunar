# audit_file_metadata
#
# Auditing of File Metadata Modification Events
#
# The Solaris Audit service can be configured to record file metadata
# modification events for every process running on the system.
# This will allow the auditing service to determine when file ownership,
# permissions and related information is changed.
# This recommendation will provide an audit trail that contains information
# related to changes of file metadata. The Solaris Audit service is used to
# provide a more centralized and complete window into activities such as these.
#
# Refer to Section(s) 4.3 Page(s) 41-2 CIS Solaris 11.1 v1.0.0
#.

audit_file_metadata () {
  check_file = "/etc/security/audit_event"
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "11" ]; then
      funct_verbose_message "Auditing of File Metadata Modification Events"
      funct_append_file $check_file "lck:AUE_CHMOD" hash
      funct_append_file $check_file "lck:AUE_CHOWN" hash
      funct_append_file $check_file "lck:AUE_FCHOWN" hash
      funct_append_file $check_file "lck:AUE_FCHMOD" hash
      funct_append_file $check_file "lck:AUE_LCHOWN" hash
      funct_append_file $check_file "lck:AUE_ACLSET" hash
      funct_append_file $check_file "lck:AUE_FACLSET" hash
    fi
  fi
}
