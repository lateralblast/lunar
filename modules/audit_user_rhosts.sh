# audit_user_rhosts
#
# Refer to Section(s) 9.2.10 Page(s) 169-70 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.10 Page(s) 195-6  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.10 Page(s) 172-3  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 6.2.14 Page(s) 289    CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 13.10  Page(s) 161    CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.2    Page(s) 25     CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.5.1  Page(s) 101-2  CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.10   Page(s) 79     CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 9.10   Page(s) 124    CIS Solaris 10 Benchmark v1.1.0
# Refer to Section(s) 6.2.14 Page(s) 267-8  CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 6.2.14 Page(s) 281    CIS Ubuntu 16.04 Benchmark v2.0.0
#.

audit_user_rhosts () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "User RHosts Files"
    check_fail=0
    for home_dir in $( cat /etc/passwd | cut -f6 -d":" | grep -v "^/$" ); do
      check_file="$home_dir/.rhosts"
      if [ -f "$check_file" ]; then
        check_fail=1
        check_file_exists $check_file no
      fi
    done
    if [ "$check_fail" != 1 ]; then
      if [ "$audit_mode" = 1 ]; then
        increment_secure "No user rhosts files exist"
      fi
    fi
  fi
}
