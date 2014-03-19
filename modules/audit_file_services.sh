# audit_file_services
#
# Audit file permissions
#.

audit_file_services () {
  audit_syslog_perms
  audit_volfs
  audit_autofs
  audit_dfstab
  audit_mount_setuid
  audit_mount_nodev
  audit_mount_fdi
  audit_nfs
  audit_uucp
  audit_cd_sharing
}
