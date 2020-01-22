# audit_password_expiry
#
# Refer to Section(s) 7.1.1-3   Page(s) 143-146 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.1.1-3   Page(s) 166-8   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 7.1.1-3   Page(s) 147-9   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.4.1.1-4 Page(s) 245-51  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 10.1.1-3  Page(s) 136-8   CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.3       Page(s) 27      CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.1.1-11  Page(s) 17-26   CIS AIX Benchmark v1.1.0
# Refer to Section(s) 7.1       Page(s) 61-62   CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 7.2       Page(s) 101-3   CIS Solaris 10 Benchmark v5.1.0
# Refer to Section(s) 5.4.1.1-4 Page(s) 226-verbose_message "  CIS Amazon Linux v2.0.0
# Refer to Section(s) 5.4.1.1-4 Page(s) 238-43  CIS Ubuntu 16.04 v1.0.0
#.

audit_password_expiry () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Password Expiration Parameters on Active Accounts"
    if [ "$os_name" = "AIX" ]; then
      check_chsec /etc/security/user default mindiff 4
      check_chsec /etc/security/user default minage 1
      check_chsec /etc/security/user default maxage 13
      check_chsec /etc/security/user default minlen 8
      check_chsec /etc/security/user default minalpha 2
      check_chsec /etc/security/user default minother 2
      check_chsec /etc/security/user default maxrepeats 2
      check_chsec /etc/security/user default histexpire 13
      check_chsec /etc/security/user default histsize 20
      check_chsec /etc/security/user default maxexpired 2
      if [ "$os_version" > 4 ]; then
        if [ "$os_version" = "5" ]; then
          if [ "$os_update" > 3 ]; then
            check_chsec /etc/security/login.cfg usw pwd_algorithm ssha256
          fi
        else
          check_chsec /etc/security/login.cfg usw pwd_algorithm ssha256
        fi
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      check_file="/etc/default/passwd"
      check_file_value is $check_file MAXWEEKS eq 13 hash
      check_file_value is $check_file MINWEEKS eq 1 hash
      check_file_value is $check_file WARNWEEKS eq 4 hash
      check_file="/etc/default/login"
      check_file_value is $check_file DISABLETIME eq 3600 hash
    fi
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/login.defs"
      check_file_value is $check_file PASS_MAX_DAYS eq 90 hash
      check_file_value is $check_file PASS_MIN_DAYS eq 7 hash
      check_file_value is $check_file PASS_WARN_AGE eq 14 hash
      check_file_value is $check_file PASS_MIN_LEN eq 9 hash
      check_file_perms $check_file 0640 root root
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      if [ "$os_version" > 5 ]; then
        check_file="/etc/adduser.conf"
        check_file_value is $check_file passwdtype eq yes hash
        check_file_value is $check_file upwexpire eq 91d hash
      fi
    fi
  fi
}
