# audit_audit_class
#
# Create audit class on Solaris 11
# Need to investigate more auditing capabilities on Solaris 10
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
