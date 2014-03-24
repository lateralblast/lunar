# audit_passwd_perms
#
# Audit password file permission under Linux. This stops password hashes and
# other information being disclosed. Password hashes can be used to crack
# passwords via brute force cracking tools.
#
# The /etc/passwd file contains user account information that is used by many
# system utilities and therefore must be readable for these utilities to operate.
#
# The /etc/shadow file is used to store the information about user accounts
# that is critical to the security of those accounts, such as the hashed
# password and other security information.
#
# The /etc/gshadow file contains information about group accounts that is
# critical to the security of those accounts, such as the hashed password and
# other security information.
#
# The /etc/group file contains a list of all the valid groups defined in the
# system. The command below allows read/write access for root and read access
# for everyone else.
#
#  Refer to Section 9.1.2-9 Page(s) 153-9 CIS CentOS Linux 6 Benchmark v1.0.0
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
