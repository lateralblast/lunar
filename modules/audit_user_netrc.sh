# audit_user_netrc
#
# Refer to Section(s) 9.2.9    Page(s) 168-169     CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.9,20 Page(s) 194-5,205-6 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.9    Page(s) 171-2       CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.13-4 Page(s) 286-8       CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.9,18  Page(s) 160-1,167   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.2.13-4 Page(s) 265-7       CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 7.2      Page(s) 25          CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.5.1    Page(s) 101-2       CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.9,20   Page(s) 78-9,86     CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.9,20   Page(s) 122-3,132-3 CIS Solaris 10 Benchmark v1.1.0
#.

audit_user_netrc () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "User Netrc Files"
    check_fail=0
    for home_dir in $( cat /etc/passwd | cut -f6 -d":" | grep -v "^/$" ); do
      check_file="$home_dir/.netrc"
      if [ -f "$check_file" ]; then
        check_fail=1
        check_file_perms $check_file 0600
      fi
    done
    if [ "$check_fail" != 1 ]; then
      if [ "$audit_mode" = 1 ]; then
        increment_secure "No user netrc files exist"
      fi
    fi
  fi
}
