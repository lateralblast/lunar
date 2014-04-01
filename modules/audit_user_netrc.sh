# audit_user_netrc
#
# While the system administrator can establish secure permissions for users'
# .netrc files, the users can easily override these.
# Users' .netrc files may contain unencrypted passwords that may be used to
# attack other systems.
#
# Refer to Section(s) 9.2.9 Page(s) 168-169 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.9,20 Page(s) 194-5,205-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.9 Page(s) 171-2 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 13.9,18 Page(s) 160-1,167 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.2 Page(s) 25 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.5.1 Page(s) 101-2 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.9,20 Page(s) 78-9,86 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.9,20 Page(s) 122-3,132-3 CIS Solaris 10 v1.1.0
#.

audit_user_netrc () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "User Netrc Files"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  User netrc file permissions"
    fi
    check_fail=0
    for home_dir in `cat /etc/passwd |cut -f6 -d":" |grep -v "^/$"`; do
      check_file="$home_dir/.netrc"
      if [ -f "$check_file" ]; then
        check_fail=1
        funct_check_perms $check_file 0600
      fi
    done
    if [ "$check_fail" != 1 ]; then
      if [ "$audit_mode" = 1 ]; then
        total=`expr $total + 1`
        score=`expr $score + 1`
        echo "Secure:    No user netrc files exist [$score]"
      fi
    fi
  fi
}
