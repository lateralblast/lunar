# audit_passwd_perms
#
# Audit password file permission under Linux. This stops password hashes and
# other information being disclosed. Password hashes can be used to crack
# passwords via brute force cracking tools.
#.

audit_passwd_perms () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Group and Password File Permissions"
    funct_check_perms /etc/group 0644 root root
    funct_check_perms /etc/passwd 0644 root root
    funct_check_perms /etc/gshadow 0400 root root
    funct_check_perms /etc/shadow 0400 root root
  fi
}
