# audit_audit_class
#
# Refer to Section(s) 4.1-5 Page(s) 39-45 CIS Solaris 11.1 v1.0.0
#.

audit_audit_class () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "11" ]; then
      audit_create_class
      audit_network_connections
      audit_file_metadata
      audit_privilege_events
    fi
  fi
}
