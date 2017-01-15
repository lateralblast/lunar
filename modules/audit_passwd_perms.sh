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
# Refer to Section(s) 9.1.2-9  Page(s) 153-9   CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.2-9  Page(s) 177-83  CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.2-9  Page(s) 157-62  CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.1.2-9  Page(s) 261-8   CIS Red Hat Linux 7 Benchmark v2.1.0
# Refer to Section(s) 12.2-7   Page(s) 146-50  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.1.2-9  Page(s) 239-46  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.1      Page(s) 21      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.1-3 Page(s) 192-4   CIS AIX Benchmark v1.1.0
#.

audit_passwd_perms () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Group and Password File Permissions"
    if [ "$os_name" = "AIX" ]; then
      for check_file in /etc/passwd /etc/group; do
        funct_check_perms $check_file 0644 root security
      done
      check_dir="/etc/security"
      funct_check_perms $check_dir 0750 root security
    fi
    if [ "$os_name" = "Linux" ]; then
      for check_file in /etc/passwd /etc/group ; do
        funct_check_perms $check_file 0644 root root
      done
      for check_file in /etc/shadow /etc/gshadow; do
        funct_check_perms $check_file 0600 root root
      done
      for check_file in /etc/group- /etc/passwd- /etc/shadow- /etc/gshadow-; do
        funct_check_perms $check_file 0600 root root
      done
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      for check_file in /etc/passwd /etc/group /etc/pwd.db; do
        funct_check_perms $check_file 0644 root wheel
      done
      for check_file in /etc/master.passwd /etc/spwd.db; do
        funct_check_perms $check_file 0644 root wheel
      done
    fi
  fi
}
