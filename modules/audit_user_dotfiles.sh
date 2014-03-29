# audit_user_dotfiles
#
# While the system administrator can establish secure permissions for users'
# "dot" files, the users can easily override these.
# Group or world-writable user configuration files may enable malicious users to
# steal or modify other users' data or to gain another user's system privileges.
#
# Refer to Section(s) 9.2.8 Page(s) 167-168 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.2 Page(s) 25 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 9.8 Page(s) 77-8 CIS Solaris 11.1 v1.0.0
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
