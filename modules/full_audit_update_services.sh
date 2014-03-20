# full_audit_update_services
#
# Update services
#.

full_audit_update_services () {
  apply_latest_patches
  audit_yum_conf
  audit_software_update
}
