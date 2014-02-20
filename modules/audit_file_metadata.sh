# audit_file_metadata
#
# Auditing of File Metadata Modification Events
#.

audit_file_metadata () {
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
