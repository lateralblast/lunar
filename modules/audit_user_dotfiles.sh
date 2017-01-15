# audit_user_dotfiles
#
# While the system administrator can establish secure permissions for users'
# "dot" files, the users can easily override these.
# Group or world-writable user configuration files may enable malicious users to
# steal or modify other users' data or to gain another user's system privileges.
#
# Refer to Section(s) 9.2.8  Page(s) 167-168 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.2.10 Page(s) 284     CIS Red Hat Linux 7 Benchmark v2.1.0
# Refer to Section(s) 9.2.8  Page(s) 193-4   CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 13.8   Page(s) 159     CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.2    Page(s) 25      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 9.8    Page(s) 77-8    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.8    Page(s) 122     CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.10 Page(s) 262     CIS Amazon Linux Benchmark v2.0.0
#.

audit_user_dotfiles () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "User Dot Files"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  User dot file permissions"
    fi
    check_fail=0
    for home_dir in `cat /etc/passwd |cut -f6 -d":" |grep -v "^/$"`; do
      for check_file in $home_dir/.[A-Za-z0-9]*; do
        if [ -f "$check_file" ]; then
          funct_check_perms $check_file 0600
        fi
      done
    done
  fi
}
