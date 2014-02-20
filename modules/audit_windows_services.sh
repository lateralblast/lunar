# audit_windows_services
#
# Audit windows services
#.

audit_windows_services () {
  audit_smbpasswd_perms
  audit_smbconf_perms
  audit_samba
  audit_wins
  audit_winbind
}
