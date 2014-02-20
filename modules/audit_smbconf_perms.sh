# audit_smbconf_perms
#
# The smb.conf file is the configuration file for the Samba suite and contains
# runtime configuration information for Samba.
# All configuration files must be protected from tampering.
#.

audit_smbconf_perms () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "SMB Config Permissions"
    funct_check_perms /etc/samba/smb.conf 0644 root root
  fi
}
