# audit_security_banner
#
# Refer to http://www.justice.gov/criminal/cybercrime/
# Refer to Section(s) 7.4             Page(s) 25 CIS  CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.11.11,2.12.12 Page(s) 198,216 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 8.1.1           Page(s) 172-3   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 8.1             Page(s) 152-3   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 1.7.1.4-6       Page(s) 84-8    CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 11.1            Page(s) 142-3   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.1             Page(s) 68-9    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 8.1             Page(s) 111-2   CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 1.7.1.4-6       Page(s) 74-6    CIS Amazon Linux Benchmark v2.0.0
#.

audit_security_banner () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Warnings for Standard Login Services"
    if [ "$os_name" = "AIX" ]; then
      user_name="bin"
      group_name="bin"
    else
      user_name="root"
      group_name="root"
    fi
    check_file="/etc/motd"
    check_file_exists $check_file yes
    if [ -f "$check_file" ]; then
      check_file_perms $check_file 0644 $user_name $group_name
    fi
    check_file="/etc/issue"
    check_file_exists $check_file yes
    if [ -f "$check_file" ]; then
      check_file_perms $check_file 0644 $user_name $group_name
    fi
  fi
}
