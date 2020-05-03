# audit_smbpasswd_perms
#
# Refer to Section(s) 11.4-5 Page(s) 144-5 CIS Solaris 10 Benchmark v1.1.0
#.

audit_smbpasswd_perms () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "SMB Password File"
    check_file_perms /etc/sfw/private/smbpasswd 0600 root root
  fi
}
