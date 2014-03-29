# audit_smbpasswd_perms
#
# Set the permissions of the smbpasswd file to 600, so that the contents of
# the file can not be viewed by any user other than root
# If the smbpasswd file were set to read access for other users, the lanman
# hashes could be accessed by an unauthorized user and cracked using various
# password cracking tools. Setting the file to 600 limits access to the file
# by users other than root.
#
# Refer to Section(s) 11.4-5 Page(s) 144-5 CIS Solaris 10 v1.1.0
#.

audit_smbpasswd_perms () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "SMB Password File"
    funct_check_perms /etc/sfw/private/smbpasswd 0600 root root
  fi
}
