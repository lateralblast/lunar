# audit_home_perms
#
# While the system administrator can establish secure permissions for users'
# home directories, the users can easily override these.
# Group or world-writable user home directories may enable malicious users to
# steal or modify other users' data or to gain another user's system privileges.
#.

audit_home_perms () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Home Directory Permissions"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  User home directory permissions"
    fi
    check_fail=0
    for home_dir in `cat /etc/passwd |cut -f6 -d":" |grep -v "^/$" |grep "home"`; do
      if [ -d "$home_dir" ]; then
        funct_check_perms $home_dir 0700
      fi
    done
  fi
}
